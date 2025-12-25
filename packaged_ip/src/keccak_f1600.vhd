-- ============================================================================
-- Keccak-f[1600] Permutation
-- Clean VHDL implementation of the 24-round Keccak permutation
-- 
-- This module performs one round per clock cycle (24 cycles total)
-- All theta, rho, pi, chi, iota steps are computed combinationally per round
-- ============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.keccak_pkg.all;

entity keccak_f1600 is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        -- Control
        start      : in  std_logic;
        done       : out std_logic;
        -- State I/O (directly accessible as array)
        state_in   : in  state_t;
        state_out  : out state_t
    );
end entity keccak_f1600;

architecture rtl of keccak_f1600 is
    -- Internal state register
    signal state_reg : state_t;
    
    -- Round counter (0 to 23)
    signal round : unsigned(4 downto 0);
    
    -- FSM
    type fsm_state_t is (IDLE, RUNNING, DONE_STATE);
    signal fsm : fsm_state_t;
    
    -- Combinational signals for one round
    signal state_after_round : state_t;
    
begin

    -- ========================================================================
    -- Combinational: Compute one complete round (theta, rho, pi, chi, iota)
    -- ========================================================================
    process(state_reg, round)
        -- Theta step variables (using lane5_t from package)
        variable C : lane5_t;
        variable D : lane5_t;
        variable after_theta : state_t;
        
        -- Rho and Pi step variables
        variable after_rho_pi : state_t;
        variable rotated : lane_t;
        variable x_idx, y_idx, new_x, new_y : integer;
        
        -- Chi step variables
        variable after_chi : state_t;
        
        -- Iota step
        variable after_iota : state_t;
        
    begin
        -- ====================================================================
        -- Theta Step
        -- C[x] = state[x,0] xor state[x,1] xor state[x,2] xor state[x,3] xor state[x,4]
        -- D[x] = C[x-1] xor rot(C[x+1], 1)
        -- state[x,y] = state[x,y] xor D[x]
        -- ====================================================================
        for x_idx in 0 to 4 loop
            C(x_idx) := state_reg(idx(x_idx,0)) xor state_reg(idx(x_idx,1)) xor 
                    state_reg(idx(x_idx,2)) xor state_reg(idx(x_idx,3)) xor state_reg(idx(x_idx,4));
        end loop;
        
        for x_idx in 0 to 4 loop
            D(x_idx) := C((x_idx + 4) mod 5) xor rol64(C((x_idx + 1) mod 5), 1);
        end loop;
        
        for y_idx in 0 to 4 loop
            for x_idx in 0 to 4 loop
                after_theta(idx(x_idx,y_idx)) := state_reg(idx(x_idx,y_idx)) xor D(x_idx);
            end loop;
        end loop;
        
        -- ====================================================================
        -- Rho and Pi Steps (combined)
        -- Rho: rotate each lane by its offset
        -- Pi: rearrange lanes - new position (y, 2*x + 3*y) gets old position (x, y)
        -- ====================================================================
        for y_idx in 0 to 4 loop
            for x_idx in 0 to 4 loop
                -- Apply rho rotation
                rotated := rol64(after_theta(idx(x_idx,y_idx)), RHO_OFFSETS(x_idx)(y_idx));
                -- Apply pi permutation: destination is (y, 2*x + 3*y mod 5)
                new_x := y_idx;
                new_y := (2*x_idx + 3*y_idx) mod 5;
                after_rho_pi(idx(new_x, new_y)) := rotated;
            end loop;
        end loop;
        
        -- ====================================================================
        -- Chi Step
        -- state[x,y] = state[x,y] xor ((not state[x+1,y]) and state[x+2,y])
        -- ====================================================================
        for y_idx in 0 to 4 loop
            for x_idx in 0 to 4 loop
                after_chi(idx(x_idx,y_idx)) := after_rho_pi(idx(x_idx,y_idx)) xor 
                    (not after_rho_pi(idx((x_idx+1) mod 5, y_idx)) and after_rho_pi(idx((x_idx+2) mod 5, y_idx)));
            end loop;
        end loop;
        
        -- ====================================================================
        -- Iota Step
        -- state[0,0] = state[0,0] xor RC[round]
        -- ====================================================================
        after_iota := after_chi;
        after_iota(0) := after_chi(0) xor RC(to_integer(round));
        
        state_after_round <= after_iota;
    end process;

    -- ========================================================================
    -- Sequential: FSM and round counter
    -- ========================================================================
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
                        state_reg <= state_after_round;
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
    
    -- Output state
    state_out <= state_reg;

end architecture rtl;
