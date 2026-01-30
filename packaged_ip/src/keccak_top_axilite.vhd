-- ============================================================================
-- Keccak Top Module with Pure AXI-Lite Interface (No AXI-Stream)
-- ============================================================================
-- This version eliminates the AXI-Stream interface and uses AXI-Lite
-- registers for data I/O, making it simpler to debug and integrate.
--
-- Register Map:
--   0x00 : AP_CTRL (bit 0=start, bit 1=done, bit 2=idle, bit 3=ready)
--   0x04 : GIE
--   0x08 : IER
--   0x0C : ISR
--   0x10 : rate_bytes[7:0]
--   0x18 : delimiter[7:0]
--   0x20 : output_len[15:0]
--   0x28 : input_len[15:0]     - Total input message length in bytes
--   0x30 : data_in_lo[31:0]    - Write: Input data (low 32 bits)
--   0x34 : data_in_hi[31:0]    - Write: Input data (high 32 bits), triggers absorption
--   0x38 : data_out_lo[31:0]   - Read: Output data (low 32 bits)
--   0x3C : data_out_hi[31:0]   - Read: Output data (high 32 bits), triggers next word
--   0x40 : status[7:0]         - bit 0=input_ready, bit 1=output_valid
-- ============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.keccak_pkg.all;

entity keccak_top_axilite is
    generic (
        C_S_AXI_ADDR_WIDTH : integer := 7;
        C_S_AXI_DATA_WIDTH : integer := 32
    );
    port (
        ap_clk   : in std_logic;
        ap_rst_n : in std_logic;
        
        -- AXI-Lite Interface (combined control + data)
        s_axi_AWVALID : in  std_logic;
        s_axi_AWREADY : out std_logic;
        s_axi_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_WVALID  : in  std_logic;
        s_axi_WREADY  : out std_logic;
        s_axi_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        s_axi_WSTRB   : in  std_logic_vector(C_S_AXI_DATA_WIDTH/8-1 downto 0);
        s_axi_ARVALID : in  std_logic;
        s_axi_ARREADY : out std_logic;
        s_axi_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_RVALID  : out std_logic;
        s_axi_RREADY  : in  std_logic;
        s_axi_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        s_axi_RRESP   : out std_logic_vector(1 downto 0);
        s_axi_BVALID  : out std_logic;
        s_axi_BREADY  : in  std_logic;
        s_axi_BRESP   : out std_logic_vector(1 downto 0);
        
        interrupt : out std_logic
    );
end entity keccak_top_axilite;

