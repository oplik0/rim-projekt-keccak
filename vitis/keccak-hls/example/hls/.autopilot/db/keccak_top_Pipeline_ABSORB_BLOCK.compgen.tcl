# This script segment is generated automatically by AutoPilot

if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler keccak_top_sparsemux_51_5_64_1_1 BINDTYPE {op} TYPE {sparsemux} IMPL {compactencoding_dontcare}
}


# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 30 \
    name input_stream_V_data_V \
    reset_level 1 \
    sync_rst true \
    corename {input_stream} \
    metadata {  } \
    op interface \
    ports { input_stream_TVALID { I 1 bit } input_stream_TDATA { I 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'input_stream_V_data_V'"
}
}


# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 31 \
    name input_stream_V_keep_V \
    reset_level 1 \
    sync_rst true \
    corename {input_stream} \
    metadata {  } \
    op interface \
    ports { input_stream_TKEEP { I 8 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'input_stream_V_keep_V'"
}
}


# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 32 \
    name input_stream_V_strb_V \
    reset_level 1 \
    sync_rst true \
    corename {input_stream} \
    metadata {  } \
    op interface \
    ports { input_stream_TSTRB { I 8 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'input_stream_V_strb_V'"
}
}


# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 33 \
    name input_stream_V_last_V \
    reset_level 1 \
    sync_rst true \
    corename {input_stream} \
    metadata {  } \
    op interface \
    ports { input_stream_TREADY { O 1 bit } input_stream_TLAST { I 1 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'input_stream_V_last_V'"
}
}


# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 3 \
    name message_done \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_message_done \
    op interface \
    ports { message_done { I 1 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 4 \
    name trunc_ln1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_trunc_ln1 \
    op interface \
    ports { trunc_ln1 { I 6 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 5 \
    name state_24 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_24 \
    op interface \
    ports { state_24_i { I 64 vector } state_24_o { O 64 vector } state_24_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 6 \
    name state_23 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_23 \
    op interface \
    ports { state_23_i { I 64 vector } state_23_o { O 64 vector } state_23_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 7 \
    name state_22 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_22 \
    op interface \
    ports { state_22_i { I 64 vector } state_22_o { O 64 vector } state_22_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 8 \
    name state_21 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_21 \
    op interface \
    ports { state_21_i { I 64 vector } state_21_o { O 64 vector } state_21_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 9 \
    name state_20 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_20 \
    op interface \
    ports { state_20_i { I 64 vector } state_20_o { O 64 vector } state_20_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 10 \
    name state_19 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_19 \
    op interface \
    ports { state_19_i { I 64 vector } state_19_o { O 64 vector } state_19_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 11 \
    name state_18 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_18 \
    op interface \
    ports { state_18_i { I 64 vector } state_18_o { O 64 vector } state_18_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 12 \
    name state_17 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_17 \
    op interface \
    ports { state_17_i { I 64 vector } state_17_o { O 64 vector } state_17_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 13 \
    name state_16 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_16 \
    op interface \
    ports { state_16_i { I 64 vector } state_16_o { O 64 vector } state_16_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 14 \
    name state_15 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_15 \
    op interface \
    ports { state_15_i { I 64 vector } state_15_o { O 64 vector } state_15_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 15 \
    name state_14 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_14 \
    op interface \
    ports { state_14_i { I 64 vector } state_14_o { O 64 vector } state_14_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 16 \
    name state_13 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_13 \
    op interface \
    ports { state_13_i { I 64 vector } state_13_o { O 64 vector } state_13_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 17 \
    name state_12 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_12 \
    op interface \
    ports { state_12_i { I 64 vector } state_12_o { O 64 vector } state_12_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 18 \
    name state_11 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_11 \
    op interface \
    ports { state_11_i { I 64 vector } state_11_o { O 64 vector } state_11_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 19 \
    name state_10 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_10 \
    op interface \
    ports { state_10_i { I 64 vector } state_10_o { O 64 vector } state_10_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 20 \
    name state_9 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_9 \
    op interface \
    ports { state_9_i { I 64 vector } state_9_o { O 64 vector } state_9_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 21 \
    name state_8 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_8 \
    op interface \
    ports { state_8_i { I 64 vector } state_8_o { O 64 vector } state_8_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 22 \
    name state_7 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_7 \
    op interface \
    ports { state_7_i { I 64 vector } state_7_o { O 64 vector } state_7_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 23 \
    name state_6 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_6 \
    op interface \
    ports { state_6_i { I 64 vector } state_6_o { O 64 vector } state_6_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 24 \
    name state_5 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_5 \
    op interface \
    ports { state_5_i { I 64 vector } state_5_o { O 64 vector } state_5_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 25 \
    name state_4 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_4 \
    op interface \
    ports { state_4_i { I 64 vector } state_4_o { O 64 vector } state_4_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 26 \
    name state_3 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_3 \
    op interface \
    ports { state_3_i { I 64 vector } state_3_o { O 64 vector } state_3_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 27 \
    name state_2 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_2 \
    op interface \
    ports { state_2_i { I 64 vector } state_2_o { O 64 vector } state_2_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 28 \
    name state_1 \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state_1 \
    op interface \
    ports { state_1_i { I 64 vector } state_1_o { O 64 vector } state_1_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 29 \
    name state \
    type other \
    dir IO \
    reset_level 1 \
    sync_rst true \
    corename dc_state \
    op interface \
    ports { state_i { I 64 vector } state_o { O 64 vector } state_o_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 34 \
    name message_done_1_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_message_done_1_out \
    op interface \
    ports { message_done_1_out { O 1 vector } message_done_1_out_ap_vld { O 1 bit } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -1 \
    name ap_ctrl \
    type ap_ctrl \
    reset_level 1 \
    sync_rst true \
    corename ap_ctrl \
    op interface \
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -2 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -3 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_rst \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


# flow_control definition:
set InstName keccak_top_flow_control_loop_pipe_sequential_init_U
set CompName keccak_top_flow_control_loop_pipe_sequential_init
set name flow_control_loop_pipe_sequential_init
if {${::AESL::PGuard_autocg_gen} && ${::AESL::PGuard_autocg_ipmgen}} {
if {[info proc ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control] == "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control"} {
eval "::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control { \
    name ${name} \
    prefix keccak_top_ \
}"
} else {
puts "@W \[IMPL-107\] Cannot find ::AESL_LIB_VIRTEX::xil_gen_UPC_flow_control, check your platform lib"
}
}


if {${::AESL::PGuard_rtl_comp_handler}} {
	::AP::rtl_comp_handler $CompName BINDTYPE interface TYPE internal_upc_flow_control INSTNAME $InstName
}


