// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.2 (64-bit)
// Tool Version Limit: 2025.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XKECCAK_TOP_H
#define XKECCAK_TOP_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xkeccak_top_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
} XKeccak_top_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XKeccak_top;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XKeccak_top_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XKeccak_top_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XKeccak_top_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XKeccak_top_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XKeccak_top_Initialize(XKeccak_top *InstancePtr, UINTPTR BaseAddress);
XKeccak_top_Config* XKeccak_top_LookupConfig(UINTPTR BaseAddress);
#else
int XKeccak_top_Initialize(XKeccak_top *InstancePtr, u16 DeviceId);
XKeccak_top_Config* XKeccak_top_LookupConfig(u16 DeviceId);
#endif
int XKeccak_top_CfgInitialize(XKeccak_top *InstancePtr, XKeccak_top_Config *ConfigPtr);
#else
int XKeccak_top_Initialize(XKeccak_top *InstancePtr, const char* InstanceName);
int XKeccak_top_Release(XKeccak_top *InstancePtr);
#endif

void XKeccak_top_Start(XKeccak_top *InstancePtr);
u32 XKeccak_top_IsDone(XKeccak_top *InstancePtr);
u32 XKeccak_top_IsIdle(XKeccak_top *InstancePtr);
u32 XKeccak_top_IsReady(XKeccak_top *InstancePtr);
void XKeccak_top_EnableAutoRestart(XKeccak_top *InstancePtr);
void XKeccak_top_DisableAutoRestart(XKeccak_top *InstancePtr);

void XKeccak_top_Set_rate_bytes(XKeccak_top *InstancePtr, u32 Data);
u32 XKeccak_top_Get_rate_bytes(XKeccak_top *InstancePtr);
void XKeccak_top_Set_delimiter(XKeccak_top *InstancePtr, u32 Data);
u32 XKeccak_top_Get_delimiter(XKeccak_top *InstancePtr);
void XKeccak_top_Set_output_len(XKeccak_top *InstancePtr, u32 Data);
u32 XKeccak_top_Get_output_len(XKeccak_top *InstancePtr);

void XKeccak_top_InterruptGlobalEnable(XKeccak_top *InstancePtr);
void XKeccak_top_InterruptGlobalDisable(XKeccak_top *InstancePtr);
void XKeccak_top_InterruptEnable(XKeccak_top *InstancePtr, u32 Mask);
void XKeccak_top_InterruptDisable(XKeccak_top *InstancePtr, u32 Mask);
void XKeccak_top_InterruptClear(XKeccak_top *InstancePtr, u32 Mask);
u32 XKeccak_top_InterruptGetEnabled(XKeccak_top *InstancePtr);
u32 XKeccak_top_InterruptGetStatus(XKeccak_top *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
