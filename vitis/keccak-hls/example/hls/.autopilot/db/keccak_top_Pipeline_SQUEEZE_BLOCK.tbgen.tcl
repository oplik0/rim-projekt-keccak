set moduleName keccak_top_Pipeline_SQUEEZE_BLOCK
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
set C_modelName {keccak_top_Pipeline_SQUEEZE_BLOCK}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ output_remaining int 31 regular  }
	{ trunc_ln6 int 6 regular  }
	{ state_load_2 int 64 regular  }
	{ state_1_load_2 int 64 regular  }
	{ state_2_load_2 int 64 regular  }
	{ state_3_load_2 int 64 regular  }
	{ state_4_load_2 int 64 regular  }
	{ state_5_load_2 int 64 regular  }
	{ state_6_load_2 int 64 regular  }
	{ state_7_load_2 int 64 regular  }
	{ state_8_load_2 int 64 regular  }
	{ state_9_load_2 int 64 regular  }
	{ state_10_load_2 int 64 regular  }
	{ state_11_load_2 int 64 regular  }
	{ state_12_load_2 int 64 regular  }
	{ state_13_load_2 int 64 regular  }
	{ state_14_load_2 int 64 regular  }
	{ state_15_load_2 int 64 regular  }
	{ state_16_load_2 int 64 regular  }
	{ state_17_load_2 int 64 regular  }
	{ state_18_load_2 int 64 regular  }
	{ state_19_load_2 int 64 regular  }
	{ state_20_load_2 int 64 regular  }
	{ state_21_load_2 int 64 regular  }
	{ state_22_load_2 int 64 regular  }
	{ state_23_load_2 int 64 regular  }
	{ state_24_load_2 int 64 regular  }
	{ output_stream_V_data_V int 64 regular {axi_s 1 volatile  { output_stream Data } }  }
	{ output_stream_V_keep_V int 8 regular {axi_s 1 volatile  { output_stream Keep } }  }
	{ output_stream_V_strb_V int 8 regular {axi_s 1 volatile  { output_stream Strb } }  }
	{ output_stream_V_last_V int 1 regular {axi_s 1 volatile  { output_stream Last } }  }
	{ output_remaining_1_out int 32 regular {pointer 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "output_remaining", "interface" : "wire", "bitwidth" : 31, "direction" : "READONLY"} , 
 	{ "Name" : "trunc_ln6", "interface" : "wire", "bitwidth" : 6, "direction" : "READONLY"} , 
 	{ "Name" : "state_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_1_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_2_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_3_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_4_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_5_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_6_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_7_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_8_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_9_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_10_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_11_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_12_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_13_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_14_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_15_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_16_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_17_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_18_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_19_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_20_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_21_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_22_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_23_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "state_24_load_2", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "output_stream_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "WRITEONLY"} , 
 	{ "Name" : "output_stream_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "output_stream_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "output_stream_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "output_remaining_1_out", "interface" : "wire", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 41
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ output_stream_TREADY sc_in sc_logic 1 outacc 27 } 
	{ output_remaining sc_in sc_lv 31 signal 0 } 
	{ trunc_ln6 sc_in sc_lv 6 signal 1 } 
	{ state_load_2 sc_in sc_lv 64 signal 2 } 
	{ state_1_load_2 sc_in sc_lv 64 signal 3 } 
	{ state_2_load_2 sc_in sc_lv 64 signal 4 } 
	{ state_3_load_2 sc_in sc_lv 64 signal 5 } 
	{ state_4_load_2 sc_in sc_lv 64 signal 6 } 
	{ state_5_load_2 sc_in sc_lv 64 signal 7 } 
	{ state_6_load_2 sc_in sc_lv 64 signal 8 } 
	{ state_7_load_2 sc_in sc_lv 64 signal 9 } 
	{ state_8_load_2 sc_in sc_lv 64 signal 10 } 
	{ state_9_load_2 sc_in sc_lv 64 signal 11 } 
	{ state_10_load_2 sc_in sc_lv 64 signal 12 } 
	{ state_11_load_2 sc_in sc_lv 64 signal 13 } 
	{ state_12_load_2 sc_in sc_lv 64 signal 14 } 
	{ state_13_load_2 sc_in sc_lv 64 signal 15 } 
	{ state_14_load_2 sc_in sc_lv 64 signal 16 } 
	{ state_15_load_2 sc_in sc_lv 64 signal 17 } 
	{ state_16_load_2 sc_in sc_lv 64 signal 18 } 
	{ state_17_load_2 sc_in sc_lv 64 signal 19 } 
	{ state_18_load_2 sc_in sc_lv 64 signal 20 } 
	{ state_19_load_2 sc_in sc_lv 64 signal 21 } 
	{ state_20_load_2 sc_in sc_lv 64 signal 22 } 
	{ state_21_load_2 sc_in sc_lv 64 signal 23 } 
	{ state_22_load_2 sc_in sc_lv 64 signal 24 } 
	{ state_23_load_2 sc_in sc_lv 64 signal 25 } 
	{ state_24_load_2 sc_in sc_lv 64 signal 26 } 
	{ output_stream_TDATA sc_out sc_lv 64 signal 27 } 
	{ output_stream_TVALID sc_out sc_logic 1 outvld 30 } 
	{ output_stream_TKEEP sc_out sc_lv 8 signal 28 } 
	{ output_stream_TSTRB sc_out sc_lv 8 signal 29 } 
	{ output_stream_TLAST sc_out sc_lv 1 signal 30 } 
	{ output_remaining_1_out sc_out sc_lv 32 signal 31 } 
	{ output_remaining_1_out_ap_vld sc_out sc_logic 1 outvld 31 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "output_stream_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "output_stream_V_data_V", "role": "default" }} , 
 	{ "name": "output_remaining", "direction": "in", "datatype": "sc_lv", "bitwidth":31, "type": "signal", "bundle":{"name": "output_remaining", "role": "default" }} , 
 	{ "name": "trunc_ln6", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "trunc_ln6", "role": "default" }} , 
 	{ "name": "state_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_load_2", "role": "default" }} , 
 	{ "name": "state_1_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_1_load_2", "role": "default" }} , 
 	{ "name": "state_2_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_2_load_2", "role": "default" }} , 
 	{ "name": "state_3_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_3_load_2", "role": "default" }} , 
 	{ "name": "state_4_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_4_load_2", "role": "default" }} , 
 	{ "name": "state_5_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_5_load_2", "role": "default" }} , 
 	{ "name": "state_6_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_6_load_2", "role": "default" }} , 
 	{ "name": "state_7_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_7_load_2", "role": "default" }} , 
 	{ "name": "state_8_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_8_load_2", "role": "default" }} , 
 	{ "name": "state_9_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_9_load_2", "role": "default" }} , 
 	{ "name": "state_10_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_10_load_2", "role": "default" }} , 
 	{ "name": "state_11_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_11_load_2", "role": "default" }} , 
 	{ "name": "state_12_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_12_load_2", "role": "default" }} , 
 	{ "name": "state_13_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_13_load_2", "role": "default" }} , 
 	{ "name": "state_14_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_14_load_2", "role": "default" }} , 
 	{ "name": "state_15_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_15_load_2", "role": "default" }} , 
 	{ "name": "state_16_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_16_load_2", "role": "default" }} , 
 	{ "name": "state_17_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_17_load_2", "role": "default" }} , 
 	{ "name": "state_18_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_18_load_2", "role": "default" }} , 
 	{ "name": "state_19_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_19_load_2", "role": "default" }} , 
 	{ "name": "state_20_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_20_load_2", "role": "default" }} , 
 	{ "name": "state_21_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_21_load_2", "role": "default" }} , 
 	{ "name": "state_22_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_22_load_2", "role": "default" }} , 
 	{ "name": "state_23_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_23_load_2", "role": "default" }} , 
 	{ "name": "state_24_load_2", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "state_24_load_2", "role": "default" }} , 
 	{ "name": "output_stream_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "output_stream_V_data_V", "role": "default" }} , 
 	{ "name": "output_stream_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "output_stream_V_last_V", "role": "default" }} , 
 	{ "name": "output_stream_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "output_stream_V_keep_V", "role": "default" }} , 
 	{ "name": "output_stream_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "output_stream_V_strb_V", "role": "default" }} , 
 	{ "name": "output_stream_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "output_stream_V_last_V", "role": "default" }} , 
 	{ "name": "output_remaining_1_out", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "output_remaining_1_out", "role": "default" }} , 
 	{ "name": "output_remaining_1_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "output_remaining_1_out", "role": "ap_vld" }}  ]}

set ArgLastReadFirstWriteLatency {
	keccak_top_Pipeline_SQUEEZE_BLOCK {
		output_remaining {Type I LastRead 0 FirstWrite -1}
		trunc_ln6 {Type I LastRead 0 FirstWrite -1}
		state_load_2 {Type I LastRead 0 FirstWrite -1}
		state_1_load_2 {Type I LastRead 0 FirstWrite -1}
		state_2_load_2 {Type I LastRead 0 FirstWrite -1}
		state_3_load_2 {Type I LastRead 0 FirstWrite -1}
		state_4_load_2 {Type I LastRead 0 FirstWrite -1}
		state_5_load_2 {Type I LastRead 0 FirstWrite -1}
		state_6_load_2 {Type I LastRead 0 FirstWrite -1}
		state_7_load_2 {Type I LastRead 0 FirstWrite -1}
		state_8_load_2 {Type I LastRead 0 FirstWrite -1}
		state_9_load_2 {Type I LastRead 0 FirstWrite -1}
		state_10_load_2 {Type I LastRead 0 FirstWrite -1}
		state_11_load_2 {Type I LastRead 0 FirstWrite -1}
		state_12_load_2 {Type I LastRead 0 FirstWrite -1}
		state_13_load_2 {Type I LastRead 0 FirstWrite -1}
		state_14_load_2 {Type I LastRead 0 FirstWrite -1}
		state_15_load_2 {Type I LastRead 0 FirstWrite -1}
		state_16_load_2 {Type I LastRead 0 FirstWrite -1}
		state_17_load_2 {Type I LastRead 0 FirstWrite -1}
		state_18_load_2 {Type I LastRead 0 FirstWrite -1}
		state_19_load_2 {Type I LastRead 0 FirstWrite -1}
		state_20_load_2 {Type I LastRead 0 FirstWrite -1}
		state_21_load_2 {Type I LastRead 0 FirstWrite -1}
		state_22_load_2 {Type I LastRead 0 FirstWrite -1}
		state_23_load_2 {Type I LastRead 0 FirstWrite -1}
		state_24_load_2 {Type I LastRead 0 FirstWrite -1}
		output_stream_V_data_V {Type O LastRead -1 FirstWrite 2}
		output_stream_V_keep_V {Type O LastRead -1 FirstWrite 2}
		output_stream_V_strb_V {Type O LastRead -1 FirstWrite 2}
		output_stream_V_last_V {Type O LastRead -1 FirstWrite 2}
		output_remaining_1_out {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2", "Max" : "34"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "33"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	output_remaining { ap_none {  { output_remaining in_data 0 31 } } }
	trunc_ln6 { ap_none {  { trunc_ln6 in_data 0 6 } } }
	state_load_2 { ap_none {  { state_load_2 in_data 0 64 } } }
	state_1_load_2 { ap_none {  { state_1_load_2 in_data 0 64 } } }
	state_2_load_2 { ap_none {  { state_2_load_2 in_data 0 64 } } }
	state_3_load_2 { ap_none {  { state_3_load_2 in_data 0 64 } } }
	state_4_load_2 { ap_none {  { state_4_load_2 in_data 0 64 } } }
	state_5_load_2 { ap_none {  { state_5_load_2 in_data 0 64 } } }
	state_6_load_2 { ap_none {  { state_6_load_2 in_data 0 64 } } }
	state_7_load_2 { ap_none {  { state_7_load_2 in_data 0 64 } } }
	state_8_load_2 { ap_none {  { state_8_load_2 in_data 0 64 } } }
	state_9_load_2 { ap_none {  { state_9_load_2 in_data 0 64 } } }
	state_10_load_2 { ap_none {  { state_10_load_2 in_data 0 64 } } }
	state_11_load_2 { ap_none {  { state_11_load_2 in_data 0 64 } } }
	state_12_load_2 { ap_none {  { state_12_load_2 in_data 0 64 } } }
	state_13_load_2 { ap_none {  { state_13_load_2 in_data 0 64 } } }
	state_14_load_2 { ap_none {  { state_14_load_2 in_data 0 64 } } }
	state_15_load_2 { ap_none {  { state_15_load_2 in_data 0 64 } } }
	state_16_load_2 { ap_none {  { state_16_load_2 in_data 0 64 } } }
	state_17_load_2 { ap_none {  { state_17_load_2 in_data 0 64 } } }
	state_18_load_2 { ap_none {  { state_18_load_2 in_data 0 64 } } }
	state_19_load_2 { ap_none {  { state_19_load_2 in_data 0 64 } } }
	state_20_load_2 { ap_none {  { state_20_load_2 in_data 0 64 } } }
	state_21_load_2 { ap_none {  { state_21_load_2 in_data 0 64 } } }
	state_22_load_2 { ap_none {  { state_22_load_2 in_data 0 64 } } }
	state_23_load_2 { ap_none {  { state_23_load_2 in_data 0 64 } } }
	state_24_load_2 { ap_none {  { state_24_load_2 in_data 0 64 } } }
	output_stream_V_data_V { axis {  { output_stream_TREADY out_acc 0 1 }  { output_stream_TDATA out_data 1 64 } } }
	output_stream_V_keep_V { axis {  { output_stream_TKEEP out_data 1 8 } } }
	output_stream_V_strb_V { axis {  { output_stream_TSTRB out_data 1 8 } } }
	output_stream_V_last_V { axis {  { output_stream_TVALID out_vld 1 1 }  { output_stream_TLAST out_data 1 1 } } }
	output_remaining_1_out { ap_vld {  { output_remaining_1_out out_data 1 32 }  { output_remaining_1_out_ap_vld out_vld 1 1 } } }
}
