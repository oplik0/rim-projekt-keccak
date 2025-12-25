--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
--Date        : Mon Dec 22 23:25:30 2025
--Host        : DESKTOP-DI4989O running 64-bit major release  (build 9200)
--Command     : generate_target bd_0_wrapper.bd
--Design      : bd_0_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_0_wrapper is
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
end bd_0_wrapper;

architecture STRUCTURE of bd_0_wrapper is
  component bd_0 is
  port (
    ap_clk : in STD_LOGIC;
    ap_rst_n : in STD_LOGIC;
    interrupt : out STD_LOGIC;
    input_stream_tdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    input_stream_tkeep : in STD_LOGIC_VECTOR ( 7 downto 0 );
    input_stream_tlast : in STD_LOGIC_VECTOR ( 0 to 0 );
    input_stream_tready : out STD_LOGIC;
    input_stream_tstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    input_stream_tvalid : in STD_LOGIC;
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
  end component bd_0;
begin
bd_0_i: component bd_0
     port map (
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      input_stream_tdata(63 downto 0) => input_stream_tdata(63 downto 0),
      input_stream_tkeep(7 downto 0) => input_stream_tkeep(7 downto 0),
      input_stream_tlast(0) => input_stream_tlast(0),
      input_stream_tready => input_stream_tready,
      input_stream_tstrb(7 downto 0) => input_stream_tstrb(7 downto 0),
      input_stream_tvalid => input_stream_tvalid,
      interrupt => interrupt,
      output_stream_tdata(63 downto 0) => output_stream_tdata(63 downto 0),
      output_stream_tkeep(7 downto 0) => output_stream_tkeep(7 downto 0),
      output_stream_tlast(0) => output_stream_tlast(0),
      output_stream_tready => output_stream_tready,
      output_stream_tstrb(7 downto 0) => output_stream_tstrb(7 downto 0),
      output_stream_tvalid => output_stream_tvalid,
      s_axi_control_araddr(5 downto 0) => s_axi_control_araddr(5 downto 0),
      s_axi_control_arready => s_axi_control_arready,
      s_axi_control_arvalid => s_axi_control_arvalid,
      s_axi_control_awaddr(5 downto 0) => s_axi_control_awaddr(5 downto 0),
      s_axi_control_awready => s_axi_control_awready,
      s_axi_control_awvalid => s_axi_control_awvalid,
      s_axi_control_bready => s_axi_control_bready,
      s_axi_control_bresp(1 downto 0) => s_axi_control_bresp(1 downto 0),
      s_axi_control_bvalid => s_axi_control_bvalid,
      s_axi_control_rdata(31 downto 0) => s_axi_control_rdata(31 downto 0),
      s_axi_control_rready => s_axi_control_rready,
      s_axi_control_rresp(1 downto 0) => s_axi_control_rresp(1 downto 0),
      s_axi_control_rvalid => s_axi_control_rvalid,
      s_axi_control_wdata(31 downto 0) => s_axi_control_wdata(31 downto 0),
      s_axi_control_wready => s_axi_control_wready,
      s_axi_control_wstrb(3 downto 0) => s_axi_control_wstrb(3 downto 0),
      s_axi_control_wvalid => s_axi_control_wvalid
    );
end STRUCTURE;
