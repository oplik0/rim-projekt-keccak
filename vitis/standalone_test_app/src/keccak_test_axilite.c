
#include <stdio.h>
#include <string.h>
#include "xil_printf.h"
#include "xil_io.h"
#include "xil_types.h"
#include "xstatus.h"
#include "xparameters.h"
#include "sleep.h"

#define KECCAK_BASEADDR         XPAR_KECCAK_CORE_0_BASEADDR

/* Register offsets */
#define REG_AP_CTRL             0x00
#define REG_GIE                 0x04
#define REG_IER                 0x08
#define REG_ISR                 0x0C
#define REG_RATE_BYTES          0x10
#define REG_DELIMITER           0x18
#define REG_OUTPUT_LEN          0x20
#define REG_INPUT_LEN           0x28
#define REG_DATA_IN_LO          0x30
#define REG_DATA_IN_HI          0x34
#define REG_DATA_OUT_LO         0x38
#define REG_DATA_OUT_HI         0x3C
#define REG_STATUS              0x40

/* AP_CTRL bits */
#define AP_CTRL_START           (1U << 0)
#define AP_CTRL_DONE            (1U << 1)
#define AP_CTRL_IDLE            (1U << 2)
#define AP_CTRL_READY           (1U << 3)

/* Status bits */
#define STATUS_INPUT_READY      (1U << 0)
#define STATUS_OUTPUT_VALID     (1U << 1)

//* SHA-3 Configuration

#define RATE_SHA3_256           136U
#define DELIM_SHA3              0x06U

#define IDLE_TIMEOUT_US         100000U
#define DATA_TIMEOUT_US         1000000U

/* SHA3-256("abc") */
static const u8 SHA3_256_ABC[32] = {
    0x3a, 0x98, 0x5d, 0xa7, 0x4f, 0xe2, 0x25, 0xb2,
    0x04, 0x5c, 0x17, 0x2d, 0x6b, 0xd3, 0x90, 0xbd,
    0x85, 0x5f, 0x08, 0x6e, 0x3e, 0x9d, 0x52, 0x5b,
    0x46, 0xbf, 0xe2, 0x45, 0x11, 0x43, 0x15, 0x32
};

/* SHA3-256("") - empty message */
static const u8 SHA3_256_EMPTY[32] = {
    0xa7, 0xff, 0xc6, 0xf8, 0xbf, 0x1e, 0xd7, 0x66,
    0x51, 0xc1, 0x47, 0x56, 0xa0, 0x61, 0xd6, 0x62,
    0xf5, 0x80, 0xff, 0x4d, 0xe4, 0x3b, 0x49, 0xfa,
    0x82, 0xd8, 0x0a, 0x4b, 0x80, 0xf8, 0x43, 0x4a
};

static inline void WriteReg(u32 Offset, u32 Value)
{
    Xil_Out32(KECCAK_BASEADDR + Offset, Value);
}

static inline u32 ReadReg(u32 Offset)
{
    return Xil_In32(KECCAK_BASEADDR + Offset);
}

static void Keccak_Configure(u8 RateBytes, u8 Delimiter, u16 OutputLen, u16 InputLen)
{
    WriteReg(REG_RATE_BYTES, RateBytes);
    WriteReg(REG_DELIMITER, Delimiter);
    WriteReg(REG_OUTPUT_LEN, OutputLen);
    WriteReg(REG_INPUT_LEN, InputLen);
}

static void Keccak_Start(void)
{
    WriteReg(REG_AP_CTRL, AP_CTRL_START);
}

static int Keccak_IsIdle(void)
{
    return (ReadReg(REG_AP_CTRL) & AP_CTRL_IDLE) != 0;
}

static int Keccak_IsDone(void)
{
    return (ReadReg(REG_AP_CTRL) & AP_CTRL_DONE) != 0;
}

static int Keccak_IsInputReady(void)
{
    return (ReadReg(REG_STATUS) & STATUS_INPUT_READY) != 0;
}

static int Keccak_IsOutputValid(void)
{
    return (ReadReg(REG_STATUS) & STATUS_OUTPUT_VALID) != 0;
}

