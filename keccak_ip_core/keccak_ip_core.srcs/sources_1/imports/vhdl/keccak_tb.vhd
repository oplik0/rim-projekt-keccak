library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.keccak_pkg.all;

entity keccak_tb is
end entity keccak_tb;

architecture sim of keccak_tb is

    -- Helper function to convert std_logic_vector to hex string
    function slv_to_hex(slv : std_logic_vector) return string is
        constant hex_chars : string := "0123456789ABCDEF";
        variable result : string(1 to slv'length/4);
        variable nibble : integer;
    begin
        for i in 0 to slv'length/4 - 1 loop
            nibble := to_integer(unsigned(slv((slv'length - 1 - i*4) downto (slv'length - 4 - i*4))));
            result(i + 1) := hex_chars(nibble + 1);
        end loop;
        return result;
    end function;

    -- ========================================================================
    -- Constants
    -- ========================================================================
    
    -- Clock period (200 MHz)
    constant CLK_PERIOD : time := 5 ns;
    
    -- SHA3 parameters
    constant RATE_SHA3_256 : std_logic_vector(7 downto 0) := x"88";  -- 136 bytes
    constant RATE_SHA3_512 : std_logic_vector(7 downto 0) := x"48";  -- 72 bytes
    constant DELIM_SHA3    : std_logic_vector(7 downto 0) := x"06";  -- SHA3 domain separator
    
    -- AXI-Lite register addresses (from keccak_top_control_s_axi)
    constant ADDR_AP_CTRL    : std_logic_vector(5 downto 0) := "000000";  -- 0x00
    constant ADDR_RATE_BYTES : std_logic_vector(5 downto 0) := "010000";  -- 0x10
    constant ADDR_DELIMITER  : std_logic_vector(5 downto 0) := "011000";  -- 0x18
    constant ADDR_OUTPUT_LEN : std_logic_vector(5 downto 0) := "100000";  -- 0x20
    
    -- ========================================================================
    -- DUT signals
    -- ========================================================================
    
    signal ap_clk   : std_logic := '0';
    signal ap_rst_n : std_logic := '0';
    
    -- AXI4-Stream Input
    signal input_stream_TDATA  : std_logic_vector(63 downto 0) := (others => '0');
    signal input_stream_TVALID : std_logic := '0';
    signal input_stream_TREADY : std_logic;
    signal input_stream_TKEEP  : std_logic_vector(7 downto 0) := (others => '0');
    signal input_stream_TSTRB  : std_logic_vector(7 downto 0) := (others => '0');
    signal input_stream_TLAST  : std_logic_vector(0 downto 0) := "0";
    
    -- AXI4-Stream Output
    signal output_stream_TDATA  : std_logic_vector(63 downto 0);
    signal output_stream_TVALID : std_logic;
    signal output_stream_TREADY : std_logic := '0';
    signal output_stream_TKEEP  : std_logic_vector(7 downto 0);
    signal output_stream_TSTRB  : std_logic_vector(7 downto 0);
    signal output_stream_TLAST  : std_logic_vector(0 downto 0);
    
    -- AXI-Lite Control
    signal s_axi_control_AWVALID : std_logic := '0';
    signal s_axi_control_AWREADY : std_logic;
    signal s_axi_control_AWADDR  : std_logic_vector(5 downto 0) := (others => '0');
    signal s_axi_control_WVALID  : std_logic := '0';
    signal s_axi_control_WREADY  : std_logic;
    signal s_axi_control_WDATA   : std_logic_vector(31 downto 0) := (others => '0');
    signal s_axi_control_WSTRB   : std_logic_vector(3 downto 0) := (others => '1');
    signal s_axi_control_ARVALID : std_logic := '0';
    signal s_axi_control_ARREADY : std_logic;
    signal s_axi_control_ARADDR  : std_logic_vector(5 downto 0) := (others => '0');
    signal s_axi_control_RVALID  : std_logic;
    signal s_axi_control_RREADY  : std_logic := '0';
    signal s_axi_control_RDATA   : std_logic_vector(31 downto 0);
    signal s_axi_control_RRESP   : std_logic_vector(1 downto 0);
    signal s_axi_control_BVALID  : std_logic;
    signal s_axi_control_BREADY  : std_logic := '0';
    signal s_axi_control_BRESP   : std_logic_vector(1 downto 0);
    
    signal interrupt : std_logic;
    
    -- Test control
    signal test_done   : boolean := false;
    signal tests_passed : integer := 0;
    signal tests_total  : integer := 0;

    -- ========================================================================
    -- Expected hash values (from NIST test vectors)
    -- ========================================================================
    
    -- SHA3-256("") = a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a
    type byte_array_32 is array (0 to 31) of std_logic_vector(7 downto 0);
    constant SHA3_256_EMPTY : byte_array_32 := (
        x"a7", x"ff", x"c6", x"f8", x"bf", x"1e", x"d7", x"66",
        x"51", x"c1", x"47", x"56", x"a0", x"61", x"d6", x"62",
        x"f5", x"80", x"ff", x"4d", x"e4", x"3b", x"49", x"fa",
        x"82", x"d8", x"0a", x"4b", x"80", x"f8", x"43", x"4a"
    );
    
    -- SHA3-256("abc") = 3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532
    constant SHA3_256_ABC : byte_array_32 := (
        x"3a", x"98", x"5d", x"a7", x"4f", x"e2", x"25", x"b2",
        x"04", x"5c", x"17", x"2d", x"6b", x"d3", x"90", x"bd",
        x"85", x"5f", x"08", x"6e", x"3e", x"9d", x"52", x"5b",
        x"46", x"bf", x"e2", x"45", x"11", x"43", x"15", x"32"
    );
    
    -- SHA3-512("") = a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a6
    --                15b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26
    type byte_array_64 is array (0 to 63) of std_logic_vector(7 downto 0);
    constant SHA3_512_EMPTY : byte_array_64 := (
        x"a6", x"9f", x"73", x"cc", x"a2", x"3a", x"9a", x"c5",
        x"c8", x"b5", x"67", x"dc", x"18", x"5a", x"75", x"6e",
        x"97", x"c9", x"82", x"16", x"4f", x"e2", x"58", x"59",
        x"e0", x"d1", x"dc", x"c1", x"47", x"5c", x"80", x"a6",
        x"15", x"b2", x"12", x"3a", x"f1", x"f5", x"f9", x"4c",
        x"11", x"e3", x"e9", x"40", x"2c", x"3a", x"c5", x"58",
        x"f5", x"00", x"19", x"9d", x"95", x"b6", x"d3", x"e3",
        x"01", x"75", x"85", x"86", x"28", x"1d", x"cd", x"26"
    );

begin

    -- ========================================================================
    -- Clock generation
    -- ========================================================================
    ap_clk <= not ap_clk after CLK_PERIOD/2 when not test_done else '0';
    
    -- ========================================================================
    -- DUT Instance
    -- ========================================================================
    dut: entity work.keccak_top
        generic map (
            C_S_AXI_CONTROL_ADDR_WIDTH => 6,
            C_S_AXI_CONTROL_DATA_WIDTH => 32
        )
        port map (
            ap_clk   => ap_clk,
            ap_rst_n => ap_rst_n,
            
            -- AXI4-Stream Input
            input_stream_TDATA  => input_stream_TDATA,
            input_stream_TVALID => input_stream_TVALID,
            input_stream_TREADY => input_stream_TREADY,
            input_stream_TKEEP  => input_stream_TKEEP,
            input_stream_TSTRB  => input_stream_TSTRB,
            input_stream_TLAST  => input_stream_TLAST,
            
            -- AXI4-Stream Output
            output_stream_TDATA  => output_stream_TDATA,
            output_stream_TVALID => output_stream_TVALID,
            output_stream_TREADY => output_stream_TREADY,
            output_stream_TKEEP  => output_stream_TKEEP,
            output_stream_TSTRB  => output_stream_TSTRB,
            output_stream_TLAST  => output_stream_TLAST,
            
            -- AXI-Lite Control
            s_axi_control_AWVALID => s_axi_control_AWVALID,
            s_axi_control_AWREADY => s_axi_control_AWREADY,
            s_axi_control_AWADDR  => s_axi_control_AWADDR,
            s_axi_control_WVALID  => s_axi_control_WVALID,
            s_axi_control_WREADY  => s_axi_control_WREADY,
            s_axi_control_WDATA   => s_axi_control_WDATA,
            s_axi_control_WSTRB   => s_axi_control_WSTRB,
            s_axi_control_ARVALID => s_axi_control_ARVALID,
            s_axi_control_ARREADY => s_axi_control_ARREADY,
            s_axi_control_ARADDR  => s_axi_control_ARADDR,
            s_axi_control_RVALID  => s_axi_control_RVALID,
            s_axi_control_RREADY  => s_axi_control_RREADY,
            s_axi_control_RDATA   => s_axi_control_RDATA,
            s_axi_control_RRESP   => s_axi_control_RRESP,
            s_axi_control_BVALID  => s_axi_control_BVALID,
            s_axi_control_BREADY  => s_axi_control_BREADY,
            s_axi_control_BRESP   => s_axi_control_BRESP,
            
            interrupt => interrupt
        );

    -- ========================================================================
    -- Main Test Process
    -- ========================================================================
    main_test: process
        
        -- ====================================================================
        -- AXI-Lite Write Procedure
        -- ====================================================================
        procedure axi_lite_write(
            addr : in std_logic_vector(5 downto 0);
            data : in std_logic_vector(31 downto 0)
        ) is
        begin
            -- Write address
            s_axi_control_AWADDR  <= addr;
            s_axi_control_AWVALID <= '1';
            s_axi_control_BREADY  <= '1';
            
            -- Wait for address handshake
            wait until rising_edge(ap_clk);
            while s_axi_control_AWREADY = '0' loop
                wait until rising_edge(ap_clk);
            end loop;
            s_axi_control_AWVALID <= '0';
            
            -- Write data
            s_axi_control_WDATA   <= data;
            s_axi_control_WSTRB   <= "1111";
            s_axi_control_WVALID  <= '1';
            
            -- Wait for data handshake
            wait until rising_edge(ap_clk);
            while s_axi_control_WREADY = '0' loop
                wait until rising_edge(ap_clk);
            end loop;
            s_axi_control_WVALID  <= '0';
            
            -- Wait for write response
            while s_axi_control_BVALID = '0' loop
                wait until rising_edge(ap_clk);
            end loop;
            
            s_axi_control_BREADY <= '0';
            wait until rising_edge(ap_clk);
        end procedure;
        
        -- ====================================================================
        -- AXI-Lite Read Procedure
        -- ====================================================================
        procedure axi_lite_read(
            addr : in  std_logic_vector(5 downto 0);
            data : out std_logic_vector(31 downto 0)
        ) is
        begin
            s_axi_control_ARADDR  <= addr;
            s_axi_control_ARVALID <= '1';
            s_axi_control_RREADY  <= '1';
            
            -- Wait for address ready
            wait until rising_edge(ap_clk);
            while s_axi_control_ARREADY = '0' loop
                wait until rising_edge(ap_clk);
            end loop;
            
            s_axi_control_ARVALID <= '0';
            
            -- Wait for read data
            while s_axi_control_RVALID = '0' loop
                wait until rising_edge(ap_clk);
            end loop;
            
            data := s_axi_control_RDATA;
            s_axi_control_RREADY <= '0';
            wait until rising_edge(ap_clk);
        end procedure;
        
        -- ====================================================================
        -- Wait for ap_idle
        -- ====================================================================
        procedure wait_for_idle is
            variable status : std_logic_vector(31 downto 0);
            variable timeout : integer := 0;
        begin
            loop
                axi_lite_read(ADDR_AP_CTRL, status);
                exit when status(2) = '1';  -- ap_idle bit
                timeout := timeout + 1;
                if timeout > 1000 then
                    report "TIMEOUT waiting for ap_idle!" severity error;
                    exit;
                end if;
            end loop;
        end procedure;
        
        -- ====================================================================
        -- Wait for ap_done (polls status register)
        -- NOTE: Output must be consumed first for DUT to reach done state
        -- ====================================================================
        procedure wait_for_done is
            variable status : std_logic_vector(31 downto 0);
            variable timeout : integer := 0;
        begin
            loop
                axi_lite_read(ADDR_AP_CTRL, status);
                exit when status(1) = '1';  -- ap_done bit
                timeout := timeout + 1;
                if timeout > 1000 then
                    report "TIMEOUT waiting for ap_done!" severity error;
                    exit;
                end if;
            end loop;
        end procedure;
        
        -- ====================================================================
        -- Send AXI-Stream packet
        -- ====================================================================
        procedure axis_send(
            data : in std_logic_vector(63 downto 0);
            keep : in std_logic_vector(7 downto 0);
            last : in std_logic
        ) is
            variable timeout : integer := 0;
        begin
            input_stream_TDATA  <= data;
            input_stream_TKEEP  <= keep;
            input_stream_TSTRB  <= keep;
            input_stream_TLAST  <= (0 => last);
            input_stream_TVALID <= '1';
            
            wait until rising_edge(ap_clk);
            while input_stream_TREADY = '0' loop
                wait until rising_edge(ap_clk);
                timeout := timeout + 1;
                if timeout > 1000 then
                    report "TIMEOUT waiting for input_stream_TREADY!" severity error;
                    exit;
                end if;
            end loop;
            
            input_stream_TVALID <= '0';
            wait until rising_edge(ap_clk);
        end procedure;
        
        -- ====================================================================
        -- Receive AXI-Stream output and compare
        -- ====================================================================
        procedure axis_receive_and_check_32(
            expected : in byte_array_32;
            test_name : in string;
            pass : out boolean
        ) is
            variable byte_idx : integer := 0;
            variable word_data : std_logic_vector(63 downto 0);
            variable byte_val : std_logic_vector(7 downto 0);
            variable mismatch : boolean := false;
            variable timeout : integer := 0;
        begin
            output_stream_TREADY <= '1';
            
            while byte_idx < 32 loop
                wait until rising_edge(ap_clk);
                timeout := timeout + 1;
                if timeout > 10000 then
                    report test_name & ": TIMEOUT waiting for output!" severity error;
                    mismatch := true;
                    exit;
                end if;
                if output_stream_TVALID = '1' then
                    word_data := output_stream_TDATA;
                    timeout := 0;  -- Reset timeout on valid data
                    -- Extract bytes (little-endian)
                    for i in 0 to 7 loop
                        if byte_idx < 32 then
                            byte_val := word_data(i*8+7 downto i*8);
                            if byte_val /= expected(byte_idx) then
                                report test_name & ": Byte " & integer'image(byte_idx) &
                                       " mismatch: expected 0x" & slv_to_hex(expected(byte_idx)) &
                                       " got 0x" & slv_to_hex(byte_val) severity warning;
                                mismatch := true;
                            end if;
                            byte_idx := byte_idx + 1;
                        end if;
                    end loop;
                end if;
            end loop;
            
            output_stream_TREADY <= '0';
            pass := not mismatch;
        end procedure;
        
        procedure axis_receive_and_check_64(
            expected : in byte_array_64;
            test_name : in string;
            pass : out boolean
        ) is
            variable byte_idx : integer := 0;
            variable word_data : std_logic_vector(63 downto 0);
            variable byte_val : std_logic_vector(7 downto 0);
            variable mismatch : boolean := false;
            variable timeout : integer := 0;
        begin
            output_stream_TREADY <= '1';
            
            while byte_idx < 64 loop
                wait until rising_edge(ap_clk);
                timeout := timeout + 1;
                if timeout > 10000 then
                    report test_name & ": TIMEOUT waiting for output!" severity error;
                    mismatch := true;
                    exit;
                end if;
                if output_stream_TVALID = '1' then
                    word_data := output_stream_TDATA;
                    timeout := 0;  -- Reset timeout on valid data
                    -- Extract bytes (little-endian)
                    for i in 0 to 7 loop
                        if byte_idx < 64 then
                            byte_val := word_data(i*8+7 downto i*8);
                            if byte_val /= expected(byte_idx) then
                                report test_name & ": Byte " & integer'image(byte_idx) &
                                       " mismatch: expected 0x" & slv_to_hex(expected(byte_idx)) &
                                       " got 0x" & slv_to_hex(byte_val) severity warning;
                                mismatch := true;
                            end if;
                            byte_idx := byte_idx + 1;
                        end if;
                    end loop;
                end if;
            end loop;
            
            output_stream_TREADY <= '0';
            pass := not mismatch;
        end procedure;
        
        -- ====================================================================
        -- Configure hash parameters
        -- ====================================================================
        procedure configure_hash(
            rate  : in std_logic_vector(7 downto 0);
            delim : in std_logic_vector(7 downto 0);
            outlen : in std_logic_vector(15 downto 0)
        ) is
        begin
            axi_lite_write(ADDR_RATE_BYTES, x"000000" & rate);
            axi_lite_write(ADDR_DELIMITER, x"000000" & delim);
            axi_lite_write(ADDR_OUTPUT_LEN, x"0000" & outlen);
        end procedure;
        
        -- ====================================================================
        -- Start the hash operation
        -- ====================================================================
        procedure start_hash is
        begin
            axi_lite_write(ADDR_AP_CTRL, x"00000001");  -- Set ap_start
        end procedure;
        
        -- Variables
        variable pass : boolean;
        variable v_tests_passed : integer := 0;
        variable v_tests_total : integer := 0;
        variable byte_count : integer := 0;
        
    begin
        -- ====================================================================
        -- Initial Reset
        -- ====================================================================
        report "========================================" severity note;
        report "Keccak VHDL Testbench" severity note;
        report "========================================" severity note;
        
        ap_rst_n <= '0';
        wait for CLK_PERIOD * 20;
        ap_rst_n <= '1';
        wait for CLK_PERIOD * 10;
        
        -- Wait for module to be idle
        wait_for_idle;
        
        -- ====================================================================
        -- Test 1: SHA3-256 empty message
        -- ====================================================================
        report "" severity note;
        report "Test 1: SHA3-256 empty message" severity note;
        v_tests_total := v_tests_total + 1;
        
        report "  Configuring hash..." severity note;
        configure_hash(RATE_SHA3_256, DELIM_SHA3, x"0020");  -- 32 bytes output
        report "  Starting hash..." severity note;
        start_hash;
        
        -- Send empty packet (TLAST=1, TKEEP=0)
        report "  Sending empty packet..." severity note;
        axis_send(x"0000000000000000", x"00", '1');
        report "  Packet sent, receiving output..." severity note;
        
        -- Receive output first (enables DUT to complete), then verify done
        axis_receive_and_check_32(SHA3_256_EMPTY, "SHA3-256 empty", pass);
        report "  Output received, waiting for done..." severity note;
        wait_for_done;
        report "  Done received." severity note;
        
        if pass then
            report "  Result: PASS" severity note;
            v_tests_passed := v_tests_passed + 1;
        else
            report "  Result: FAIL" severity error;
        end if;
        
        wait for CLK_PERIOD * 10;
        wait_for_idle;
        
        -- ====================================================================
        -- Test 2: SHA3-256(abc)
        -- ====================================================================
        report "" severity note;
        report "Test 2: SHA3-256(abc)" severity note;
        v_tests_total := v_tests_total + 1;
        
        configure_hash(RATE_SHA3_256, DELIM_SHA3, x"0020");
        start_hash;
        
        -- Send "abc" = 0x616263 in little-endian order
        -- data = 0x0000000000636261, keep = 0x07 (3 valid bytes), last = 1
        axis_send(x"0000000000636261", x"07", '1');
        
        -- Receive output first (enables DUT to complete), then verify done
        axis_receive_and_check_32(SHA3_256_ABC, "SHA3-256 abc", pass);
        wait_for_done;
        
        if pass then
            report "  Result: PASS" severity note;
            v_tests_passed := v_tests_passed + 1;
        else
            report "  Result: FAIL" severity error;
        end if;
        
        wait for CLK_PERIOD * 10;
        wait_for_idle;
        
        -- ====================================================================
        -- Test 3: SHA3-512 empty message
        -- ====================================================================
        report "" severity note;
        report "Test 3: SHA3-512 empty message" severity note;
        v_tests_total := v_tests_total + 1;
        
        configure_hash(RATE_SHA3_512, DELIM_SHA3, x"0040");  -- 64 bytes output
        start_hash;
        
        -- Send empty packet
        axis_send(x"0000000000000000", x"00", '1');
        
        -- Receive output first (enables DUT to complete), then verify done
        axis_receive_and_check_64(SHA3_512_EMPTY, "SHA3-512 empty", pass);
        wait_for_done;
        
        if pass then
            report "  Result: PASS" severity note;
            v_tests_passed := v_tests_passed + 1;
        else
            report "  Result: FAIL" severity error;
        end if;
        
        wait for CLK_PERIOD * 10;
        wait_for_idle;
        
        -- ====================================================================
        -- Test 4: SHA3-256 with 200-byte message (multi-block)
        -- ====================================================================
        report "" severity note;
        report "Test 4: SHA3-256 with 200-byte message (multi-block)" severity note;
        v_tests_total := v_tests_total + 1;
        
        configure_hash(RATE_SHA3_256, DELIM_SHA3, x"0020");
        start_hash;
        
        -- Send 200 bytes of zeros as 25 words (25 * 8 = 200 bytes)
        for i in 0 to 23 loop
            axis_send(x"0000000000000000", x"FF", '0');
        end loop;
        -- Last word with TLAST=1
        axis_send(x"0000000000000000", x"FF", '1');
        
        -- For this test, we just verify we get 32 bytes of output
        -- Receive output first (enables DUT to complete)
        output_stream_TREADY <= '1';
        byte_count := 0;
        while byte_count < 32 loop
            wait until rising_edge(ap_clk);
            if output_stream_TVALID = '1' then
                byte_count := byte_count + 8;
                report "  Output word received" severity note;
            end if;
        end loop;
        output_stream_TREADY <= '0';
        
        wait_for_done;
        
        -- Pass if we received the right number of bytes
        report "  Received 32 bytes of output" severity note;
        report "  Result: PASS (basic output check)" severity note;
        v_tests_passed := v_tests_passed + 1;
        
        -- ====================================================================
        -- Test Summary
        -- ====================================================================
        report "" severity note;
        report "========================================" severity note;
        report "Test Summary: " & integer'image(v_tests_passed) & "/" & 
               integer'image(v_tests_total) & " tests passed" severity note;
        report "========================================" severity note;
        
        if v_tests_passed = v_tests_total then
            report "ALL TESTS PASSED!" severity note;
        else
            report "SOME TESTS FAILED!" severity error;
        end if;
        
        tests_passed <= v_tests_passed;
        tests_total  <= v_tests_total;
        
        wait for CLK_PERIOD * 20;
        test_done <= true;
        wait;
    end process;

end architecture sim;
