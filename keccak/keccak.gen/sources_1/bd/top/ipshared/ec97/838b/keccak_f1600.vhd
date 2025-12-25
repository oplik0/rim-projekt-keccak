library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.keccak_pkg.all;

entity keccak_f1600 is
    generic (
        -- Set to true to enable pipelining
        G_PIPELINE : boolean := true
    );
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        start      : in  std_logic;
        done       : out std_logic;
        state_in   : in  state_t;
        state_out  : out state_t
    );
end entity keccak_f1600;

architecture rtl of keccak_f1600 is
    -- optimized round constants from https://www.mdpi.com/2078-2489/14/9/475
    type rc7_t is array (0 to 23) of std_logic_vector(6 downto 0);
    -- Bit mapping: (6)=bit63, (5)=bit31, (4)=bit15, (3)=bit7, (2)=bit3, (1)=bit1, (0)=bit0
    constant RC7 : rc7_t := (
        "0000001",
        "0011010",
        "1011110",
        "1110000",
        "0011111",
        "0100001",
        "1111001",
        "1010101",
        "0001110",
        "0001100",
        "0110101",
        "0100110",
        "0111111",
        "1001111",
        "1011101",
        "1010011",
        "1010010",
        "1001000",
        "0010110",
        "1100110",
        "1111001",
        "1011000",
        "0100001",
        -- NOT "1010100"...
        "1110100" -- THE PAPER WAS WRONG HERE IT HAD A TYPO LITERALLY HOURS OF MY LIFE WASTED ON A BIT FLIP
    );

    signal state_reg : state_t;
    
    -- Pipeline register
    signal theta_out_reg : state_t;
    
    signal round : unsigned(4 downto 0);
    
    -- only used for pipelining, 0 for theta 1 for the further steps
    signal stage : std_logic;
    
    -- simple main state machine
    type fsm_state_t is (IDLE, RUNNING, DONE_STATE);
    signal fsm : fsm_state_t;
    
    signal theta_out : state_t;
    signal rho_pi_out : state_t;
    signal chi_out : state_t;
    signal iota_out : state_t;
    signal round_complete : state_t;  -- Only used in non-pipelined mode
    
    signal C : lane5_t;
    signal D : lane5_t;

