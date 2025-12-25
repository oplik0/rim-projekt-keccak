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
    id 56 \
    name output_stream_V_data_V \
    reset_level 1 \
    sync_rst true \
    corename {output_stream} \
    metadata {  } \
    op interface \
    ports { output_stream_TREADY { I 1 bit } output_stream_TDATA { O 64 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'output_stream_V_data_V'"
}
}


# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 57 \
    name output_stream_V_keep_V \
    reset_level 1 \
    sync_rst true \
    corename {output_stream} \
    metadata {  } \
    op interface \
    ports { output_stream_TKEEP { O 8 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'output_stream_V_keep_V'"
}
}


# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 58 \
    name output_stream_V_strb_V \
    reset_level 1 \
    sync_rst true \
    corename {output_stream} \
    metadata {  } \
    op interface \
    ports { output_stream_TSTRB { O 8 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'output_stream_V_strb_V'"
}
}


# Native AXIS:
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc ::AESL_LIB_XILADAPTER::native_axis_add] == "::AESL_LIB_XILADAPTER::native_axis_add"} {
eval "::AESL_LIB_XILADAPTER::native_axis_add { \
    id 59 \
    name output_stream_V_last_V \
    reset_level 1 \
    sync_rst true \
    corename {output_stream} \
    metadata {  } \
    op interface \
    ports { output_stream_TVALID { O 1 bit } output_stream_TLAST { O 1 vector } } \
} "
} else {
puts "@W \[IMPL-110\] Cannot find bus interface model in the library. Ignored generation of bus interface for 'output_stream_V_last_V'"
}
}


# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 29 \
    name output_remaining \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_output_remaining \
    op interface \
    ports { output_remaining { I 31 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 30 \
    name trunc_ln4 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_trunc_ln4 \
    op interface \
    ports { trunc_ln4 { I 6 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 31 \
    name state_5217 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_5217 \
    op interface \
    ports { state_5217 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 32 \
    name state_1_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_1_5 \
    op interface \
    ports { state_1_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 33 \
    name state_2_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_2_5 \
    op interface \
    ports { state_2_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 34 \
    name state_3_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_3_5 \
    op interface \
    ports { state_3_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 35 \
    name state_4_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_4_5 \
    op interface \
    ports { state_4_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 36 \
    name state_5_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_5_5 \
    op interface \
    ports { state_5_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 37 \
    name state_6_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_6_5 \
    op interface \
    ports { state_6_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 38 \
    name state_7_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_7_5 \
    op interface \
    ports { state_7_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 39 \
    name state_8_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_8_5 \
    op interface \
    ports { state_8_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 40 \
    name state_9_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_9_5 \
    op interface \
    ports { state_9_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 41 \
    name state_10_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_10_5 \
    op interface \
    ports { state_10_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 42 \
    name state_11_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_11_5 \
    op interface \
    ports { state_11_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 43 \
    name state_12_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_12_5 \
    op interface \
    ports { state_12_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 44 \
    name state_13_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_13_5 \
    op interface \
    ports { state_13_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 45 \
    name state_14_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_14_5 \
    op interface \
    ports { state_14_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 46 \
    name state_15_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_15_5 \
    op interface \
    ports { state_15_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 47 \
    name state_16_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_16_5 \
    op interface \
    ports { state_16_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 48 \
    name state_17_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_17_5 \
    op interface \
    ports { state_17_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 49 \
    name state_18_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_18_5 \
    op interface \
    ports { state_18_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 50 \
    name state_19_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_19_5 \
    op interface \
    ports { state_19_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 51 \
    name state_20_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_20_5 \
    op interface \
    ports { state_20_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 52 \
    name state_21_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_21_5 \
    op interface \
    ports { state_21_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 53 \
    name state_22_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_22_5 \
    op interface \
    ports { state_22_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 54 \
    name state_23_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_23_5 \
    op interface \
    ports { state_23_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 55 \
    name state_24_5 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_state_24_5 \
    op interface \
    ports { state_24_5 { I 64 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 60 \
    name output_remaining_1_out \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_output_remaining_1_out \
    op interface \
    ports { output_remaining_1_out { O 32 vector } output_remaining_1_out_ap_vld { O 1 bit } } \
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