architecture rtl of keccak_top_axilite is

    component keccak_f1600 is
        generic (
            G_PIPELINE : boolean := true
        );
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            start     : in  std_logic;
            done      : out std_logic;
            state_in  : in  state_t;
            state_out : out state_t
        );
    end component;

    -- Apply XOR at a specific byte position within a lane
    function xor_byte_in_lane(lane : lane_t; byte_idx : natural; byte_val : std_logic_vector(7 downto 0)) return lane_t is
        variable result : lane_t;
        variable idx : natural;
    begin
        result := lane;
        idx := byte_idx mod 8;
        result(idx*8 + 7 downto idx*8) := lane(idx*8 + 7 downto idx*8) xor byte_val;
        return result;
    end function;

    -- Register addresses
    constant ADDR_AP_CTRL       : integer := 16#00#;
    constant ADDR_GIE           : integer := 16#04#;
    constant ADDR_IER           : integer := 16#08#;
    constant ADDR_ISR           : integer := 16#0C#;
    constant ADDR_RATE_BYTES    : integer := 16#10#;
    constant ADDR_DELIMITER     : integer := 16#18#;
    constant ADDR_OUTPUT_LEN    : integer := 16#20#;
    constant ADDR_INPUT_LEN     : integer := 16#28#;
    constant ADDR_DATA_IN_LO    : integer := 16#30#;
    constant ADDR_DATA_IN_HI    : integer := 16#34#;
    constant ADDR_DATA_OUT_LO   : integer := 16#38#;
    constant ADDR_DATA_OUT_HI   : integer := 16#3C#;
    constant ADDR_STATUS        : integer := 16#40#;

    signal rst : std_logic;
    
    -- AXI-Lite FSM
    type axi_state_t is (AXI_IDLE, AXI_WRITE, AXI_RESP, AXI_READ);
    signal axi_wstate : axi_state_t := AXI_IDLE;
    signal axi_rstate : axi_state_t := AXI_IDLE;
    signal waddr_reg  : unsigned(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal raddr_reg  : unsigned(C_S_AXI_ADDR_WIDTH-1 downto 0);
    
    -- Control registers
    signal reg_ap_start     : std_logic := '0';
    signal reg_auto_restart : std_logic := '0';
    signal reg_gie          : std_logic := '0';
    signal reg_ier          : std_logic_vector(1 downto 0) := "00";
    signal reg_isr          : std_logic_vector(1 downto 0) := "00";
    signal reg_rate_bytes   : std_logic_vector(7 downto 0) := (others => '0');
    signal reg_delimiter    : std_logic_vector(7 downto 0) := (others => '0');
    signal reg_output_len   : std_logic_vector(15 downto 0) := (others => '0');
    signal reg_input_len    : std_logic_vector(15 downto 0) := (others => '0');
    
    -- Data registers
    signal reg_data_in_lo   : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_data_in_hi   : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in_write    : std_logic := '0';  -- Pulse when data_in_hi written
    
    -- Status
    signal ap_done_i        : std_logic := '0';
    signal ap_idle_i        : std_logic := '1';
    signal ap_ready_i       : std_logic := '0';
    signal input_ready      : std_logic := '0';
    signal output_valid     : std_logic := '0';
    signal output_read      : std_logic := '0';  -- Pulse when data_out_hi read
    signal set_isr_done     : std_logic := '0';  -- Request to set ISR done bit
    
    -- Keccak state
    signal state            : state_t;
    
    -- Permutation control
    signal perm_start       : std_logic := '0';
    signal perm_done        : std_logic;
    signal perm_out         : state_t;
    
    -- Main FSM
    type main_fsm_t is (
        S_IDLE,
        S_WAIT_START_CLEAR,
        S_ABSORB_WAIT,
        S_ABSORB_PROCESS,
        S_ABSORB_PERM,
        S_PADDING,
        S_FINAL_PERM,
        S_SQUEEZE_OUTPUT,
        S_SQUEEZE_WAIT,
        S_SQUEEZE_PERM,
        S_DONE
    );
    signal fsm_state : main_fsm_t := S_IDLE;
    
    -- Absorb phase tracking
    signal rate_words_reg   : unsigned(4 downto 0);
    signal lane_idx         : unsigned(4 downto 0);
    signal offset_bytes     : unsigned(15 downto 0);
    signal input_remaining  : unsigned(15 downto 0);
    signal delimiter_reg    : std_logic_vector(7 downto 0);
    
    -- Squeeze phase tracking
    signal output_remaining : unsigned(15 downto 0);
    signal squeeze_idx      : unsigned(4 downto 0);
    signal output_data      : std_logic_vector(63 downto 0);

begin

    rst <= not ap_rst_n;
    interrupt <= reg_gie and (reg_isr(0) or reg_isr(1));
    
    -- =========================================================================
    -- Keccak F1600 Permutation
    -- =========================================================================
    perm_inst : keccak_f1600
        generic map (
            G_PIPELINE => true
        )
        port map (
            clk       => ap_clk,
            rst       => rst,
            start     => perm_start,
            done      => perm_done,
            state_in  => state,
            state_out => perm_out
        );
    
    -- =========================================================================
    -- AXI-Lite Write FSM
    -- =========================================================================
    s_axi_AWREADY <= '1' when axi_wstate = AXI_IDLE else '0';
    s_axi_WREADY  <= '1' when axi_wstate = AXI_WRITE else '0';
    s_axi_BVALID  <= '1' when axi_wstate = AXI_RESP else '0';
    s_axi_BRESP   <= "00";
    
    process(ap_clk)
    begin
        if rising_edge(ap_clk) then
            if rst = '1' then
                axi_wstate <= AXI_IDLE;
                waddr_reg <= (others => '0');
            else
                data_in_write <= '0';
                
                case axi_wstate is
                    when AXI_IDLE =>
                        if s_axi_AWVALID = '1' then
                            waddr_reg <= unsigned(s_axi_AWADDR);
                            axi_wstate <= AXI_WRITE;
                        end if;
                    
                    when AXI_WRITE =>
                        if s_axi_WVALID = '1' then
                            -- Handle register writes
                            case to_integer(waddr_reg) is
                                when ADDR_AP_CTRL =>
                                    if s_axi_WSTRB(0) = '1' then
                                        reg_ap_start <= s_axi_WDATA(0);
                                        reg_auto_restart <= s_axi_WDATA(7);
                                    end if;
                                when ADDR_GIE =>
                                    if s_axi_WSTRB(0) = '1' then
                                        reg_gie <= s_axi_WDATA(0);
                                    end if;
                                when ADDR_IER =>
                                    if s_axi_WSTRB(0) = '1' then
                                        reg_ier <= s_axi_WDATA(1 downto 0);
                                    end if;
                                when ADDR_ISR =>
                                    -- Toggle on write (handled below)
                                    null;
                                when ADDR_RATE_BYTES =>
                                    if s_axi_WSTRB(0) = '1' then
                                        reg_rate_bytes <= s_axi_WDATA(7 downto 0);
                                    end if;
                                when ADDR_DELIMITER =>
                                    if s_axi_WSTRB(0) = '1' then
                                        reg_delimiter <= s_axi_WDATA(7 downto 0);
                                    end if;
                                when ADDR_OUTPUT_LEN =>
                                    reg_output_len <= s_axi_WDATA(15 downto 0);
                                when ADDR_INPUT_LEN =>
                                    reg_input_len <= s_axi_WDATA(15 downto 0);
                                when ADDR_DATA_IN_LO =>
                                    reg_data_in_lo <= s_axi_WDATA;
                                when ADDR_DATA_IN_HI =>
                                    reg_data_in_hi <= s_axi_WDATA;
                                    data_in_write <= '1';  -- Trigger data absorption
                                when others =>
                                    null;
                            end case;
                            axi_wstate <= AXI_RESP;
                        end if;
                    
                    when AXI_RESP =>
                        if s_axi_BREADY = '1' then
                            axi_wstate <= AXI_IDLE;
                        end if;
                    
                    when others =>
                        axi_wstate <= AXI_IDLE;
                end case;
                
                -- Clear ap_start on handshake
                if ap_ready_i = '1' then
                    reg_ap_start <= reg_auto_restart;
                end if;
                
                -- ISR management (single driver)
                -- Toggle on write
                if axi_wstate = AXI_WRITE and s_axi_WVALID = '1' and 
                   to_integer(waddr_reg) = ADDR_ISR and s_axi_WSTRB(0) = '1' then
                    reg_isr <= reg_isr xor s_axi_WDATA(1 downto 0);
                -- Set done bit from FSM
                elsif set_isr_done = '1' then
                    reg_isr(0) <= '1';
                end if;
            end if;
        end if;
    end process;
    
    -- =========================================================================
    -- AXI-Lite Read FSM
    -- =========================================================================
    s_axi_ARREADY <= '1' when axi_rstate = AXI_IDLE else '0';
    s_axi_RVALID  <= '1' when axi_rstate = AXI_READ else '0';
    s_axi_RRESP   <= "00";
    
    process(ap_clk)
        variable rdata : std_logic_vector(31 downto 0);
    begin
        if rising_edge(ap_clk) then
            if rst = '1' then
                axi_rstate <= AXI_IDLE;
                raddr_reg <= (others => '0');
                s_axi_RDATA <= (others => '0');
            else
                output_read <= '0';
                
                case axi_rstate is
                    when AXI_IDLE =>
                        if s_axi_ARVALID = '1' then
                            raddr_reg <= unsigned(s_axi_ARADDR);
                            axi_rstate <= AXI_READ;
                            
                            -- Prepare read data
                            rdata := (others => '0');
                            case to_integer(unsigned(s_axi_ARADDR)) is
                                when ADDR_AP_CTRL =>
                                    rdata(0) := reg_ap_start;
                                    rdata(1) := ap_done_i;
                                    rdata(2) := ap_idle_i;
                                    rdata(3) := ap_ready_i;
                                    rdata(7) := reg_auto_restart;
                                when ADDR_GIE =>
                                    rdata(0) := reg_gie;
                                when ADDR_IER =>
                                    rdata(1 downto 0) := reg_ier;
                                when ADDR_ISR =>
                                    rdata(1 downto 0) := reg_isr;
                                when ADDR_RATE_BYTES =>
                                    rdata(7 downto 0) := reg_rate_bytes;
                                when ADDR_DELIMITER =>
                                    rdata(7 downto 0) := reg_delimiter;
                                when ADDR_OUTPUT_LEN =>
                                    rdata(15 downto 0) := reg_output_len;
                                when ADDR_INPUT_LEN =>
                                    rdata(15 downto 0) := reg_input_len;
                                when ADDR_DATA_OUT_LO =>
                                    rdata := output_data(31 downto 0);
                                when ADDR_DATA_OUT_HI =>
                                    rdata := output_data(63 downto 32);
                                    output_read <= '1';  -- Trigger next output word
                                when ADDR_STATUS =>
                                    rdata(0) := input_ready;
                                    rdata(1) := output_valid;
                                when others =>
                                    null;
                            end case;
                            s_axi_RDATA <= rdata;
                        end if;
                    
                    when AXI_READ =>
                        if s_axi_RREADY = '1' then
                            axi_rstate <= AXI_IDLE;
                        end if;
                    
                    when others =>
                        axi_rstate <= AXI_IDLE;
                end case;
            end if;
        end if;
    end process;
    
    -- =========================================================================
    -- Main Keccak FSM
    -- =========================================================================
    process(ap_clk)
        variable input_word     : std_logic_vector(63 downto 0);
        variable pad_word_idx   : integer range 0 to 24;
        variable pad_byte_idx   : integer range 0 to 7;
        variable last_word_idx  : integer range 0 to 24;
        variable temp_lane      : lane_t;
        variable temp_lane2     : lane_t;
    begin
        if rising_edge(ap_clk) then
            if rst = '1' then
                fsm_state <= S_IDLE;
                state <= (others => (others => '0'));
                lane_idx <= (others => '0');
                offset_bytes <= (others => '0');
                input_remaining <= (others => '0');
                output_remaining <= (others => '0');
                squeeze_idx <= (others => '0');
                perm_start <= '0';
                ap_done_i <= '0';
                ap_ready_i <= '0';
                ap_idle_i <= '1';
                input_ready <= '0';
                output_valid <= '0';
                rate_words_reg <= (others => '0');
                delimiter_reg <= (others => '0');
                output_data <= (others => '0');
                set_isr_done <= '0';
            else
                perm_start <= '0';
                ap_done_i <= '0';
                ap_ready_i <= '0';
                set_isr_done <= '0';  -- Clear pulse
                
                case fsm_state is
                    when S_IDLE =>
                        ap_idle_i <= '1';
                        input_ready <= '0';
                        output_valid <= '0';
                        
                        if reg_ap_start = '1' then
                            ap_idle_i <= '0';
                            state <= (others => (others => '0'));
                            lane_idx <= (others => '0');
                            offset_bytes <= (others => '0');
                            input_remaining <= unsigned(reg_input_len);
                            output_remaining <= unsigned(reg_output_len);
                            squeeze_idx <= (others => '0');
                            rate_words_reg <= unsigned(reg_rate_bytes(7 downto 3));
                            delimiter_reg <= reg_delimiter;
                            input_ready <= '1';
                            
                            -- Handle zero-length input immediately
                            if unsigned(reg_input_len) = 0 then
                                fsm_state <= S_PADDING;
                            else
                                fsm_state <= S_ABSORB_WAIT;
                            end if;
                        end if;
                    
                    -- Wait for software to write input data
                    when S_ABSORB_WAIT =>
                        ap_idle_i <= '0';
                        input_ready <= '1';
                        
                        if data_in_write = '1' then
                            input_ready <= '0';
                            fsm_state <= S_ABSORB_PROCESS;
                        end if;
                    
                    -- Process one 64-bit input word
                    when S_ABSORB_PROCESS =>
                        input_word := reg_data_in_hi & reg_data_in_lo;
                        
                        -- XOR input into state
                        state(to_integer(lane_idx)) <= 
                            state(to_integer(lane_idx)) xor input_word;
                        
                        lane_idx <= lane_idx + 1;
                        
                        -- Update byte tracking
                        if input_remaining >= 8 then
                            offset_bytes <= offset_bytes + 8;
                            input_remaining <= input_remaining - 8;
                        else
                            offset_bytes <= offset_bytes + input_remaining(2 downto 0);
                            input_remaining <= (others => '0');
                        end if;
                        
                        -- Check if we're done with input
                        if input_remaining <= 8 then
                            fsm_state <= S_PADDING;
                        -- Check if we filled a rate block
                        elsif lane_idx + 1 >= rate_words_reg then
                            perm_start <= '1';
                            fsm_state <= S_ABSORB_PERM;
                        else
                            input_ready <= '1';
                            fsm_state <= S_ABSORB_WAIT;
                        end if;
                    
                    -- Wait for permutation after filling rate block
                    when S_ABSORB_PERM =>
                        if perm_done = '1' then
                            state <= perm_out;
                            lane_idx <= (others => '0');
                            offset_bytes <= (others => '0');
                            input_ready <= '1';
                            fsm_state <= S_ABSORB_WAIT;
                        end if;
                    
                    -- Apply padding
                    when S_PADDING =>
                        input_ready <= '0';
                        
                        pad_word_idx := to_integer(offset_bytes(7 downto 3));
                        pad_byte_idx := to_integer(offset_bytes(2 downto 0));
                        last_word_idx := to_integer(rate_words_reg) - 1;
                        
                        -- XOR delimiter at padding position
                        temp_lane := state(pad_word_idx);
                        temp_lane := xor_byte_in_lane(temp_lane, pad_byte_idx, delimiter_reg);
                        state(pad_word_idx) <= temp_lane;
                        
                        -- XOR 0x80 at last byte of rate block
                        if pad_word_idx = last_word_idx then
                            temp_lane := xor_byte_in_lane(temp_lane, 7, x"80");
                            state(pad_word_idx) <= temp_lane;
                        else
                            temp_lane2 := state(last_word_idx);
                            temp_lane2 := xor_byte_in_lane(temp_lane2, 7, x"80");
                            state(last_word_idx) <= temp_lane2;
                        end if;
                        
                        perm_start <= '1';
                        fsm_state <= S_FINAL_PERM;
                    
                    -- Wait for final permutation
                    when S_FINAL_PERM =>
                        if perm_done = '1' then
                            state <= perm_out;
                            squeeze_idx <= (others => '0');
                            output_data <= perm_out(0);  -- First output word
                            output_valid <= '1';
                            fsm_state <= S_SQUEEZE_OUTPUT;
                        end if;
                    
                    -- Output available, wait for read
                    when S_SQUEEZE_OUTPUT =>
                        output_valid <= '1';
                        output_data <= state(to_integer(squeeze_idx));
                        
                        if output_read = '1' then
                            output_valid <= '0';
                            
                            -- Update remaining count
                            if output_remaining >= 8 then
                                output_remaining <= output_remaining - 8;
                            else
                                output_remaining <= (others => '0');
                            end if;
                            
                            squeeze_idx <= squeeze_idx + 1;
                            
                            -- Check if done
                            if output_remaining <= 8 then
                                fsm_state <= S_DONE;
                            -- Check if need another permutation
                            elsif squeeze_idx + 1 >= rate_words_reg then
                                perm_start <= '1';
                                fsm_state <= S_SQUEEZE_PERM;
                            else
                                fsm_state <= S_SQUEEZE_WAIT;
                            end if;
                        end if;
                    
                    -- Brief state to update output data
                    when S_SQUEEZE_WAIT =>
                        output_data <= state(to_integer(squeeze_idx));
                        output_valid <= '1';
                        fsm_state <= S_SQUEEZE_OUTPUT;
                    
                    -- Additional permutation for XOF
                    when S_SQUEEZE_PERM =>
                        if perm_done = '1' then
                            state <= perm_out;
                            squeeze_idx <= (others => '0');
                            output_data <= perm_out(0);
                            output_valid <= '1';
                            fsm_state <= S_SQUEEZE_OUTPUT;
                        end if;
                    
                    when S_DONE =>
                        ap_done_i <= '1';
                        ap_ready_i <= '1';
                        ap_idle_i <= '1';
                        output_valid <= '0';
                        -- Request ISR done bit to be set (handled in AXI write process)
                        if reg_ier(0) = '1' then
                            set_isr_done <= '1';
                        end if;
                        fsm_state <= S_WAIT_START_CLEAR;
                    
                    -- Wait for software to clear ap_start before accepting new start
                    when S_WAIT_START_CLEAR =>
                        ap_idle_i <= '1';
                        if reg_ap_start = '0' then
                            fsm_state <= S_IDLE;
                        end if;
                        
                end case;
            end if;
        end if;
    end process;

end architecture rtl;
