/**
 * @file keccak_bandwidth_test.c
 * @brief Hardware Keccak/SHA-3 Bandwidth Benchmark
 *
 * Measures FPGA accelerator performance for comparison with software benchmarks.
 * Uses ARM Global Timer for cycle-accurate measurements.
 *
 * Test cases match software/keccak-rs/benches/keccak_bench.rs:
 * - SHA3-256: 64, 136, 1024, 4096, 16384 bytes
 *
 * Metrics:
 * - Throughput: MiB/s
 * - Efficiency: cycles/byte
 * - Latency: us per hash
 *
 * @author FPGA Accelerator Team
 * @date 2025
 */

#include <stdio.h>
#include <string.h>
#include "xil_printf.h"
#include "xil_io.h"
#include "xil_types.h"
#include "xstatus.h"
#include "xparameters.h"
#include "sleep.h"
#include "xiltimer.h"  

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

/* SHA-3 Configuration */
#define RATE_SHA3_256           136U
#define DELIM_SHA3              0x06U

#define IDLE_TIMEOUT_US         100000U
#define DATA_TIMEOUT_US         1000000U

/* Test configuration */
#define WARMUP_ITERATIONS       10
#define MIN_ITERATIONS          100
#define MAX_TEST_DATA_SIZE      16384

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
    u32 Hi = ReadReg(REG_DATA_OUT_HI);
    return ((u64)Hi << 32) | Lo;
}

static int SendMessage(const u8 *Message, u32 MsgLen)
{
    u32 WordsNeeded = (MsgLen + 7) / 8;
    u32 ByteIdx = 0;

    for (u32 w = 0; w < WordsNeeded; w++) {
        if (WaitForInputReady(DATA_TIMEOUT_US) != XST_SUCCESS) {
            return XST_FAILURE;
        }

        u64 Word64 = 0;
        u32 BytesInWord = (MsgLen - ByteIdx >= 8) ? 8 : (MsgLen - ByteIdx);

        for (u32 b = 0; b < BytesInWord; b++) {
            Word64 |= ((u64)Message[ByteIdx++]) << (b * 8);
        }

        WriteInputWord(Word64);
    }

    return XST_SUCCESS;
}

static int ReadHashOutput(u8 *Output, u32 OutputLen)
{
    u32 WordsNeeded = (OutputLen + 7) / 8;
    u32 ByteIdx = 0;

    for (u32 w = 0; w < WordsNeeded; w++) {
        if (WaitForOutputValid(DATA_TIMEOUT_US) != XST_SUCCESS) {
            return (int)ByteIdx;
        }

        u64 Word64 = ReadOutputWord();

        for (u32 b = 0; b < 8 && ByteIdx < OutputLen; b++) {
            Output[ByteIdx++] = (u8)((Word64 >> (b * 8)) & 0xFF);
        }
    }

    return (int)ByteIdx;
}

/* Timing utilities */
static XTime TimerFreq;
static XTime TimerOverhead;

static inline XTime GetCycles(void)
{
    XTime t;
    XTime_GetTime(&t);
    return t;
}

static void TimerCalibrate(void)
{
    XTime t1, t2;
    XTime min_overhead = (XTime)(-1);

    for (int i = 0; i < 100; i++) {
        t1 = GetCycles();
        t2 = GetCycles();
        XTime overhead = t2 - t1;
        if (overhead < min_overhead) {
            min_overhead = overhead;
        }
    }
    TimerOverhead = min_overhead;
}

static void TimerInit(void)
{
    /* Get CPU frequency in ticks per second */
    TimerFreq = COUNTS_PER_SECOND;
    TimerCalibrate();
}

static inline double CyclesToUs(XTime Cycles)
{
    return (double)(Cycles * 1000000.0) / (double)TimerFreq;
}

static inline double CyclesToMs(XTime Cycles)
{
    return (double)(Cycles * 1000.0) / (double)TimerFreq;
}

/* Benchmark result structure */
typedef struct {
    const char *Name;
    u32 InputSize;
    u32 Iterations;
    XTime TotalCycles;
    double ThroughputMiBps;
    double CyclesPerByte;
    double TimeUs;
    double LatencyUs;        /* Time per single hash */
} BenchmarkResult;

static u8 TestData[MAX_TEST_DATA_SIZE];
static u8 HashOutput[32];

/* Generate deterministic pseudo-random test data using LFSR */
static void GenerateTestData(u8 *Buffer, u32 Size)
{
    u32 seed = 0x12345678;
    for (u32 i = 0; i < Size; i++) {
        seed = (seed >> 1) ^ (-(seed & 1u) & 0xD0000001u);
        Buffer[i] = (u8)(seed & 0xFF);
    }
}

