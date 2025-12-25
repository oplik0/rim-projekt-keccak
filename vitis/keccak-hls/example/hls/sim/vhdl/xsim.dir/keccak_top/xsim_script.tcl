set_param project.enableReportConfiguration 0
load_feature core
current_fileset
xsim {keccak_top} -testplusarg UVM_VERBOSITY=UVM_NONE -testplusarg UVM_TESTNAME=keccak_top_test_lib -testplusarg UVM_TIMEOUT=20000000000000 -view {{keccak_top_dataflow_ana.wcfg}} -tclbatch {keccak_top.tcl} -protoinst {keccak_top.protoinst}
