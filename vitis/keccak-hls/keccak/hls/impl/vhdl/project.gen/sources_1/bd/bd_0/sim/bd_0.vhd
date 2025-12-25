--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
--Date        : Mon Dec 22 23:25:30 2025
--Host        : DESKTOP-DI4989O running 64-bit major release  (build 9200)
--Command     : generate_target bd_0.bd
--Design      : bd_0
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_0 is
  port (
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    input_stream_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    input_stream_tkeep : in STD_LOGIC_VECTOR ( 7 downto 0 );
    input_stream_tlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    input_stream_tready : out STD_LOGIC;
    input_stream_tstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    input_stream_tvalid : in STD_LOGIC;
    interrupt : out STD_LOGIC;
    output_stream_tdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    output_stream_tkeep : out STD_LOGIC_VECTOR ( 7 downto 0 );
    output_stream_tlast : out STD_LOGIC_VECTOR ( 0 to 0 );
    output_stream_tready : in STD_LOGIC;
    output_stream_tstrb : out STD_LOGIC_VECTOR ( 7 downto 0 );
    output_stream_tvalid : out STD_LOGIC;
    s_axi_control_araddr : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_control_arready : out STD_LOGIC;
    s_axi_control_arvalid : in STD_LOGIC;
    s_axi_control_awaddr : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_control_awready : out STD_LOGIC;
    s_axi_control_awvalid : in STD_LOGIC;
    s_axi_control_bready : in STD_LOGIC;
    s_axi_control_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_control_bvalid : out STD_LOGIC;
    s_axi_control_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_control_rready : in STD_LOGIC;
    s_axi_control_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_control_rvalid : out STD_LOGIC;
    s_axi_control_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_control_wready : out STD_LOGIC;
    s_axi_control_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_control_wvalid : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of bd_0 : entity is "bd_0,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=bd_0,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=1,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of bd_0 : entity is "bd_0.hwdef";
end bd_0;

architecture STRUCTURE of bd_0 is
  component bd_0_hls_inst_0 is
  port (
    s_axi_control_ARADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_control_ARREADY : out STD_LOGIC;
    s_axi_control_ARVALID : in STD_LOGIC;
    s_axi_control_AWADDR : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_axi_control_AWREADY : out STD_LOGIC;
    s_axi_control_AWVALID : in STD_LOGIC;
    s_axi_control_BREADY : in STD_LOGIC;
    s_axi_control_BRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_control_BVALID : out STD_LOGIC;
    s_axi_control_RDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_control_RREADY : in STD_LOGIC;
    s_axi_control_RRESP : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_control_RVALID : out STD_LOGIC;
    s_axi_control_WDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_control_WREADY : out STD_LOGIC;
    s_axi_control_WSTRB : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_control_WVALID : in STD_LOGIC;
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    interrupt : out STD_LOGIC;
    input_stream_TDATA : in STD_LOGIC_VECTOR ( 63 downto 0 );
    input_stream_TKEEP : in STD_LOGIC_VECTOR ( 7 downto 0 );
    input_stream_TLAST : in STD_LOGIC_VECTOR ( 0 to 0 );
    input_stream_TREADY : out STD_LOGIC;
    input_stream_TSTRB : in STD_LOGIC_VECTOR ( 7 downto 0 );
    input_stream_TVALID : in STD_LOGIC;
    output_stream_TDATA : out STD_LOGIC_VECTOR ( 63 downto 0 );
    output_stream_TKEEP : out STD_LOGIC_VECTOR ( 7 downto 0 );
    output_stream_TLAST : out STD_LOGIC_VECTOR ( 0 to 0 );
    output_stream_TREADY : in STD_LOGIC;
    output_stream_TSTRB : out STD_LOGIC_VECTOR ( 7 downto 0 );
    output_stream_TVALID : out STD_LOGIC
  );
  end component bd_0_hls_inst_0;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of ap_clk : signal is "xilinx.com:signal:clock:1.0 CLK.AP_CLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of ap_clk : signal is "XIL_INTERFACENAME CLK.AP_CLK, ASSOCIATED_BUSIF input_stream:output_stream:s_axi_control, ASSOCIATED_RESET ap_rst_n, CLK_DOMAIN bd_0_ap_clk_0, FREQ_HZ 200000000.0, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of ap_rst_n : signal is "xilinx.com:signal:reset:1.0 RST.AP_RST_N RST";
  attribute X_INTERFACE_PARAMETER of ap_rst_n : signal is "XIL_INTERFACENAME RST.AP_RST_N, INSERT_VIP 0, POLARITY ACTIVE_LOW";
  attribute X_INTERFACE_INFO of input_stream_tready : signal is "xilinx.com:interface:axis:1.0 input_stream TREADY";
  attribute X_INTERFACE_INFO of input_stream_tvalid : signal is "xilinx.com:interface:axis:1.0 input_stream TVALID";
  attribute X_INTERFACE_INFO of interrupt : signal is "xilinx.com:signal:interrupt:1.0 INTR.INTERRUPT INTERRUPT";
  attribute X_INTERFACE_PARAMETER of interrupt : signal is "XIL_INTERFACENAME INTR.INTERRUPT, PortWidth 1, SENSITIVITY LEVEL_HIGH";
  attribute X_INTERFACE_INFO of output_stream_tready : signal is "xilinx.com:interface:axis:1.0 output_stream TREADY";
  attribute X_INTERFACE_INFO of output_stream_tvalid : signal is "xilinx.com:interface:axis:1.0 output_stream TVALID";
  attribute X_INTERFACE_INFO of s_axi_control_arready : signal is "xilinx.com:interface:aximm:1.0 s_axi_control ARREADY";
  attribute X_INTERFACE_INFO of s_axi_control_arvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi_control ARVALID";
  attribute X_INTERFACE_INFO of s_axi_control_awready : signal is "xilinx.com:interface:aximm:1.0 s_axi_control AWREADY";
  attribute X_INTERFACE_INFO of s_axi_control_awvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi_control AWVALID";
  attribute X_INTERFACE_INFO of s_axi_control_bready : signal is "xilinx.com:interface:aximm:1.0 s_axi_control BREADY";
  attribute X_INTERFACE_INFO of s_axi_control_bvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi_control BVALID";
  attribute X_INTERFACE_INFO of s_axi_control_rready : signal is "xilinx.com:interface:aximm:1.0 s_axi_control RREADY";
  attribute X_INTERFACE_INFO of s_axi_control_rvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi_control RVALID";
  attribute X_INTERFACE_INFO of s_axi_control_wready : signal is "xilinx.com:interface:aximm:1.0 s_axi_control WREADY";
  attribute X_INTERFACE_INFO of s_axi_control_wvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi_control WVALID";
  attribute X_INTERFACE_INFO of input_stream_tdata : signal is "xilinx.com:interface:axis:1.0 input_stream TDATA";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of input_stream_tdata : signal is "Slave";
  attribute X_INTERFACE_PARAMETER of input_stream_tdata : signal is "XIL_INTERFACENAME input_stream, CLK_DOMAIN bd_0_ap_clk_0, FREQ_HZ 200000000.0, HAS_TKEEP 1, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 1, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0";
  attribute X_INTERFACE_INFO of input_stream_tkeep : signal is "xilinx.com:interface:axis:1.0 input_stream TKEEP";
  attribute X_INTERFACE_INFO of input_stream_tlast : signal is "xilinx.com:interface:axis:1.0 input_stream TLAST";
  attribute X_INTERFACE_INFO of input_stream_tstrb : signal is "xilinx.com:interface:axis:1.0 input_stream TSTRB";
  attribute X_INTERFACE_INFO of output_stream_tdata : signal is "xilinx.com:interface:axis:1.0 output_stream TDATA";
  attribute X_INTERFACE_MODE of output_stream_tdata : signal is "Master";
  attribute X_INTERFACE_PARAMETER of output_stream_tdata : signal is "XIL_INTERFACENAME output_stream, CLK_DOMAIN bd_0_ap_clk_0, FREQ_HZ 200000000.0, HAS_TKEEP 1, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 1, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 8, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0";
  attribute X_INTERFACE_INFO of output_stream_tkeep : signal is "xilinx.com:interface:axis:1.0 output_stream TKEEP";
  attribute X_INTERFACE_INFO of output_stream_tlast : signal is "xilinx.com:interface:axis:1.0 output_stream TLAST";
  attribute X_INTERFACE_INFO of output_stream_tstrb : signal is "xilinx.com:interface:axis:1.0 output_stream TSTRB";
  attribute X_INTERFACE_INFO of s_axi_control_araddr : signal is "xilinx.com:interface:aximm:1.0 s_axi_control ARADDR";
  attribute X_INTERFACE_MODE of s_axi_control_araddr : signal is "Slave";
  attribute X_INTERFACE_PARAMETER of s_axi_control_araddr : signal is "XIL_INTERFACENAME s_axi_control, ADDR_WIDTH 32, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN bd_0_ap_clk_0, DATA_WIDTH 32, FREQ_HZ 200000000.0, HAS_BRESP 1, HAS_BURST 0, HAS_CACHE 0, HAS_LOCK 0, HAS_PROT 0, HAS_QOS 0, HAS_REGION 0, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 0, INSERT_VIP 0, MAX_BURST_LENGTH 1, NUM_READ_OUTSTANDING 1, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 1, NUM_WRITE_THREADS 1, PHASE 0.0, PROTOCOL AXI4LITE, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0";
  attribute X_INTERFACE_INFO of s_axi_control_awaddr : signal is "xilinx.com:interface:aximm:1.0 s_axi_control AWADDR";
  attribute X_INTERFACE_INFO of s_axi_control_bresp : signal is "xilinx.com:interface:aximm:1.0 s_axi_control BRESP";
  attribute X_INTERFACE_INFO of s_axi_control_rdata : signal is "xilinx.com:interface:aximm:1.0 s_axi_control RDATA";
  attribute X_INTERFACE_INFO of s_axi_control_rresp : signal is "xilinx.com:interface:aximm:1.0 s_axi_control RRESP";
  attribute X_INTERFACE_INFO of s_axi_control_wdata : signal is "xilinx.com:interface:aximm:1.0 s_axi_control WDATA";
  attribute X_INTERFACE_INFO of s_axi_control_wstrb : signal is "xilinx.com:interface:aximm:1.0 s_axi_control WSTRB";
begin
hls_inst: component bd_0_hls_inst_0
     port map (
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      input_stream_TDATA(63 downto 0) => input_stream_tdata(63 downto 0),
      input_stream_TKEEP(7 downto 0) => input_stream_tkeep(7 downto 0),
      input_stream_TLAST(0) => input_stream_tlast(0),
      input_stream_TREADY => input_stream_tready,
      input_stream_TSTRB(7 downto 0) => input_stream_tstrb(7 downto 0),
      input_stream_TVALID => input_stream_tvalid,
      interrupt => interrupt,
      output_stream_TDATA(63 downto 0) => output_stream_tdata(63 downto 0),
      output_stream_TKEEP(7 downto 0) => output_stream_tkeep(7 downto 0),
      output_stream_TLAST(0) => output_stream_tlast(0),
      output_stream_TREADY => output_stream_tready,
      output_stream_TSTRB(7 downto 0) => output_stream_tstrb(7 downto 0),
      output_stream_TVALID => output_stream_tvalid,
      s_axi_control_ARADDR(5 downto 0) => s_axi_control_araddr(5 downto 0),
      s_axi_control_ARREADY => s_axi_control_arready,
      s_axi_control_ARVALID => s_axi_control_arvalid,
      s_axi_control_AWADDR(5 downto 0) => s_axi_control_awaddr(5 downto 0),
      s_axi_control_AWREADY => s_axi_control_awready,
      s_axi_control_AWVALID => s_axi_control_awvalid,
      s_axi_control_BREADY => s_axi_control_bready,
      s_axi_control_BRESP(1 downto 0) => s_axi_control_bresp(1 downto 0),
      s_axi_control_BVALID => s_axi_control_bvalid,
      s_axi_control_RDATA(31 downto 0) => s_axi_control_rdata(31 downto 0),
      s_axi_control_RREADY => s_axi_control_rready,
      s_axi_control_RRESP(1 downto 0) => s_axi_control_rresp(1 downto 0),
      s_axi_control_RVALID => s_axi_control_rvalid,
      s_axi_control_WDATA(31 downto 0) => s_axi_control_wdata(31 downto 0),
      s_axi_control_WREADY => s_axi_control_wready,
      s_axi_control_WSTRB(3 downto 0) => s_axi_control_wstrb(3 downto 0),
      s_axi_control_WVALID => s_axi_control_wvalid
    );
end STRUCTURE;