static int RunBenchmark(const char *Name, u32 InputSize, u32 Iterations, BenchmarkResult *Result)
{
    XTime StartCycles, EndCycles;

    xil_printf("\r\nRunning: %s (%lu bytes, %lu iterations)\r\n", Name, InputSize, Iterations);

    /* Warm-up iterations */
    for (u32 i = 0; i < WARMUP_ITERATIONS; i++) {
        if (WaitForIdle(IDLE_TIMEOUT_US) != XST_SUCCESS) {
            return XST_FAILURE;
        }
        Keccak_Configure(RATE_SHA3_256, DELIM_SHA3, 32, InputSize);
        Keccak_Start();
        if (SendMessage(TestData, InputSize) != XST_SUCCESS) {
            return XST_FAILURE;
        }
        if (ReadHashOutput(HashOutput, 32) != 32) {
            return XST_FAILURE;
        }
    }

    /* Actual measurement */
    StartCycles = GetCycles();

    for (u32 i = 0; i < Iterations; i++) {
        if (WaitForIdle(IDLE_TIMEOUT_US) != XST_SUCCESS) {
            return XST_FAILURE;
        }
        Keccak_Configure(RATE_SHA3_256, DELIM_SHA3, 32, InputSize);
        Keccak_Start();
        if (SendMessage(TestData, InputSize) != XST_SUCCESS) {
            return XST_FAILURE;
        }
        if (ReadHashOutput(HashOutput, 32) != 32) {
            return XST_FAILURE;
        }
    }

    EndCycles = GetCycles();

    /* Calculate results - subtract timer overhead */
    XTime TotalCycles = EndCycles - StartCycles - (TimerOverhead * Iterations);
    if (TotalCycles < 1) TotalCycles = 1; /* Prevent negative/zero */

    double TotalTimeUs = CyclesToUs(TotalCycles);
    double TotalBytes = (double)InputSize * Iterations;
    double TotalTimeS = TotalTimeUs / 1000000.0;
    double ThroughputMiBps = (TotalBytes / (1024.0 * 1024.0)) / TotalTimeS;
    double CyclesPerByte = (double)TotalCycles / TotalBytes;
    double LatencyUs = TotalTimeUs / Iterations;

    Result->Name = Name;
    Result->InputSize = InputSize;
    Result->Iterations = Iterations;
    Result->TotalCycles = TotalCycles;
    Result->ThroughputMiBps = ThroughputMiBps;
    Result->CyclesPerByte = CyclesPerByte;
    Result->TimeUs = TotalTimeUs;
    Result->LatencyUs = LatencyUs;

    return XST_SUCCESS;
}

/* Helper to print fixed-point values (xil_printf doesn't support %f well) */
static void PrintFixedPoint(const char *Label, s32 IntPart, s32 FracPart, u32 FracDigits)
{
    s32 divisor = 1;
    for (u32 i = 0; i < FracDigits; i++) divisor *= 10;

    /* Ensure fractional part is positive and has leading zeros */
    if (FracPart < 0) FracPart = -FracPart;
    if (IntPart < 0 && FracPart > 0) IntPart = -IntPart;

    /* Print fractional with leading zeros */
    s32 leading_zeros = FracDigits - 1;
    s32 temp = FracPart;
    while (temp >= 10) {
        leading_zeros--;
        temp /= 10;
    }

    xil_printf("%s", Label);
    xil_printf("%d.", IntPart);
    for (s32 i = 0; i < leading_zeros; i++) xil_printf("0");
    xil_printf("%d\r\n", FracPart);
}

/* Convert double to fixed-point components */
static void DoubleToFixed(double Value, s32 *IntPart, s32 *FracPart, u32 FracDigits)
{
    s32 divisor = 1;
    for (u32 i = 0; i < FracDigits; i++) divisor *= 10;

    *IntPart = (s32)Value;
    double frac = Value - *IntPart;
    if (frac < 0) frac = -frac;
    *FracPart = (s32)(frac * divisor + 0.5);
}

static void PrintResult(const BenchmarkResult *Result)
{
    s32 int_part, frac_part;

    xil_printf("\r\n=== %s ===\r\n", Result->Name);
    xil_printf("  Input size: %lu bytes\r\n", Result->InputSize);
    xil_printf("  Iterations: %lu\r\n", Result->Iterations);
    xil_printf("  Total cycles: %llu\r\n", Result->TotalCycles);

    DoubleToFixed(Result->TimeUs, &int_part, &frac_part, 2);
    PrintFixedPoint("  Time: ", int_part, frac_part, 2);

    DoubleToFixed(Result->ThroughputMiBps, &int_part, &frac_part, 2);
    PrintFixedPoint("  Throughput: ", int_part, frac_part, 2);

    DoubleToFixed(Result->CyclesPerByte, &int_part, &frac_part, 2);
    PrintFixedPoint("  Cycles/byte: ", int_part, frac_part, 2);

    DoubleToFixed(Result->LatencyUs, &int_part, &frac_part, 2);
    PrintFixedPoint("  Latency: ", int_part, frac_part, 2);
}

/* Print table row with fixed-point values */
static void PrintTableRow(const char *Name, u32 Size, double MiBps, double CyclesPerB, double Latency)
{
    s32 int_mib, frac_mib, int_cpb, frac_cpb, int_lat, frac_lat;

    DoubleToFixed(MiBps, &int_mib, &frac_mib, 2);
    DoubleToFixed(CyclesPerB, &int_cpb, &frac_cpb, 2);
    DoubleToFixed(Latency, &int_lat, &frac_lat, 2);

    xil_printf("%-20s %10lu ", Name, Size);

    /* MiB/s */
    if (frac_mib < 10) xil_printf("   %d.0%d ", int_mib, frac_mib);
    else xil_printf("   %d.%d ", int_mib, frac_mib);

    /* Cycles/B */
    if (frac_cpb < 10) xil_printf("   %d.0%d ", int_cpb, frac_cpb);
    else xil_printf("   %d.%d ", int_cpb, frac_cpb);

    /* Latency */
    if (frac_lat < 10) xil_printf("   %d.0%d\r\n", int_lat, frac_lat);
    else xil_printf("   %d.%d\r\n", int_lat, frac_lat);
}

static void PrintResultsTable(const BenchmarkResult *Results, u32 Count)
{
    xil_printf("\r\n");
    xil_printf("========================================\r\n");
    xil_printf("  SHA3-256 Hardware Bandwidth Results\r\n");
    xil_printf("========================================\r\n");
    xil_printf("\r\n");
    xil_printf("%-20s %10s %12s %12s %12s\r\n", "Test", "Size", "MiB/s", "Cycles/B", "Latency(us)");
    xil_printf("--------------------------------------------------------------------\r\n");

    for (u32 i = 0; i < Count; i++) {
        PrintTableRow(Results[i].Name,
                      Results[i].InputSize,
                      Results[i].ThroughputMiBps,
                      Results[i].CyclesPerByte,
                      Results[i].LatencyUs);
    }

    xil_printf("--------------------------------------------------------------------\r\n");
    xil_printf("\r\n");
    xil_printf("CPU Frequency: %lu MHz\r\n", TimerFreq / 1000000);
    xil_printf("Timer Overhead: %llu cycles\r\n", TimerOverhead);
    xil_printf("\r\n");
}

int main(void)
{
    BenchmarkResult Results[5];
    u32 ResultCount = 0;
    int Status;

    xil_printf("\r\n");
    xil_printf("========================================\r\n");
    xil_printf("  Keccak Hardware Bandwidth Test\r\n");
    xil_printf("========================================\r\n");

    /* Initialize timer and test data */
    TimerInit();
    GenerateTestData(TestData, MAX_TEST_DATA_SIZE);

    xil_printf("Timer calibrated, CPU freq: %lu MHz\r\n", TimerFreq / 1000000);
    xil_printf("Timer overhead: %llu cycles\r\n", TimerOverhead);
    xil_printf("Warm-up iterations: %d\r\n", WARMUP_ITERATIONS);

    /* Wait for core to be idle */
    if (WaitForIdle(IDLE_TIMEOUT_US) != XST_SUCCESS) {
        xil_printf("ERROR: Core not idle\r\n");
        return XST_FAILURE;
    }

    xil_printf("\r\nStarting benchmarks...\r\n");

    /* Test 1: 64 bytes (small message, single block) */
    Status = RunBenchmark("sha3_256_64b", 64, 1000, &Results[ResultCount]);
    if (Status == XST_SUCCESS) {
        PrintResult(&Results[ResultCount]);
        ResultCount++;
    }

    /* Test 2: 136 bytes (exactly one SHA3-256 rate) */
    Status = RunBenchmark("sha3_256_136b", 136, 1000, &Results[ResultCount]);
    if (Status == XST_SUCCESS) {
        PrintResult(&Results[ResultCount]);
        ResultCount++;
    }

    /* Test 3: 1024 bytes (1 KB) */
    Status = RunBenchmark("sha3_256_1k", 1024, 500, &Results[ResultCount]);
    if (Status == XST_SUCCESS) {
        PrintResult(&Results[ResultCount]);
        ResultCount++;
    }

    /* Test 4: 4096 bytes (4 KB) */
    Status = RunBenchmark("sha3_256_4k", 4096, 200, &Results[ResultCount]);
    if (Status == XST_SUCCESS) {
        PrintResult(&Results[ResultCount]);
        ResultCount++;
    }

    /* Test 5: 16384 bytes (16 KB) */
    Status = RunBenchmark("sha3_256_16k", 16384, 50, &Results[ResultCount]);
    if (Status == XST_SUCCESS) {
        PrintResult(&Results[ResultCount]);
        ResultCount++;
    }

    /* Print summary table */
    if (ResultCount > 0) {
        PrintResultsTable(Results, ResultCount);
        xil_printf("\r\n");
    } else {
        xil_printf("\r\nERROR: No benchmarks completed successfully\r\n");
    }

    xil_printf("Bandwidth test complete.\r\n");
    xil_printf("\r\n");

    return (ResultCount > 0) ? XST_SUCCESS : XST_FAILURE;
}