static int WaitForIdle(u32 TimeoutUs)
{
    for (u32 i = 0; i < TimeoutUs; i++) {
        if (Keccak_IsIdle()) {
            return XST_SUCCESS;
        }
        usleep(1);
    }
    xil_printf("ERROR: Timeout waiting for IDLE\r\n");
    return XST_FAILURE;
}

static int WaitForInputReady(u32 TimeoutUs)
{
    for (u32 i = 0; i < TimeoutUs; i++) {
        if (Keccak_IsInputReady()) {
            return XST_SUCCESS;
        }
        usleep(1);
    }
    xil_printf("ERROR: Timeout waiting for INPUT_READY\r\n");
    return XST_FAILURE;
}

static int WaitForOutputValid(u32 TimeoutUs)
{
    for (u32 i = 0; i < TimeoutUs; i++) {
        if (Keccak_IsOutputValid()) {
            return XST_SUCCESS;
        }
        usleep(1);
    }
    xil_printf("ERROR: Timeout waiting for OUTPUT_VALID\r\n");
    return XST_FAILURE;
}

static int WaitForDone(u32 TimeoutUs)
{
    for (u32 i = 0; i < TimeoutUs; i++) {
        if (Keccak_IsDone()) {
            return XST_SUCCESS;
        }
        usleep(1);
    }
    xil_printf("ERROR: Timeout waiting for DONE\r\n");
    return XST_FAILURE;
}

static void WriteInputWord(u64 Data)
{
    WriteReg(REG_DATA_IN_LO, (u32)(Data & 0xFFFFFFFFULL));
    WriteReg(REG_DATA_IN_HI, (u32)((Data >> 32) & 0xFFFFFFFFULL));
}

static u64 ReadOutputWord(void)
{
    u32 Lo = ReadReg(REG_DATA_OUT_LO);
    u32 Hi = ReadReg(REG_DATA_OUT_HI);  /* This triggers next word */
    return ((u64)Hi << 32) | Lo;
}

static int SendMessage(const u8 *Message, u32 MsgLen)
{
    u32 WordsNeeded = (MsgLen + 7) / 8;
    u32 ByteIdx = 0;
    
    xil_printf("SendMessage: %u bytes (%u words)\r\n", MsgLen, WordsNeeded);
    
    for (u32 w = 0; w < WordsNeeded; w++) {
        /* Wait for input ready */
        if (WaitForInputReady(DATA_TIMEOUT_US) != XST_SUCCESS) {
            return XST_FAILURE;
        }
        
        /* Pack bytes into 64-bit word (little-endian) */
        u64 Word64 = 0;
        u32 BytesInWord = (MsgLen - ByteIdx >= 8) ? 8 : (MsgLen - ByteIdx);
        
        for (u32 b = 0; b < BytesInWord; b++) {
            Word64 |= ((u64)Message[ByteIdx++]) << (b * 8);
        }
        
        /* Write to core */
        WriteInputWord(Word64);
        xil_printf("  Wrote word %u: 0x%08X%08X\r\n", w,
                   (u32)(Word64 >> 32), (u32)(Word64 & 0xFFFFFFFF));
    }
    
    return XST_SUCCESS;
}

static int ReadHashOutput(u8 *Output, u32 OutputLen)
{
    u32 WordsNeeded = (OutputLen + 7) / 8;
    u32 ByteIdx = 0;
    
    xil_printf("ReadHashOutput: %u bytes (%u words)\r\n", OutputLen, WordsNeeded);
    
    for (u32 w = 0; w < WordsNeeded; w++) {
        /* Wait for output valid */
        if (WaitForOutputValid(DATA_TIMEOUT_US) != XST_SUCCESS) {
            return ByteIdx;  /* Return partial read count */
        }
        
        /* Read 64-bit word */
        u64 Word64 = ReadOutputWord();
        xil_printf("  Read word %u: 0x%08X%08X\r\n", w,
                   (u32)(Word64 >> 32), (u32)(Word64 & 0xFFFFFFFF));
        
        /* Unpack bytes (little-endian) */
        for (u32 b = 0; b < 8 && ByteIdx < OutputLen; b++) {
            Output[ByteIdx++] = (u8)((Word64 >> (b * 8)) & 0xFF);
        }
    }
    
    return (int)ByteIdx;
}

