set SynModuleInfo {
  {SRCNAME keccak_f1600 MODELNAME keccak_f1600 RTLNAME keccak_top_keccak_f1600
    SUBMODULES {
      {MODELNAME keccak_top_keccak_f1600_RC_TABLE_ROM_AUTO_1R RTLNAME keccak_top_keccak_f1600_RC_TABLE_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME keccak_top_flow_control_loop_pipe_sequential_init RTLNAME keccak_top_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME keccak_top_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME keccak_top_Pipeline_SQUEEZE_BLOCK MODELNAME keccak_top_Pipeline_SQUEEZE_BLOCK RTLNAME keccak_top_keccak_top_Pipeline_SQUEEZE_BLOCK
    SUBMODULES {
      {MODELNAME keccak_top_sparsemux_51_5_64_1_1 RTLNAME keccak_top_sparsemux_51_5_64_1_1 BINDTYPE op TYPE sparsemux IMPL compactencoding_dontcare}
    }
  }
  {SRCNAME keccak_top MODELNAME keccak_top RTLNAME keccak_top IS_TOP 1
    SUBMODULES {
      {MODELNAME keccak_top_control_s_axi RTLNAME keccak_top_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
      {MODELNAME keccak_top_regslice_both RTLNAME keccak_top_regslice_both BINDTYPE interface TYPE adapter IMPL reg_slice}
    }
  }
}
