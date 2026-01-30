// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xkeccak_top.h"

extern XKeccak_top_Config XKeccak_top_ConfigTable[];

#ifdef SDT
XKeccak_top_Config *XKeccak_top_LookupConfig(UINTPTR BaseAddress) {
	XKeccak_top_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XKeccak_top_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XKeccak_top_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XKeccak_top_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XKeccak_top_Initialize(XKeccak_top *InstancePtr, UINTPTR BaseAddress) {
	XKeccak_top_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XKeccak_top_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XKeccak_top_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XKeccak_top_Config *XKeccak_top_LookupConfig(u16 DeviceId) {
	XKeccak_top_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XKECCAK_TOP_NUM_INSTANCES; Index++) {
		if (XKeccak_top_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XKeccak_top_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XKeccak_top_Initialize(XKeccak_top *InstancePtr, u16 DeviceId) {
	XKeccak_top_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XKeccak_top_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XKeccak_top_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif
