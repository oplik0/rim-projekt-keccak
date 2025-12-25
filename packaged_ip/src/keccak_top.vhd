-- ============================================================================
-- Keccak Top Module (Simplified)
-- 
-- Clean VHDL implementation with the same external interface as HLS-generated
-- code, but with readable, maintainable internal logic.
--
-- Interface:
--   - AXI4-Stream input (64-bit data + TLAST)
--   - AXI4-Stream output (64-bit data + TLAST)
--   - AXI-Lite control (rate_bytes, delimiter, output_len, ap_ctrl)
--
-- Operation:
--   1. IDLE: Wait for ap_start
--   2. ABSORB: Read input stream, XOR into state, permute when block full
--   3. PAD: Apply pad10*1 padding with delimiter
--   4. SQUEEZE: Output hash bytes, permute if more output needed
--   5. DONE: Signal completion
-- ============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.keccak_pkg.all;

entity keccak_top is
    generic (
        C_S_AXI_CONTROL_ADDR_WIDTH : integer := 6;
        C_S_AXI_CONTROL_DATA_WIDTH : integer := 32
    );
    port (
        ap_clk   : in std_logic;
        ap_rst_n : in std_logic;
        
        -- AXI4-Stream Input
        input_stream_TDATA  : in  std_logic_vector(63 downto 0);
        input_stream_TVALID : in  std_logic;
        input_stream_TREADY : out std_logic;
        input_stream_TKEEP  : in  std_logic_vector(7 downto 0);
        input_stream_TSTRB  : in  std_logic_vector(7 downto 0);
        input_stream_TLAST  : in  std_logic_vector(0 downto 0);
        
        -- AXI4-Stream Output
        output_stream_TDATA  : out std_logic_vector(63 downto 0);
        output_stream_TVALID : out std_logic;
        output_stream_TREADY : in  std_logic;
        output_stream_TKEEP  : out std_logic_vector(7 downto 0);
        output_stream_TSTRB  : out std_logic_vector(7 downto 0);
        output_stream_TLAST  : out std_logic_vector(0 downto 0);
        
        -- AXI-Lite Control
        s_axi_control_AWVALID : in  std_logic;
        s_axi_control_AWREADY : out std_logic;
        s_axi_control_AWADDR  : in  std_logic_vector(C_S_AXI_CONTROL_ADDR_WIDTH-1 downto 0);
        s_axi_control_WVALID  : in  std_logic;
        s_axi_control_WREADY  : out std_logic;
        s_axi_control_WDATA   : in  std_logic_vector(C_S_AXI_CONTROL_DATA_WIDTH-1 downto 0);
        s_axi_control_WSTRB   : in  std_logic_vector(C_S_AXI_CONTROL_DATA_WIDTH/8-1 downto 0);
        s_axi_control_ARVALID : in  std_logic;
        s_axi_control_ARREADY : out std_logic;
        s_axi_control_ARADDR  : in  std_logic_vector(C_S_AXI_CONTROL_ADDR_WIDTH-1 downto 0);
        s_axi_control_RVALID  : out std_logic;
        s_axi_control_RREADY  : in  std_logic;
        s_axi_control_RDATA   : out std_logic_vector(C_S_AXI_CONTROL_DATA_WIDTH-1 downto 0);
        s_axi_control_RRESP   : out std_logic_vector(1 downto 0);
        s_axi_control_BVALID  : out std_logic;
        s_axi_control_BREADY  : in  std_logic;
        s_axi_control_BRESP   : out std_logic_vector(1 downto 0);
        
        interrupt : out std_logic
    );
end entity keccak_top;