static void PrintHex(const char *Label, const u8 *Data, u32 Len)
{
    xil_printf("%s: ", Label);
    for (u32 i = 0; i < Len; i++) {
        xil_printf("%02x", Data[i]);
    }
    xil_printf("\r\n");
}

static int CompareBytes(const u8 *A, const u8 *B, u32 Len)
{
    for (u32 i = 0; i < Len; i++) {
        if (A[i] != B[i]) {
            return FALSE;
        }
    }
    return TRUE;
}

static void PrintStatus(void)
{
    u32 ApCtrl = ReadReg(REG_AP_CTRL);
    u32 Status = ReadReg(REG_STATUS);
    
    xil_printf("\r\n=== Hardware Status ===\r\n");
    xil_printf("AP_CTRL: 0x%08x (START=%u DONE=%u IDLE=%u READY=%u)\r\n",
               ApCtrl,
               (ApCtrl >> 0) & 1, (ApCtrl >> 1) & 1,
               (ApCtrl >> 2) & 1, (ApCtrl >> 3) & 1);
    xil_printf("STATUS:  0x%08x (INPUT_READY=%u OUTPUT_VALID=%u)\r\n",
               Status,
               (Status >> 0) & 1, (Status >> 1) & 1);
}

/**
 * Test SHA3-256 with empty message
 */
static int TestSha3_256_Empty(void)
{
    u8 HashOutput[32];
    int Status;
    
    xil_printf("\r\n=== Test: SHA3-256 (empty message) ===\r\n");
    
    /* Wait for idle */
    Status = WaitForIdle(IDLE_TIMEOUT_US);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }
    
    /* Configure for SHA3-256 with 0 input bytes */
    Keccak_Configure(RATE_SHA3_256, DELIM_SHA3, 32, 0);
    xil_printf("Configured: rate=%u, delim=0x%02x, outlen=%u, inlen=%u\r\n",
               RATE_SHA3_256, DELIM_SHA3, 32, 0);
    
    /* Start the core */
    Keccak_Start();
    xil_printf("Core started\r\n");
    
    int BytesRead = ReadHashOutput(HashOutput, 32);
    if (BytesRead != 32) {
        xil_printf("FAILED: Expected 32 bytes, got %d\r\n", BytesRead);
        return XST_FAILURE;
    }
    
    /* Verify */
    PrintHex("Expected", SHA3_256_EMPTY, 32);
    PrintHex("Got     ", HashOutput, 32);
    
    if (CompareBytes(HashOutput, SHA3_256_EMPTY, 32)) {
        xil_printf("PASSED\r\n");
        return XST_SUCCESS;
    } else {
        xil_printf("FAILED: Hash mismatch\r\n");
        return XST_FAILURE;
    }
}

static int TestSha3_256_Abc(void)
{
    const u8 Message[] = {'a', 'g', 'c', 'i'};
    u8 HashOutput[32];
    int Status;
    
    xil_printf("\r\n=== Test: SHA3-256 (\"abc\") ===\r\n");
    
    /* Wait for idle */
    Status = WaitForIdle(IDLE_TIMEOUT_US);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }
    
    /* Configure for SHA3-256 */
    Keccak_Configure(RATE_SHA3_256, DELIM_SHA3, 32, sizeof(Message));
    xil_printf("Configured: rate=%u, delim=0x%02x, outlen=%u, inlen=%u\r\n",
               RATE_SHA3_256, DELIM_SHA3, 32, (u32)sizeof(Message));
    
    /* Start the core */
    Keccak_Start();
    xil_printf("Core started\r\n");
    
    /* Send message */
    Status = SendMessage(Message, sizeof(Message));
    if (Status != XST_SUCCESS) {
        xil_printf("FAILED: SendMessage error\r\n");
        return XST_FAILURE;
    }
    
    /* Read output */
    int BytesRead = ReadHashOutput(HashOutput, 32);
    if (BytesRead != 32) {
        xil_printf("FAILED: Expected 32 bytes, got %d\r\n", BytesRead);
        return XST_FAILURE;
    }
    
    /* Wait for done */
    Status = WaitForDone(DATA_TIMEOUT_US);
    if (Status != XST_SUCCESS) {
        xil_printf("WARNING: Core did not signal DONE\r\n");
    }
    
    /* Verify */
    PrintHex("Expected", SHA3_256_ABC, 32);
    PrintHex("Got     ", HashOutput, 32);
    
    if (CompareBytes(HashOutput, SHA3_256_ABC, 32)) {
        xil_printf("PASSED\r\n");
        return XST_SUCCESS;
    } else {
        xil_printf("FAILED: Hash mismatch\r\n");
        return XST_FAILURE;
    }
}

