// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xkeccak_top.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XKeccak_top_CfgInitialize(XKeccak_top *InstancePtr, XKeccak_top_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XKeccak_top_Start(XKeccak_top *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_AP_CTRL) & 0x80;
    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XKeccak_top_IsDone(XKeccak_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XKeccak_top_IsIdle(XKeccak_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XKeccak_top_IsReady(XKeccak_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XKeccak_top_EnableAutoRestart(XKeccak_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XKeccak_top_DisableAutoRestart(XKeccak_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_AP_CTRL, 0);
}

void XKeccak_top_Set_rate_bytes(XKeccak_top *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_RATE_BYTES_DATA, Data);
}

u32 XKeccak_top_Get_rate_bytes(XKeccak_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_RATE_BYTES_DATA);
    return Data;
}

void XKeccak_top_Set_delimiter(XKeccak_top *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_DELIMITER_DATA, Data);
}

u32 XKeccak_top_Get_delimiter(XKeccak_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_DELIMITER_DATA);
    return Data;
}

void XKeccak_top_Set_output_len(XKeccak_top *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_OUTPUT_LEN_DATA, Data);
}

u32 XKeccak_top_Get_output_len(XKeccak_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_OUTPUT_LEN_DATA);
    return Data;
}

void XKeccak_top_Set_input_len(XKeccak_top *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_INPUT_LEN_DATA, Data);
}

u32 XKeccak_top_Get_input_len(XKeccak_top *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_INPUT_LEN_DATA);
    return Data;
}

void XKeccak_top_InterruptGlobalEnable(XKeccak_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_GIE, 1);
}

void XKeccak_top_InterruptGlobalDisable(XKeccak_top *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_GIE, 0);
}

void XKeccak_top_InterruptEnable(XKeccak_top *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_IER);
    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_IER, Register | Mask);
}

void XKeccak_top_InterruptDisable(XKeccak_top *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_IER);
    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_IER, Register & (~Mask));
}

void XKeccak_top_InterruptClear(XKeccak_top *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XKeccak_top_WriteReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_ISR, Mask);
}

u32 XKeccak_top_InterruptGetEnabled(XKeccak_top *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_IER);
}

u32 XKeccak_top_InterruptGetStatus(XKeccak_top *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XKeccak_top_ReadReg(InstancePtr->Control_BaseAddress, XKECCAK_TOP_CONTROL_ADDR_ISR);
}