architecture rtl of keccak_top is

    -- ========================================================================
    -- Component Declarations
    -- ========================================================================
    
    component keccak_top_control_s_axi is
        generic (
            C_S_AXI_ADDR_WIDTH : integer := 6;
            C_S_AXI_DATA_WIDTH : integer := 32
        );
        port (
            ACLK       : in  std_logic;
            ARESET     : in  std_logic;
            ACLK_EN    : in  std_logic;
            AWADDR     : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            AWVALID    : in  std_logic;
            AWREADY    : out std_logic;
            WDATA      : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            WSTRB      : in  std_logic_vector(C_S_AXI_DATA_WIDTH/8-1 downto 0);
            WVALID     : in  std_logic;
            WREADY     : out std_logic;
            BRESP      : out std_logic_vector(1 downto 0);
            BVALID     : out std_logic;
            BREADY     : in  std_logic;
            ARADDR     : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            ARVALID    : in  std_logic;
            ARREADY    : out std_logic;
            RDATA      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            RRESP      : out std_logic_vector(1 downto 0);
            RVALID     : out std_logic;
            RREADY     : in  std_logic;
            interrupt  : out std_logic;
            rate_bytes : out std_logic_vector(7 downto 0);
            delimiter  : out std_logic_vector(7 downto 0);
            output_len : out std_logic_vector(15 downto 0);
            ap_start   : out std_logic;
            ap_done    : in  std_logic;
            ap_ready   : in  std_logic;
            ap_idle    : in  std_logic
        );
    end component;
    
    component keccak_f1600 is
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            start     : in  std_logic;
            done      : out std_logic;
            state_in  : in  state_t;
            state_out : out state_t
        );
    end component;

    -- ========================================================================
    -- Helper Functions
    -- ========================================================================
    
    -- Count ones in TKEEP to get valid byte count
    function count_keep(keep : std_logic_vector(7 downto 0)) return unsigned is
        variable cnt : unsigned(3 downto 0) := (others => '0');
    begin
        for i in 0 to 7 loop
            if keep(i) = '1' then
                cnt := cnt + 1;
            end if;
        end loop;
        return cnt;
    end function;
    
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

    -- ========================================================================
    -- Signals
    -- ========================================================================
    
    -- Reset
    signal rst : std_logic;
    
    -- Control signals from AXI-Lite
    signal ap_start    : std_logic;
    signal ap_done_i   : std_logic;
    signal ap_ready_i  : std_logic;
    signal ap_idle_i   : std_logic;
    signal rate_bytes  : std_logic_vector(7 downto 0);
    signal delimiter   : std_logic_vector(7 downto 0);
    signal output_len  : std_logic_vector(15 downto 0);
    
    -- Keccak state
    signal state       : state_t;
    
    -- Permutation control
    signal perm_start  : std_logic;
    signal perm_done   : std_logic;
    signal perm_out    : state_t;
    
    -- Main FSM
    type main_fsm_t is (
        S_IDLE,
        S_ABSORB_READ,
        S_ABSORB_WAIT_PERM,
        S_PADDING,
        S_FINAL_PERM,
        S_SQUEEZE_OUTPUT,
        S_SQUEEZE_PERM,
        S_DONE
    );
    signal fsm_state : main_fsm_t;
    
    -- Absorb phase tracking
    signal rate_words_reg : unsigned(4 downto 0);  -- rate_bytes / 8 (latched)
    signal lane_idx       : unsigned(4 downto 0);  -- current lane index
    signal offset_bytes   : unsigned(7 downto 0);  -- byte offset within current block
    signal input_done     : std_logic;             -- TLAST seen
    
    -- Squeeze phase tracking
    signal output_remaining : unsigned(15 downto 0);
    signal squeeze_idx      : unsigned(4 downto 0);
    
    -- Stream handshake
    signal input_ready_i  : std_logic;
    signal output_valid_i : std_logic;
    
    -- Latched configuration
    signal delimiter_reg  : std_logic_vector(7 downto 0);

begin

    rst <= not ap_rst_n;
    
    -- Output signal connections
    input_stream_TREADY <= input_ready_i;
    output_stream_TVALID <= output_valid_i;
    
    -- ========================================================================
    -- AXI-Lite Control Interface
    -- ========================================================================
    control_inst : keccak_top_control_s_axi
        generic map (
            C_S_AXI_ADDR_WIDTH => C_S_AXI_CONTROL_ADDR_WIDTH,
            C_S_AXI_DATA_WIDTH => C_S_AXI_CONTROL_DATA_WIDTH
        )
        port map (
            ACLK       => ap_clk,
            ARESET     => rst,
            ACLK_EN    => '1',
            AWADDR     => s_axi_control_AWADDR,
            AWVALID    => s_axi_control_AWVALID,
            AWREADY    => s_axi_control_AWREADY,
            WDATA      => s_axi_control_WDATA,
            WSTRB      => s_axi_control_WSTRB,
            WVALID     => s_axi_control_WVALID,
            WREADY     => s_axi_control_WREADY,
            BRESP      => s_axi_control_BRESP,
            BVALID     => s_axi_control_BVALID,
            BREADY     => s_axi_control_BREADY,
            ARADDR     => s_axi_control_ARADDR,
            ARVALID    => s_axi_control_ARVALID,
            ARREADY    => s_axi_control_ARREADY,
            RDATA      => s_axi_control_RDATA,
            RRESP      => s_axi_control_RRESP,
            RVALID     => s_axi_control_RVALID,
            RREADY     => s_axi_control_RREADY,
            interrupt  => interrupt,
            rate_bytes => rate_bytes,
            delimiter  => delimiter,
            output_len => output_len,
            ap_start   => ap_start,
            ap_done    => ap_done_i,
            ap_ready   => ap_ready_i,
            ap_idle    => ap_idle_i
        );
    
    -- ========================================================================
    -- Keccak-f[1600] Permutation
    -- ========================================================================
    perm_inst : keccak_f1600
        port map (
            clk       => ap_clk,
            rst       => rst,
            start     => perm_start,
            done      => perm_done,
            state_in  => state,
            state_out => perm_out
        );
    
    -- ========================================================================
    -- Main FSM
    -- ========================================================================
    process(ap_clk)
        variable valid_bytes   : unsigned(3 downto 0);
        variable pad_word_idx  : integer range 0 to 24;
        variable pad_byte_idx  : integer range 0 to 7;
        variable last_word_idx : integer range 0 to 24;
        variable temp_lane     : lane_t;
        variable temp_lane2    : lane_t;
    begin
        if rising_edge(ap_clk) then
            if rst = '1' then
                fsm_state <= S_IDLE;
                state <= (others => (others => '0'));
                lane_idx <= (others => '0');
                offset_bytes <= (others => '0');
                input_done <= '0';
                output_remaining <= (others => '0');
                squeeze_idx <= (others => '0');
                perm_start <= '0';
                input_ready_i <= '0';
                output_valid_i <= '0';
                ap_done_i <= '0';
                ap_ready_i <= '0';
                ap_idle_i <= '1';
                rate_words_reg <= (others => '0');
                delimiter_reg <= (others => '0');
            else
                -- Default values
                perm_start <= '0';
                ap_done_i <= '0';
                ap_ready_i <= '0';
                
                case fsm_state is
                    -- ========================================================
                    -- IDLE: Wait for ap_start
                    -- ========================================================
                    when S_IDLE =>
                        ap_idle_i <= '1';
                        if ap_start = '1' then
                            ap_idle_i <= '0';
                            -- Initialize state and latch configuration
                            state <= (others => (others => '0'));
                            lane_idx <= (others => '0');
                            offset_bytes <= (others => '0');
                            input_done <= '0';
                            output_remaining <= unsigned(output_len);
                            squeeze_idx <= (others => '0');
                            rate_words_reg <= unsigned(rate_bytes(7 downto 3));
                            delimiter_reg <= delimiter;
                            input_ready_i <= '1';
                            fsm_state <= S_ABSORB_READ;
                        end if;
                    
                    -- ========================================================
                    -- ABSORB_READ: Read input words, XOR into state
                    -- ========================================================
                    when S_ABSORB_READ =>
                        ap_idle_i <= '0';
                        
                        if input_stream_TVALID = '1' and input_ready_i = '1' then
                            -- Count valid bytes
                            valid_bytes := count_keep(input_stream_TKEEP);
                            
                            -- XOR input data into current lane (only if there are valid bytes)
                            if valid_bytes > 0 then
                                state(to_integer(lane_idx)) <= 
                                    state(to_integer(lane_idx)) xor input_stream_TDATA;
                                offset_bytes <= offset_bytes + resize(valid_bytes, 8);
                                lane_idx <= lane_idx + 1;
                            end if;
                            
                            -- Check if this was the last transfer
                            if input_stream_TLAST(0) = '1' then
                                input_done <= '1';
                                input_ready_i <= '0';
                                fsm_state <= S_PADDING;
                            -- Check if we filled a rate block
                            elsif lane_idx + 1 >= rate_words_reg then
                                input_ready_i <= '0';
                                perm_start <= '1';
                                fsm_state <= S_ABSORB_WAIT_PERM;
                            end if;
                        end if;
                    
                    -- ========================================================
                    -- ABSORB_WAIT_PERM: Wait for permutation to complete
                    -- ========================================================
                    when S_ABSORB_WAIT_PERM =>
                        if perm_done = '1' then
                            state <= perm_out;
                            lane_idx <= (others => '0');
                            offset_bytes <= (others => '0');
                            
                            if input_done = '1' then
                                fsm_state <= S_PADDING;
                            else
                                input_ready_i <= '1';
                                fsm_state <= S_ABSORB_READ;
                            end if;
                        end if;
                    
                    -- ========================================================
                    -- PADDING: Apply pad10*1 with domain separator
                    -- Format: delimiter at offset_bytes, 0x80 at last byte of rate
                    -- ========================================================
                    when S_PADDING =>
                        -- Calculate padding positions
                        pad_word_idx := to_integer(offset_bytes(7 downto 3));  -- offset / 8
                        pad_byte_idx := to_integer(offset_bytes(2 downto 0));  -- offset mod 8
                        last_word_idx := to_integer(rate_words_reg) - 1;
                        
                        -- XOR delimiter at padding start position
                        temp_lane := state(pad_word_idx);
                        temp_lane := xor_byte_in_lane(temp_lane, pad_byte_idx, delimiter_reg);
                        state(pad_word_idx) <= temp_lane;
                        
                        -- XOR 0x80 at last byte of rate block (byte 7 of last word)
                        -- Note: If pad_word_idx == last_word_idx, we need to apply both
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
                    
                    -- ========================================================
                    -- FINAL_PERM: Wait for post-padding permutation
                    -- ========================================================
                    when S_FINAL_PERM =>
                        if perm_done = '1' then
                            state <= perm_out;
                            squeeze_idx <= (others => '0');
                            output_valid_i <= '1';
                            fsm_state <= S_SQUEEZE_OUTPUT;
                        end if;
                    
                    -- ========================================================
                    -- SQUEEZE_OUTPUT: Output hash bytes
                    -- ========================================================
                    when S_SQUEEZE_OUTPUT =>
                        if output_valid_i = '1' and output_stream_TREADY = '1' then
                            -- Calculate bytes in this word
                            if output_remaining >= 8 then
                                output_remaining <= output_remaining - 8;
                            else
                                output_remaining <= (others => '0');
                            end if;
                            
                            squeeze_idx <= squeeze_idx + 1;
                            
                            -- Check if done
                            if output_remaining <= 8 then
                                output_valid_i <= '0';
                                fsm_state <= S_DONE;
                            -- Check if we need another permutation (for XOF)
                            elsif squeeze_idx + 1 >= rate_words_reg then
                                output_valid_i <= '0';
                                perm_start <= '1';
                                fsm_state <= S_SQUEEZE_PERM;
                            end if;
                        end if;
                    
                    -- ========================================================
                    -- SQUEEZE_PERM: Additional permutation for XOF
                    -- ========================================================
                    when S_SQUEEZE_PERM =>
                        if perm_done = '1' then
                            state <= perm_out;
                            squeeze_idx <= (others => '0');
                            output_valid_i <= '1';
                            fsm_state <= S_SQUEEZE_OUTPUT;
                        end if;
                    
                    -- ========================================================
                    -- DONE: Signal completion
                    -- ========================================================
                    when S_DONE =>
                        ap_done_i <= '1';
                        ap_ready_i <= '1';
                        fsm_state <= S_IDLE;
                        
                end case;
            end if;
        end if;
    end process;
    
    -- ========================================================================
    -- Output stream data generation (combinational)
    -- ========================================================================
    process(squeeze_idx, state, output_remaining, fsm_state)
        variable bytes_out : unsigned(3 downto 0);
    begin
        -- Default
        output_stream_TDATA <= state(to_integer(squeeze_idx));
        output_stream_TSTRB <= (others => '1');
        output_stream_TLAST <= "0";
        
        -- Calculate bytes remaining for TKEEP
        if output_remaining >= 8 then
            bytes_out := to_unsigned(8, 4);
        else
            bytes_out := output_remaining(3 downto 0);
        end if;
        
        -- Generate TKEEP
        case to_integer(bytes_out) is
            when 0 => output_stream_TKEEP <= "00000000";
            when 1 => output_stream_TKEEP <= "00000001";
            when 2 => output_stream_TKEEP <= "00000011";
            when 3 => output_stream_TKEEP <= "00000111";
            when 4 => output_stream_TKEEP <= "00001111";
            when 5 => output_stream_TKEEP <= "00011111";
            when 6 => output_stream_TKEEP <= "00111111";
            when 7 => output_stream_TKEEP <= "01111111";
            when others => output_stream_TKEEP <= "11111111";
        end case;
        
        -- Set TLAST on final word
        if output_remaining <= 8 and fsm_state = S_SQUEEZE_OUTPUT then
            output_stream_TLAST <= "1";
        end if;
    end process;

end architecture rtl;
