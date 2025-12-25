set moduleName keccak_top_Pipeline_ABSORB_BLOCK
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set isPipelined_legacy 1
set pipeline_type loop_auto_rewind
set FunctionProtocol ap_ctrl_hs
set restart_counter_num 0
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 6
set C_modelName {keccak_top_Pipeline_ABSORB_BLOCK}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ message_done int 1 regular  }
	{ trunc_ln1 int 6 regular  }
	{ state_24 int 64 regular {pointer 2}  }
	{ state_23 int 64 regular {pointer 2}  }
	{ state_22 int 64 regular {pointer 2}  }
	{ state_21 int 64 regular {pointer 2}  }
	{ state_20 int 64 regular {pointer 2}  }
	{ state_19 int 64 regular {pointer 2}  }
	{ state_18 int 64 regular {pointer 2}  }
	{ state_17 int 64 regular {pointer 2}  }
	{ state_16 int 64 regular {pointer 2}  }
	{ state_15 int 64 regular {pointer 2}  }
	{ state_14 int 64 regular {pointer 2}  }
	{ state_13 int 64 regular {pointer 2}  }
	{ state_12 int 64 regular {pointer 2}  }
	{ state_11 int 64 regular {pointer 2}  }
	{ state_10 int 64 regular {pointer 2}  }
	{ state_9 int 64 regular {pointer 2}  }
	{ state_8 int 64 regular {pointer 2}  }
	{ state_7 int 64 regular {pointer 2}  }
	{ state_6 int 64 regular {pointer 2}  }
	{ state_5 int 64 regular {pointer 2}  }
	{ state_4 int 64 regular {pointer 2}  }
	{ state_3 int 64 regular {pointer 2}  }
	{ state_2 int 64 regular {pointer 2}  }
	{ state_1 int 64 regular {pointer 2}  }
	{ state int 64 regular {pointer 2}  }
	{ input_stream_V_data_V int 64 regular {axi_s 0 volatile  { input_stream Data } }  }
	{ input_stream_V_keep_V int 8 regular {axi_s 0 volatile  { input_stream Keep } }  }
	{ input_stream_V_strb_V int 8 regular {axi_s 0 volatile  { input_stream Strb } }  }
	{ input_stream_V_last_V int 1 regular {axi_s 0 volatile  { input_stream Last } }  }
	{ message_done_1_out int 1 regular {pointer 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "message_done", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "trunc_ln1", "interface" : "wire", "bitwidth" : 6, "direction" : "READONLY"} , 
 	{ "Name" : "state_24", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_23", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_22", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_21", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_20", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_19", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_18", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_17", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_16", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_15", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_14", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_13", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_12", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_11", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_10", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_9", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_8", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_7", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_6", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_5", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_4", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_3", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state_1", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "state", "interface" : "wire", "bitwidth" : 64, "direction" : "READWRITE"} , 
 	{ "Name" : "input_stream_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "input_stream_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "input_stream_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "input_stream_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "message_done_1_out", "interface" : "wire", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 91
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ input_stream_TVALID sc_in sc_logic 1 invld 27 } 
	{ message_done sc_in sc_lv 1 signal 0 } 
	{ trunc_ln1 sc_in sc_lv 6 signal 1 } 
	{ state_24_i sc_in sc_lv 64 signal 2 } 
	{ state_24_o sc_out sc_lv 64 signal 2 } 
	{ state_24_o_ap_vld sc_out sc_logic 1 outvld 2 } 
	{ state_23_i sc_in sc_lv 64 signal 3 } 
	{ state_23_o sc_out sc_lv 64 signal 3 } 
	{ state_23_o_ap_vld sc_out sc_logic 1 outvld 3 } 
	{ state_22_i sc_in sc_lv 64 signal 4 } 
	{ state_22_o sc_out sc_lv 64 signal 4 } 
	{ state_22_o_ap_vld sc_out sc_logic 1 outvld 4 } 
	{ state_21_i sc_in sc_lv 64 signal 5 } 
	{ state_21_o sc_out sc_lv 64 signal 5 } 
	{ state_21_o_ap_vld sc_out sc_logic 1 outvld 5 } 
	{ state_20_i sc_in sc_lv 64 signal 6 } 
	{ state_20_o sc_out sc_lv 64 signal 6 } 
	{ state_20_o_ap_vld sc_out sc_logic 1 outvld 6 } 
	{ state_19_i sc_in sc_lv 64 signal 7 } 
	{ state_19_o sc_out sc_lv 64 signal 7 } 
	{ state_19_o_ap_vld sc_out sc_logic 1 outvld 7 } 
	{ state_18_i sc_in sc_lv 64 signal 8 } 
	{ state_18_o sc_out sc_lv 64 signal 8 } 
	{ state_18_o_ap_vld sc_out sc_logic 1 outvld 8 } 
	{ state_17_i sc_in sc_lv 64 signal 9 } 
	{ state_17_o sc_out sc_lv 64 signal 9 } 
	{ state_17_o_ap_vld sc_out sc_logic 1 outvld 9 } 
	{ state_16_i sc_in sc_lv 64 signal 10 } 
	{ state_16_o sc_out sc_lv 64 signal 10 } 
	{ state_16_o_ap_vld sc_out sc_logic 1 outvld 10 } 
	{ state_15_i sc_in sc_lv 64 signal 11 } 
	{ state_15_o sc_out sc_lv 64 signal 11 } 
	{ state_15_o_ap_vld sc_out sc_logic 1 outvld 11 } 
	{ state_14_i sc_in sc_lv 64 signal 12 } 
	{ state_14_o sc_out sc_lv 64 signal 12 } 
	{ state_14_o_ap_vld sc_out sc_logic 1 outvld 12 } 
	{ state_13_i sc_in sc_lv 64 signal 13 } 
	{ state_13_o sc_out sc_lv 64 signal 13 } 
	{ state_13_o_ap_vld sc_out sc_logic 1 outvld 13 } 
	{ state_12_i sc_in sc_lv 64 signal 14 } 
	{ state_12_o sc_out sc_lv 64 signal 14 } 
	{ state_12_o_ap_vld sc_out sc_logic 1 outvld 14 } 
	{ state_11_i sc_in sc_lv 64 signal 15 } 
	{ state_11_o sc_out sc_lv 64 signal 15 } 
	{ state_11_o_ap_vld sc_out sc_logic 1 outvld 15 } 
	{ state_10_i sc_in sc_lv 64 signal 16 } 
	{ state_10_o sc_out sc_lv 64 signal 16 } 
	{ state_10_o_ap_vld sc_out sc_logic 1 outvld 16 } 
	{ state_9_i sc_in sc_lv 64 signal 17 } 
	{ state_9_o sc_out sc_lv 64 signal 17 } 
	{ state_9_o_ap_vld sc_out sc_logic 1 outvld 17 } 
	{ state_8_i sc_in sc_lv 64 signal 18 } 
	{ state_8_o sc_out sc_lv 64 signal 18 } 
	{ state_8_o_ap_vld sc_out sc_logic 1 outvld 18 } 
	{ state_7_i sc_in sc_lv 64 signal 19 } 
	{ state_7_o sc_out sc_lv 64 signal 19 } 
	{ state_7_o_ap_vld sc_out sc_logic 1 outvld 19 } 
	{ state_6_i sc_in sc_lv 64 signal 20 } 
	{ state_6_o sc_out sc_lv 64 signal 20 } 
	{ state_6_o_ap_vld sc_out sc_logic 1 outvld 20 } 
	{ state_5_i sc_in sc_lv 64 signal 21 } 
	{ state_5_o sc_out sc_lv 64 signal 21 } 
	{ state_5_o_ap_vld sc_out sc_logic 1 outvld 21 } 
	{ state_4_i sc_in sc_lv 64 signal 22 } 
	{ state_4_o sc_out sc_lv 64 signal 22 } 
	{ state_4_o_ap_vld sc_out sc_logic 1 outvld 22 } 
	{ state_3_i sc_in sc_lv 64 signal 23 } 
	{ state_3_o sc_out sc_lv 64 signal 23 } 
	{ state_3_o_ap_vld sc_out sc_logic 1 outvld 23 } 
	{ state_2_i sc_in sc_lv 64 signal 24 } 
	{ state_2_o sc_out sc_lv 64 signal 24 } 
	{ state_2_o_ap_vld sc_out sc_logic 1 outvld 24 } 
	{ state_1_i sc_in sc_lv 64 signal 25 } 
	{ state_1_o sc_out sc_lv 64 signal 25 } 
	{ state_1_o_ap_vld sc_out sc_logic 1 outvld 25 } 
	{ state_i sc_in sc_lv 64 signal 26 } 
	{ state_o sc_out sc_lv 64 signal 26 } 
	{ state_o_ap_vld sc_out sc_logic 1 outvld 26 } 
	{ input_stream_TDATA sc_in sc_lv 64 signal 27 } 
	{ input_stream_TREADY sc_out sc_logic 1 inacc 30 } 
	{ input_stream_TKEEP sc_in sc_lv 8 signal 28 } 
	{ input_stream_TSTRB sc_in sc_lv 8 signal 29 } 
	{ input_stream_TLAST sc_in sc_lv 1 signal 30 } 
	{ message_done_1_out sc_out sc_lv 1 signal 31 } 
	{ message_done_1_out_ap_vld sc_out sc_logic 1 outvld 31 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "input_stream_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "input_stream_V_data_V", "role": "default" }} , 
 	{ "name": "message_done", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "message_done", "role": "default" }} , 
 	{ "name": "trunc_ln1", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "trunc_ln1", "role": "default" }} , 
 	{ "name": "state_24_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_24", "role": "i" }} , 
 	{ "name": "state_24_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_24", "role": "o" }} , 
 	{ "name": "state_24_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_24", "role": "o_ap_vld" }} , 
 	{ "name": "state_23_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_23", "role": "i" }} , 
 	{ "name": "state_23_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_23", "role": "o" }} , 
 	{ "name": "state_23_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_23", "role": "o_ap_vld" }} , 
 	{ "name": "state_22_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_22", "role": "i" }} , 
 	{ "name": "state_22_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_22", "role": "o" }} , 
 	{ "name": "state_22_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_22", "role": "o_ap_vld" }} , 
 	{ "name": "state_21_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_21", "role": "i" }} , 
 	{ "name": "state_21_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_21", "role": "o" }} , 
 	{ "name": "state_21_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_21", "role": "o_ap_vld" }} , 
 	{ "name": "state_20_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_20", "role": "i" }} , 
 	{ "name": "state_20_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_20", "role": "o" }} , 
 	{ "name": "state_20_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_20", "role": "o_ap_vld" }} , 
 	{ "name": "state_19_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_19", "role": "i" }} , 
 	{ "name": "state_19_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_19", "role": "o" }} , 
 	{ "name": "state_19_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_19", "role": "o_ap_vld" }} , 
 	{ "name": "state_18_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_18", "role": "i" }} , 
 	{ "name": "state_18_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_18", "role": "o" }} , 
 	{ "name": "state_18_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_18", "role": "o_ap_vld" }} , 
 	{ "name": "state_17_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_17", "role": "i" }} , 
 	{ "name": "state_17_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_17", "role": "o" }} , 
 	{ "name": "state_17_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_17", "role": "o_ap_vld" }} , 
 	{ "name": "state_16_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_16", "role": "i" }} , 
 	{ "name": "state_16_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_16", "role": "o" }} , 
 	{ "name": "state_16_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_16", "role": "o_ap_vld" }} , 
 	{ "name": "state_15_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_15", "role": "i" }} , 
 	{ "name": "state_15_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_15", "role": "o" }} , 
 	{ "name": "state_15_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_15", "role": "o_ap_vld" }} , 
 	{ "name": "state_14_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_14", "role": "i" }} , 
 	{ "name": "state_14_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_14", "role": "o" }} , 
 	{ "name": "state_14_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_14", "role": "o_ap_vld" }} , 
 	{ "name": "state_13_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_13", "role": "i" }} , 
 	{ "name": "state_13_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_13", "role": "o" }} , 
 	{ "name": "state_13_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_13", "role": "o_ap_vld" }} , 
 	{ "name": "state_12_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_12", "role": "i" }} , 
 	{ "name": "state_12_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_12", "role": "o" }} , 
 	{ "name": "state_12_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_12", "role": "o_ap_vld" }} , 
 	{ "name": "state_11_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_11", "role": "i" }} , 
 	{ "name": "state_11_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_11", "role": "o" }} , 
 	{ "name": "state_11_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_11", "role": "o_ap_vld" }} , 
 	{ "name": "state_10_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_10", "role": "i" }} , 
 	{ "name": "state_10_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_10", "role": "o" }} , 
 	{ "name": "state_10_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_10", "role": "o_ap_vld" }} , 
 	{ "name": "state_9_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_9", "role": "i" }} , 
 	{ "name": "state_9_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_9", "role": "o" }} , 
 	{ "name": "state_9_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_9", "role": "o_ap_vld" }} , 
 	{ "name": "state_8_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_8", "role": "i" }} , 
 	{ "name": "state_8_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_8", "role": "o" }} , 
 	{ "name": "state_8_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_8", "role": "o_ap_vld" }} , 
 	{ "name": "state_7_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_7", "role": "i" }} , 
 	{ "name": "state_7_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_7", "role": "o" }} , 
 	{ "name": "state_7_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_7", "role": "o_ap_vld" }} , 
 	{ "name": "state_6_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_6", "role": "i" }} , 
 	{ "name": "state_6_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_6", "role": "o" }} , 
 	{ "name": "state_6_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_6", "role": "o_ap_vld" }} , 
 	{ "name": "state_5_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_5", "role": "i" }} , 
 	{ "name": "state_5_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_5", "role": "o" }} , 
 	{ "name": "state_5_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_5", "role": "o_ap_vld" }} , 
 	{ "name": "state_4_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_4", "role": "i" }} , 
 	{ "name": "state_4_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_4", "role": "o" }} , 
 	{ "name": "state_4_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_4", "role": "o_ap_vld" }} , 
 	{ "name": "state_3_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_3", "role": "i" }} , 
 	{ "name": "state_3_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_3", "role": "o" }} , 
 	{ "name": "state_3_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_3", "role": "o_ap_vld" }} , 
 	{ "name": "state_2_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_2", "role": "i" }} , 
 	{ "name": "state_2_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_2", "role": "o" }} , 
 	{ "name": "state_2_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_2", "role": "o_ap_vld" }} , 
 	{ "name": "state_1_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_1", "role": "i" }} , 
 	{ "name": "state_1_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_1", "role": "o" }} , 
 	{ "name": "state_1_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state_1", "role": "o_ap_vld" }} , 
 	{ "name": "state_i", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state", "role": "i" }} , 
 	{ "name": "state_o", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state", "role": "o" }} , 
 	{ "name": "state_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "state", "role": "o_ap_vld" }} , 
 	{ "name": "input_stream_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "input_stream_V_data_V", "role": "default" }} , 
 	{ "name": "input_stream_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "input_stream_V_last_V", "role": "default" }} , 
 	{ "name": "input_stream_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "input_stream_V_keep_V", "role": "default" }} , 
 	{ "name": "input_stream_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "input_stream_V_strb_V", "role": "default" }} , 
 	{ "name": "input_stream_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "input_stream_V_last_V", "role": "default" }} , 
 	{ "name": "message_done_1_out", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "message_done_1_out", "role": "default" }} , 
 	{ "name": "message_done_1_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "message_done_1_out", "role": "ap_vld" }}  ]}

set ArgLastReadFirstWriteLatency {
	keccak_top_Pipeline_ABSORB_BLOCK {
		message_done {Type I LastRead 0 FirstWrite -1}
		trunc_ln1 {Type I LastRead 0 FirstWrite -1}
		state_24 {Type IO LastRead 1 FirstWrite 1}
		state_23 {Type IO LastRead 1 FirstWrite 1}
		state_22 {Type IO LastRead 1 FirstWrite 1}
		state_21 {Type IO LastRead 1 FirstWrite 1}
		state_20 {Type IO LastRead 1 FirstWrite 1}
		state_19 {Type IO LastRead 1 FirstWrite 1}
		state_18 {Type IO LastRead 1 FirstWrite 1}
		state_17 {Type IO LastRead 1 FirstWrite 1}
		state_16 {Type IO LastRead 1 FirstWrite 1}
		state_15 {Type IO LastRead 1 FirstWrite 1}
		state_14 {Type IO LastRead 1 FirstWrite 1}
		state_13 {Type IO LastRead 1 FirstWrite 1}
		state_12 {Type IO LastRead 1 FirstWrite 1}
		state_11 {Type IO LastRead 1 FirstWrite 1}
		state_10 {Type IO LastRead 1 FirstWrite 1}
		state_9 {Type IO LastRead 1 FirstWrite 1}
		state_8 {Type IO LastRead 1 FirstWrite 1}
		state_7 {Type IO LastRead 1 FirstWrite 1}
		state_6 {Type IO LastRead 1 FirstWrite 1}
		state_5 {Type IO LastRead 1 FirstWrite 1}
		state_4 {Type IO LastRead 1 FirstWrite 1}
		state_3 {Type IO LastRead 1 FirstWrite 1}
		state_2 {Type IO LastRead 1 FirstWrite 1}
		state_1 {Type IO LastRead 1 FirstWrite 1}
		state {Type IO LastRead 1 FirstWrite 1}
		input_stream_V_data_V {Type I LastRead 1 FirstWrite -1}
		input_stream_V_keep_V {Type I LastRead 1 FirstWrite -1}
		input_stream_V_strb_V {Type I LastRead 1 FirstWrite -1}
		input_stream_V_last_V {Type I LastRead 1 FirstWrite -1}
		message_done_1_out {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2", "Max" : "34"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "33"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	message_done { ap_none {  { message_done in_data 0 1 } } }
	trunc_ln1 { ap_none {  { trunc_ln1 in_data 0 6 } } }
	state_24 { ap_ovld {  { state_24_i in_data 0 64 }  { state_24_o out_data 1 64 }  { state_24_o_ap_vld out_vld 1 1 } } }
	state_23 { ap_ovld {  { state_23_i in_data 0 64 }  { state_23_o out_data 1 64 }  { state_23_o_ap_vld out_vld 1 1 } } }
	state_22 { ap_ovld {  { state_22_i in_data 0 64 }  { state_22_o out_data 1 64 }  { state_22_o_ap_vld out_vld 1 1 } } }
	state_21 { ap_ovld {  { state_21_i in_data 0 64 }  { state_21_o out_data 1 64 }  { state_21_o_ap_vld out_vld 1 1 } } }
	state_20 { ap_ovld {  { state_20_i in_data 0 64 }  { state_20_o out_data 1 64 }  { state_20_o_ap_vld out_vld 1 1 } } }
	state_19 { ap_ovld {  { state_19_i in_data 0 64 }  { state_19_o out_data 1 64 }  { state_19_o_ap_vld out_vld 1 1 } } }
	state_18 { ap_ovld {  { state_18_i in_data 0 64 }  { state_18_o out_data 1 64 }  { state_18_o_ap_vld out_vld 1 1 } } }
	state_17 { ap_ovld {  { state_17_i in_data 0 64 }  { state_17_o out_data 1 64 }  { state_17_o_ap_vld out_vld 1 1 } } }
	state_16 { ap_ovld {  { state_16_i in_data 0 64 }  { state_16_o out_data 1 64 }  { state_16_o_ap_vld out_vld 1 1 } } }
	state_15 { ap_ovld {  { state_15_i in_data 0 64 }  { state_15_o out_data 1 64 }  { state_15_o_ap_vld out_vld 1 1 } } }
	state_14 { ap_ovld {  { state_14_i in_data 0 64 }  { state_14_o out_data 1 64 }  { state_14_o_ap_vld out_vld 1 1 } } }
	state_13 { ap_ovld {  { state_13_i in_data 0 64 }  { state_13_o out_data 1 64 }  { state_13_o_ap_vld out_vld 1 1 } } }
	state_12 { ap_ovld {  { state_12_i in_data 0 64 }  { state_12_o out_data 1 64 }  { state_12_o_ap_vld out_vld 1 1 } } }
	state_11 { ap_ovld {  { state_11_i in_data 0 64 }  { state_11_o out_data 1 64 }  { state_11_o_ap_vld out_vld 1 1 } } }
	state_10 { ap_ovld {  { state_10_i in_data 0 64 }  { state_10_o out_data 1 64 }  { state_10_o_ap_vld out_vld 1 1 } } }
	state_9 { ap_ovld {  { state_9_i in_data 0 64 }  { state_9_o out_data 1 64 }  { state_9_o_ap_vld out_vld 1 1 } } }
	state_8 { ap_ovld {  { state_8_i in_data 0 64 }  { state_8_o out_data 1 64 }  { state_8_o_ap_vld out_vld 1 1 } } }
	state_7 { ap_ovld {  { state_7_i in_data 0 64 }  { state_7_o out_data 1 64 }  { state_7_o_ap_vld out_vld 1 1 } } }
	state_6 { ap_ovld {  { state_6_i in_data 0 64 }  { state_6_o out_data 1 64 }  { state_6_o_ap_vld out_vld 1 1 } } }
	state_5 { ap_ovld {  { state_5_i in_data 0 64 }  { state_5_o out_data 1 64 }  { state_5_o_ap_vld out_vld 1 1 } } }
	state_4 { ap_ovld {  { state_4_i in_data 0 64 }  { state_4_o out_data 1 64 }  { state_4_o_ap_vld out_vld 1 1 } } }
	state_3 { ap_ovld {  { state_3_i in_data 0 64 }  { state_3_o out_data 1 64 }  { state_3_o_ap_vld out_vld 1 1 } } }
	state_2 { ap_ovld {  { state_2_i in_data 0 64 }  { state_2_o out_data 1 64 }  { state_2_o_ap_vld out_vld 1 1 } } }
	state_1 { ap_ovld {  { state_1_i in_data 0 64 }  { state_1_o out_data 1 64 }  { state_1_o_ap_vld out_vld 1 1 } } }
	state { ap_ovld {  { state_i in_data 0 64 }  { state_o out_data 1 64 }  { state_o_ap_vld out_vld 1 1 } } }
	input_stream_V_data_V { axis {  { input_stream_TVALID in_vld 0 1 }  { input_stream_TDATA in_data 0 64 } } }
	input_stream_V_keep_V { axis {  { input_stream_TKEEP in_data 0 8 } } }
	input_stream_V_strb_V { axis {  { input_stream_TSTRB in_data 0 8 } } }
	input_stream_V_last_V { axis {  { input_stream_TREADY in_acc 1 1 }  { input_stream_TLAST in_data 0 1 } } }
	message_done_1_out { ap_vld {  { message_done_1_out out_data 1 1 }  { message_done_1_out_ap_vld out_vld 1 1 } } }
}