static int TestSha3_256_Long(void)
{
    const u8 Message[] = "The quick brown fox jumps over the lazy dog";
    const u32 MsgLen = sizeof(Message) - 1;  /* Exclude null */
    
    /* Expected: 69070dda01975c8c120c3aada1b282394e7f032fa9cf32f4cb2259a0897dfc04 */
    static const u8 Expected[32] = {
        0x69, 0x07, 0x0d, 0xda, 0x01, 0x97, 0x5c, 0x8c,
        0x12, 0x0c, 0x3a, 0xad, 0xa1, 0xb2, 0x82, 0x39,
        0x4e, 0x7f, 0x03, 0x2f, 0xa9, 0xcf, 0x32, 0xf4,
        0xcb, 0x22, 0x59, 0xa0, 0x89, 0x7d, 0xfc, 0x04
    };
    
    u8 HashOutput[32];
    int Status;
    
    xil_printf("\r\n=== Test: SHA3-256 (long message) ===\r\n");
    xil_printf("Message: \"%s\" (%u bytes)\r\n", Message, MsgLen);
    
    /* Wait for idle */
    Status = WaitForIdle(IDLE_TIMEOUT_US);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }
    
    /* Configure for SHA3-256 */
    Keccak_Configure(RATE_SHA3_256, DELIM_SHA3, 32, MsgLen);
    
    /* Start the core */
    Keccak_Start();
    
    /* Send message */
    Status = SendMessage(Message, MsgLen);
    if (Status != XST_SUCCESS) {
        xil_printf("FAILED: SendMessage error\r\n");
        return XST_FAILURE;
    }
    
    /* Read output */
    int BytesRead = ReadHashOutput(HashOutput, 32);
    if (BytesRead != 32) {
        xil_printf("FAILED: Expected 32 bytes, got %d\r\n", BytesRead);
        return XST_FAILURE;
    }
    
    /* Verify */
    PrintHex("Expected", Expected, 32);
    PrintHex("Got     ", HashOutput, 32);
    
    if (CompareBytes(HashOutput, Expected, 32)) {
        xil_printf("PASSED\r\n");
        return XST_SUCCESS;
    } else {
        xil_printf("FAILED: Hash mismatch\r\n");
        return XST_FAILURE;
    }
}

int main(void)
{
    int Status;
    int TestsPassed = 0;
    int TestsFailed = 0;
    
    
    /* Check initial status */
    PrintStatus();

    /* Test 1: SHA3-256 empty */
    Status = TestSha3_256_Empty();
    if (Status == XST_SUCCESS) TestsPassed++; else TestsFailed++;
    
    /* Test 2: SHA3-256 "abc" */
    Status = TestSha3_256_Abc();
    if (Status == XST_SUCCESS) TestsPassed++; else TestsFailed++;
    
    /* Test 3: SHA3-256 long message */
    Status = TestSha3_256_Long();
    if (Status == XST_SUCCESS) TestsPassed++; else TestsFailed++;
    
    xil_printf("\r\n========================================\r\n");
    xil_printf("  Test Summary\r\n");
    xil_printf("========================================\r\n");
    xil_printf("Passed: %d\r\n", TestsPassed);
    xil_printf("Failed: %d\r\n", TestsFailed);
    xil_printf("\r\n");
    
    if (TestsFailed == 0) {
        xil_printf("All tests PASSED!\r\n");
    } else {
        xil_printf("Some tests FAILED.\r\n");
    }
    
    PrintStatus();
    
    xil_printf("\r\nTest application complete.\r\n");
    
    return (TestsFailed == 0) ? XST_SUCCESS : XST_FAILURE;
}