begin

    -- Calculate column parity C[x] = state[x,0] ^ state[x,1] ^ ... ^ state[x,4]
    gen_theta_c: for x in 0 to 4 generate
        C(x) <= state_reg(idx(x,0)) xor state_reg(idx(x,1)) xor 
                state_reg(idx(x,2)) xor state_reg(idx(x,3)) xor state_reg(idx(x,4));
    end generate;
    
    -- Calculate D[x] = C[x-1] ^ ROL(C[x+1], 1)
    gen_theta_d: for x in 0 to 4 generate
        D(x) <= C((x + 4) mod 5) xor rol64(C((x + 1) mod 5), 1);
    end generate;
    
    -- Apply theta: state[x,y] ^= D[x]
    gen_theta_apply_y: for y in 0 to 4 generate
        gen_theta_apply_x: for x in 0 to 4 generate
            theta_out(idx(x,y)) <= state_reg(idx(x,y)) xor D(x);
        end generate;
    end generate;

    -- rho and pi are still combined, honeslty not sure if it couldn't be optimized better in hw but I didn't want to rethink it :D    
    gen_rho_pi: process(theta_out, theta_out_reg)
        variable theta_state : state_t;
        variable rotated : lane_t;
        variable new_x, new_y : integer;
    begin
        -- Use the correct input based on pipelining
        if G_PIPELINE then
            theta_state := theta_out_reg;
        else
            theta_state := theta_out;
        end if;
        
        for y in 0 to 4 loop
            for x in 0 to 4 loop
                rotated := rol64(theta_state(idx(x,y)), RHO_OFFSETS(x)(y));
                new_x := y;
                new_y := (2*x + 3*y) mod 5;
                rho_pi_out(idx(new_x, new_y)) <= rotated;
            end loop;
        end loop;
    end process;

    gen_chi_y: for y in 0 to 4 generate
        gen_chi_x: for x in 0 to 4 generate
            chi_out(idx(x,y)) <= rho_pi_out(idx(x,y)) xor 
                (not rho_pi_out(idx((x+1) mod 5, y)) and rho_pi_out(idx((x+2) mod 5, y)));
        end generate;
    end generate;

    process(chi_out, round)
        variable rc7_val : std_logic_vector(6 downto 0);
        variable lane0 : lane_t;
    begin
        -- Copy all lanes from chi_out to iota_out
        iota_out <= chi_out;
        
        -- Get the 7-bit RC for current round
        rc7_val := RC7(to_integer(round));
        
        -- Build lane 0 with XORed RC bits
        -- from https://www.mdpi.com/2078-2489/14/9/475#New_Hardware_Optimization%C2%A0Strategy
        lane0 := chi_out(0);
        lane0(0)  := chi_out(0)(0)  xor rc7_val(0);
        lane0(1)  := chi_out(0)(1)  xor rc7_val(1);
        lane0(3)  := chi_out(0)(3)  xor rc7_val(2);
        lane0(7)  := chi_out(0)(7)  xor rc7_val(3);
        lane0(15) := chi_out(0)(15) xor rc7_val(4);
        lane0(31) := chi_out(0)(31) xor rc7_val(5);
        lane0(63) := chi_out(0)(63) xor rc7_val(6);
        iota_out(0) <= lane0;
    end process;

    gen_non_pipelined: if not G_PIPELINE generate
        round_complete <= iota_out;
    end generate;

    gen_pipelined_fsm: if G_PIPELINE generate
        -- Two-stage pipelined version, should provide higher throughput at the cost of latency
        -- based on https://www.mdpi.com/2078-2489/14/9/475
        process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    fsm <= IDLE;
                    round <= (others => '0');
                    stage <= '0';
                    state_reg <= (others => (others => '0'));
                    theta_out_reg <= (others => (others => '0'));
                    done <= '0';
                else
                    case fsm is
                        when IDLE =>
                            done <= '0';
                            if start = '1' then
                                state_reg <= state_in;
                                round <= (others => '0');
                                stage <= '0';
                                fsm <= RUNNING;
                            end if;
                        
                        when RUNNING =>
                            if stage = '0' then
                                -- Theta
                                theta_out_reg <= theta_out;
                                stage <= '1';
                            else
                                -- Rho/Pi/Chi/Iota
                                state_reg <= iota_out;
                                stage <= '0';
                                
                                if round = 23 then
                                    fsm <= DONE_STATE;
                                else
                                    round <= round + 1;
                                end if;
                            end if;
                        
                        when DONE_STATE =>
                            done <= '1';
                            fsm <= IDLE;
                    end case;
                end if;
            end if;
        end process;
    end generate;
    
    gen_non_pipelined_fsm: if not G_PIPELINE generate
        -- First version, *should* be slower, but I've been burned before by naive attempts at pipelining, which is why I'm keeping it :D
        process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    fsm <= IDLE;
                    round <= (others => '0');
                    state_reg <= (others => (others => '0'));
                    done <= '0';
                else
                    case fsm is
                        when IDLE =>
                            done <= '0';
                            if start = '1' then
                                state_reg <= state_in;
                                round <= (others => '0');
                                fsm <= RUNNING;
                            end if;
                        
                        when RUNNING =>
                            state_reg <= round_complete;
                            if round = 23 then
                                fsm <= DONE_STATE;
                            else
                                round <= round + 1;
                            end if;
                        
                        when DONE_STATE =>
                            done <= '1';
                            fsm <= IDLE;
                    end case;
                end if;
            end if;
        end process;
    end generate;
    
    state_out <= state_reg;

end architecture rtl;
