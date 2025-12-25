set ModuleHierarchy {[{
"Name" : "keccak_top", "RefName" : "keccak_top","ID" : "0","Type" : "sequential",
"SubLoops" : [
	{"Name" : "ABSORB_LOOP","RefName" : "ABSORB_LOOP","ID" : "1","Type" : "no",
	"SubInsts" : [
	{"Name" : "grp_keccak_f1600_fu_4047", "RefName" : "keccak_f1600","ID" : "2","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "KECCAK_ROUNDS_LOOP","RefName" : "KECCAK_ROUNDS_LOOP","ID" : "3","Type" : "pipeline"},]},]},
	{"Name" : "SQUEEZE_LOOP","RefName" : "SQUEEZE_LOOP","ID" : "4","Type" : "no",
	"SubInsts" : [
	{"Name" : "grp_keccak_top_Pipeline_SQUEEZE_BLOCK_fu_4103", "RefName" : "keccak_top_Pipeline_SQUEEZE_BLOCK","ID" : "5","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "SQUEEZE_BLOCK","RefName" : "SQUEEZE_BLOCK","ID" : "6","Type" : "pipeline"},]},]},]
}]}