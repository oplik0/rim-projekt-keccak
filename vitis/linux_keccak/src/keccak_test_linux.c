/**
 * Keccak IP Core Test Application - Linux User-Space Version
 *
 * This application tests the Keccak SHA-3 hardware accelerator IP core
 * on the FPGA from Linux user-space using memory-mapped I/O.
 *
 * Hardware Configuration:
 * - Keccak Control (AXI-Lite): 0xA0000000 (4KB)
 * - AXI FIFO MM S:             0xB0000000 (64KB)
 *
 * Usage:
 *   ./linux_keccak.elf [--verbose] [--test <test_name>]
 *
 * Test Vectors:
 * - SHA3-256("")
 * - SHA3-256("abc")
 * - SHA3-512("")
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>

/* ==========================================================================
 * Hardware Base Addresses (from AddressSegments.csv)
 * ========================================================================== */

#define KECCAK_CTRL_BASEADDR    0xA0000000UL   // Keccak control interface (4KB)
#define KECCAK_CTRL_SIZE        0x1000         // 4KB

#define AXI_FIFO_BASEADDR       0xB0000000UL   // AXI FIFO MM S (64KB)
#define AXI_FIFO_SIZE           0x10000        // 64KB

/* ==========================================================================
 * Keccak Control Registers (from keccak_top_control_s_axi.vhd)
 * ========================================================================== */

// Control register offsets
#define KECCAK_AP_CTRL          0x00    // Control signals
#define KECCAK_GIE              0x04    // Global Interrupt Enable
#define KECCAK_IER              0x08    // IP Interrupt Enable
#define KECCAK_ISR              0x0C    // IP Interrupt Status
#define KECCAK_RATE_BYTES       0x10    // Rate in bytes
#define KECCAK_DELIMITER        0x18    // Domain separator/delimiter
#define KECCAK_OUTPUT_LEN       0x20    // Output length in bytes

// Control register bits
#define AP_CTRL_START           (1 << 0)
#define AP_CTRL_DONE            (1 << 1)
#define AP_CTRL_IDLE            (1 << 2)
#define AP_CTRL_READY           (1 << 3)

/* ==========================================================================
 * AXI FIFO MM S Registers (from PG080)
 * ========================================================================== */

// Register offsets (relative to FIFO base address)
#define FIFO_ISR                0x00    // Interrupt Status Register
#define FIFO_IER                0x04    // Interrupt Enable Register
#define FIFO_TDFR               0x08    // Transmit Data FIFO Reset
#define FIFO_TDFV               0x0C    // Transmit Data FIFO Vacancy
#define FIFO_TDFD               0x10    // Transmit Data FIFO Data
#define FIFO_TLR                0x14    // Transmit Length Register
#define FIFO_RDFR               0x18    // Receive Data FIFO Reset
#define FIFO_RDFO               0x1C    // Receive Data FIFO Occupancy
#define FIFO_RDFD               0x20    // Receive Data FIFO Data
#define FIFO_RLR                0x24    // Receive Length Register
#define FIFO_SRR                0x28    // AXI4-Stream Reset

// Reset magic value
#define FIFO_RESET_VALUE        0xA5

// ISR bits
#define FIFO_ISR_RC             (1 << 26)   // Receive Complete
#define FIFO_ISR_TC             (1 << 27)   // Transmit Complete

/* ==========================================================================
 * SHA-3 Configuration Constants
 * ========================================================================== */

// Rate values (in bytes)
#define RATE_SHA3_224           144
#define RATE_SHA3_256           136
#define RATE_SHA3_384           104
#define RATE_SHA3_512           72
#define RATE_SHAKE128           168
#define RATE_SHAKE256           136

// Domain separator (delimiter)
#define DELIM_SHA3              0x06
#define DELIM_SHAKE             0x1F

/* ==========================================================================
 * Global Variables
 * ========================================================================== */

static volatile uint32_t *keccak_ctrl = NULL;
static volatile uint32_t *axi_fifo = NULL;
static int mem_fd = -1;
static bool verbose_mode = false;

/* ==========================================================================
 * Register Access Functions
 * ========================================================================== */

static inline void keccak_write(uint32_t offset, uint32_t value)
{
    keccak_ctrl[offset / 4] = value;
}

static inline uint32_t keccak_read(uint32_t offset)
{
    return keccak_ctrl[offset / 4];
}

static inline void fifo_write32(uint32_t offset, uint32_t value)
{
    axi_fifo[offset / 4] = value;
}

static inline uint32_t fifo_read32(uint32_t offset)
{
    return axi_fifo[offset / 4];
}

// Write 64-bit value to FIFO data port
static inline void fifo_write64(uint64_t data)
{
    fifo_write32(FIFO_TDFD, (uint32_t)(data & 0xFFFFFFFF));
    fifo_write32(FIFO_TDFD + 4, (uint32_t)(data >> 32));
}

// Read 64-bit value from FIFO data port
static inline uint64_t fifo_read64(void)
{
    uint64_t low = fifo_read32(FIFO_RDFD);
    uint64_t high = fifo_read32(FIFO_RDFD + 4);
    return low | (high << 32);
}

/* ==========================================================================
 * Expected Hash Values (NIST Test Vectors)
 * ========================================================================== */

// SHA3-256("") = a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a
static const uint8_t SHA3_256_EMPTY[32] = {
    0xa7, 0xff, 0xc6, 0xf8, 0xbf, 0x1e, 0xd7, 0x66,
    0x51, 0xc1, 0x47, 0x56, 0xa0, 0x61, 0xd6, 0x62,
    0xf5, 0x80, 0xff, 0x4d, 0xe4, 0x3b, 0x49, 0xfa,
    0x82, 0xd8, 0x0a, 0x4b, 0x80, 0xf8, 0x43, 0x4a
};

// SHA3-256("abc") = 3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532
static const uint8_t SHA3_256_ABC[32] = {
    0x3a, 0x98, 0x5d, 0xa7, 0x4f, 0xe2, 0x25, 0xb2,
    0x04, 0x5c, 0x17, 0x2d, 0x6b, 0xd3, 0x90, 0xbd,
    0x85, 0x5f, 0x08, 0x6e, 0x3e, 0x9d, 0x52, 0x5b,
    0x46, 0xbf, 0xe2, 0x45, 0x11, 0x43, 0x15, 0x32
};

// SHA3-512("")
static const uint8_t SHA3_512_EMPTY[64] = {
    0xa6, 0x9f, 0x73, 0xcc, 0xa2, 0x3a, 0x9a, 0xc5,
    0xc8, 0xb5, 0x67, 0xdc, 0x18, 0x5a, 0x75, 0x6e,
    0x97, 0xc9, 0x82, 0x16, 0x4f, 0xe2, 0x58, 0x59,
    0xe0, 0xd1, 0xdc, 0xc1, 0x47, 0x5c, 0x80, 0xa6,
    0x15, 0xb2, 0x12, 0x3a, 0xf1, 0xf5, 0xf9, 0x4c,
    0x11, 0xe3, 0xe9, 0x40, 0x2c, 0x3a, 0xc5, 0x58,
    0xf5, 0x00, 0x19, 0x9d, 0x95, 0xb6, 0xd3, 0xe3,
    0x01, 0x75, 0x85, 0x86, 0x28, 0x1d, 0xcd, 0x26
};

/* ==========================================================================
 * Helper Functions
 * ========================================================================== */

static void print_hex(const char *label, const uint8_t *data, size_t len)
{
    printf("%s: ", label);
    for (size_t i = 0; i < len; i++) {
        printf("%02x", data[i]);
    }
    printf("\n");
}

static bool compare_bytes(const uint8_t *a, const uint8_t *b, size_t len)
{
    for (size_t i = 0; i < len; i++) {
        if (a[i] != b[i]) {
            return false;
        }
    }
    return true;
}

static void fifo_reset(void)
{
    fifo_write32(FIFO_TDFR, FIFO_RESET_VALUE);
    fifo_write32(FIFO_RDFR, FIFO_RESET_VALUE);
    fifo_write32(FIFO_SRR, FIFO_RESET_VALUE);
    fifo_write32(FIFO_ISR, 0xFFFFFFFF);
    usleep(1000);  // 1ms delay
}

static bool wait_for_idle(uint32_t timeout_ms)
{
    for (uint32_t i = 0; i < timeout_ms; i++) {
        uint32_t status = keccak_read(KECCAK_AP_CTRL);
        if (status & AP_CTRL_IDLE) {
            return true;
        }
        usleep(1000);
    }
    return false;
}

static bool wait_for_done(uint32_t timeout_ms)
{
    for (uint32_t i = 0; i < timeout_ms; i++) {
        uint32_t status = keccak_read(KECCAK_AP_CTRL);
        if (status & AP_CTRL_DONE) {
            return true;
        }
        usleep(1000);
    }
    return false;
}

static void keccak_configure(uint8_t rate_bytes, uint8_t delimiter, uint16_t output_len)
{
    keccak_write(KECCAK_RATE_BYTES, rate_bytes);
    keccak_write(KECCAK_DELIMITER, delimiter);
    keccak_write(KECCAK_OUTPUT_LEN, output_len);
    
    if (verbose_mode) {
        printf("  Configured: rate=%u, delim=0x%02x, output_len=%u\n",
               rate_bytes, delimiter, output_len);
    }
}

static void keccak_start(void)
{
    keccak_write(KECCAK_AP_CTRL, AP_CTRL_START);
}

static int read_hash_output(uint8_t *output, size_t output_len)
{
    size_t bytes_read = 0;
    uint32_t timeout_ms = 1000;
    
    while (bytes_read < output_len && timeout_ms > 0) {
        uint32_t occupancy = fifo_read32(FIFO_RDFO);
        
        if (occupancy > 0) {
            uint64_t data = fifo_read64();
            for (int i = 0; i < 8 && bytes_read < output_len; i++) {
                output[bytes_read++] = (uint8_t)(data >> (i * 8));
            }
        } else {
            usleep(1000);
            timeout_ms--;
        }
    }
    
    return (timeout_ms > 0) ? 0 : -1;
}

/* ==========================================================================
 * Test Cases
 * ========================================================================== */

static bool test_sha3_256_empty(void)
{
    printf("\n=== Test: SHA3-256 (empty message) ===\n");
    
    uint8_t result[32];
    
    fifo_reset();
    
    if (!wait_for_idle(100)) {
        printf("ERROR: Keccak core not idle\n");
        return false;
    }
    
    keccak_configure(RATE_SHA3_256, DELIM_SHA3, 32);
    keccak_start();
    
    // Empty message: set TLR to 0
    fifo_write32(FIFO_TLR, 0);
    
    if (!wait_for_done(1000)) {
        printf("ERROR: Keccak core did not complete\n");
        return false;
    }
    
    if (read_hash_output(result, 32) != 0) {
        printf("ERROR: Failed to read hash output\n");
        return false;
    }
    
    print_hex("Expected", SHA3_256_EMPTY, 32);
    print_hex("Got     ", result, 32);
    
    bool pass = compare_bytes(result, SHA3_256_EMPTY, 32);
    printf("Result: %s\n", pass ? "\033[32mPASS\033[0m" : "\033[31mFAIL\033[0m");
    
    return pass;
}

static bool test_sha3_256_abc(void)
{
    printf("\n=== Test: SHA3-256 (\"abc\") ===\n");
    
    uint8_t result[32];
    
    fifo_reset();
    
    if (!wait_for_idle(100)) {
        printf("ERROR: Keccak core not idle\n");
        return false;
    }
    
    keccak_configure(RATE_SHA3_256, DELIM_SHA3, 32);
    keccak_start();
    
    // Write "abc" as 64-bit word (little-endian)
    fifo_write64(0x0000000000636261ULL);
    fifo_write32(FIFO_TLR, 3);
    
    if (!wait_for_done(1000)) {
        printf("ERROR: Keccak core did not complete\n");
        return false;
    }
    
    if (read_hash_output(result, 32) != 0) {
        printf("ERROR: Failed to read hash output\n");
        return false;
    }
    
    print_hex("Expected", SHA3_256_ABC, 32);
    print_hex("Got     ", result, 32);
    
    bool pass = compare_bytes(result, SHA3_256_ABC, 32);
    printf("Result: %s\n", pass ? "\033[32mPASS\033[0m" : "\033[31mFAIL\033[0m");
    
    return pass;
}

static bool test_sha3_512_empty(void)
{
    printf("\n=== Test: SHA3-512 (empty message) ===\n");
    
    uint8_t result[64];
    
    fifo_reset();
    
    if (!wait_for_idle(100)) {
        printf("ERROR: Keccak core not idle\n");
        return false;
    }
    
    keccak_configure(RATE_SHA3_512, DELIM_SHA3, 64);
    keccak_start();
    
    fifo_write32(FIFO_TLR, 0);
    
    if (!wait_for_done(1000)) {
        printf("ERROR: Keccak core did not complete\n");
        return false;
    }
    
    if (read_hash_output(result, 64) != 0) {
        printf("ERROR: Failed to read hash output\n");
        return false;
    }
    
    print_hex("Expected", SHA3_512_EMPTY, 64);
    print_hex("Got     ", result, 64);
    
    bool pass = compare_bytes(result, SHA3_512_EMPTY, 64);
    printf("Result: %s\n", pass ? "\033[32mPASS\033[0m" : "\033[31mFAIL\033[0m");
    
    return pass;
}

static bool test_sha3_256_long(void)
{
    printf("\n=== Test: SHA3-256 (200 bytes of zeros) ===\n");
    
    uint8_t result[32];
    
    fifo_reset();
    
    if (!wait_for_idle(100)) {
        printf("ERROR: Keccak core not idle\n");
        return false;
    }
    
    keccak_configure(RATE_SHA3_256, DELIM_SHA3, 32);
    keccak_start();
    
    // Write 200 bytes of zeros (25 x 64-bit words)
    for (int i = 0; i < 25; i++) {
        fifo_write64(0);
    }
    fifo_write32(FIFO_TLR, 200);
    
    if (!wait_for_done(1000)) {
        printf("ERROR: Keccak core did not complete\n");
        return false;
    }
    
    if (read_hash_output(result, 32) != 0) {
        printf("ERROR: Failed to read hash output\n");
        return false;
    }
    
    print_hex("Got", result, 32);
    
    bool has_nonzero = false;
    for (int i = 0; i < 32; i++) {
        if (result[i] != 0) {
            has_nonzero = true;
            break;
        }
    }
    
    printf("Result: %s (non-zero output)\n", 
           has_nonzero ? "\033[32mPASS\033[0m" : "\033[31mFAIL\033[0m");
    
    return has_nonzero;
}

static void print_core_status(void)
{
    printf("\n=== Keccak Core Status ===\n");
    
    uint32_t ctrl = keccak_read(KECCAK_AP_CTRL);
    printf("AP_CTRL: 0x%08X\n", ctrl);
    printf("  - START: %d\n", (ctrl >> 0) & 1);
    printf("  - DONE:  %d\n", (ctrl >> 1) & 1);
    printf("  - IDLE:  %d\n", (ctrl >> 2) & 1);
    printf("  - READY: %d\n", (ctrl >> 3) & 1);
    
    printf("\n=== AXI FIFO Status ===\n");
    
    printf("ISR:  0x%08X\n", fifo_read32(FIFO_ISR));
    printf("TDFV: %u (TX vacancy)\n", fifo_read32(FIFO_TDFV));
    printf("RDFO: %u (RX occupancy)\n", fifo_read32(FIFO_RDFO));
}

/* ==========================================================================
 * Hardware Initialization
 * ========================================================================== */

static int hw_init(void)
{
    mem_fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (mem_fd < 0) {
        perror("Failed to open /dev/mem");
        printf("Try running with sudo.\n");
        return -1;
    }
    
    // Map Keccak control interface
    keccak_ctrl = (volatile uint32_t *)mmap(
        NULL,
        KECCAK_CTRL_SIZE,
        PROT_READ | PROT_WRITE,
        MAP_SHARED,
        mem_fd,
        KECCAK_CTRL_BASEADDR
    );
    
    if (keccak_ctrl == MAP_FAILED) {
        perror("Failed to mmap Keccak control");
        close(mem_fd);
        return -1;
    }
    
    // Map AXI FIFO
    axi_fifo = (volatile uint32_t *)mmap(
        NULL,
        AXI_FIFO_SIZE,
        PROT_READ | PROT_WRITE,
        MAP_SHARED,
        mem_fd,
        AXI_FIFO_BASEADDR
    );
    
    if (axi_fifo == MAP_FAILED) {
        perror("Failed to mmap AXI FIFO");
        munmap((void *)keccak_ctrl, KECCAK_CTRL_SIZE);
        close(mem_fd);
        return -1;
    }
    
    printf("Hardware mapped successfully.\n");
    return 0;
}

static void hw_cleanup(void)
{
    if (keccak_ctrl != NULL && keccak_ctrl != MAP_FAILED) {
        munmap((void *)keccak_ctrl, KECCAK_CTRL_SIZE);
    }
    if (axi_fifo != NULL && axi_fifo != MAP_FAILED) {
        munmap((void *)axi_fifo, AXI_FIFO_SIZE);
    }
    if (mem_fd >= 0) {
        close(mem_fd);
    }
}

/* ==========================================================================
 * Interactive Mode
 * ========================================================================== */

static void run_interactive(void)
{
    char input[256];
    uint8_t message[1024];
    uint8_t result[64];
    
    printf("\n=== Interactive Keccak Hashing ===\n");
    printf("Enter messages to hash (empty line to exit):\n\n");
    
    while (1) {
        printf("Message: ");
        fflush(stdout);
        
        if (fgets(input, sizeof(input), stdin) == NULL) {
            break;
        }
        
        // Remove newline
        size_t len = strlen(input);
        if (len > 0 && input[len-1] == '\n') {
            input[--len] = '\0';
        }
        
        if (len == 0) {
            break;
        }
        
        // Copy to message buffer
        memcpy(message, input, len);
        
        // Reset and configure
        fifo_reset();
        if (!wait_for_idle(100)) {
            printf("ERROR: Core not idle\n");
            continue;
        }
        
        keccak_configure(RATE_SHA3_256, DELIM_SHA3, 32);
        keccak_start();
        
        // Write message to FIFO
        for (size_t i = 0; i < len; i += 8) {
            uint64_t word = 0;
            for (int j = 0; j < 8 && (i + j) < len; j++) {
                word |= ((uint64_t)message[i + j]) << (j * 8);
            }
            fifo_write64(word);
        }
        fifo_write32(FIFO_TLR, len);
        
        // Wait and read
        if (!wait_for_done(1000)) {
            printf("ERROR: Timeout\n");
            continue;
        }
        
        if (read_hash_output(result, 32) != 0) {
            printf("ERROR: Failed to read output\n");
            continue;
        }
        
        print_hex("SHA3-256", result, 32);
        printf("\n");
    }
}

/* ==========================================================================
 * Main Entry Point
 * ========================================================================== */

static void print_usage(const char *prog)
{
    printf("Usage: %s [options]\n", prog);
    printf("\nOptions:\n");
    printf("  -h, --help       Show this help message\n");
    printf("  -v, --verbose    Enable verbose output\n");
    printf("  -i, --interactive  Run interactive mode\n");
    printf("  -s, --status     Show hardware status only\n");
    printf("  -t, --test NAME  Run specific test (empty, abc, sha512, long, all)\n");
    printf("\nExamples:\n");
    printf("  sudo %s                # Run all tests\n", prog);
    printf("  sudo %s -i             # Interactive mode\n", prog);
    printf("  sudo %s -t abc         # Run only SHA3-256(\"abc\") test\n", prog);
}

int main(int argc, char *argv[])
{
    bool run_all = true;
    bool status_only = false;
    bool interactive = false;
    const char *test_name = NULL;
    
    // Parse arguments
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            print_usage(argv[0]);
            return 0;
        } else if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--verbose") == 0) {
            verbose_mode = true;
        } else if (strcmp(argv[i], "-s") == 0 || strcmp(argv[i], "--status") == 0) {
            status_only = true;
            run_all = false;
        } else if (strcmp(argv[i], "-i") == 0 || strcmp(argv[i], "--interactive") == 0) {
            interactive = true;
            run_all = false;
        } else if (strcmp(argv[i], "-t") == 0 || strcmp(argv[i], "--test") == 0) {
            if (i + 1 < argc) {
                test_name = argv[++i];
                run_all = false;
            } else {
                fprintf(stderr, "Error: --test requires an argument\n");
                return 1;
            }
        }
    }
    
    printf("\n");
    printf("========================================\n");
    printf("  Keccak IP Core Test (Linux)\n");
    printf("========================================\n");
    printf("\n");
    printf("Hardware Configuration:\n");
    printf("  Keccak Control: 0x%08lX\n", KECCAK_CTRL_BASEADDR);
    printf("  AXI FIFO:       0x%08lX\n", AXI_FIFO_BASEADDR);
    printf("\n");
    
    // Initialize hardware
    if (hw_init() != 0) {
        return 1;
    }
    
    // Status only mode
    if (status_only) {
        print_core_status();
        hw_cleanup();
        return 0;
    }
    
    // Interactive mode
    if (interactive) {
        fifo_reset();
        if (!wait_for_idle(100)) {
            printf("ERROR: Keccak core not ready\n");
            hw_cleanup();
            return 1;
        }
        run_interactive();
        hw_cleanup();
        return 0;
    }
    
    // Initialize FIFO
    fifo_reset();
    
    // Check core is ready
    if (!wait_for_idle(100)) {
        printf("ERROR: Keccak core not ready (not idle)\n");
        print_core_status();
        hw_cleanup();
        return 1;
    }
    printf("Keccak core is ready.\n");
    
    int tests_passed = 0;
    int tests_total = 0;
    
    printf("\n========================================\n");
    printf("  Running Tests\n");
    printf("========================================\n");
    
    // Run tests
    if (run_all || (test_name && strcmp(test_name, "all") == 0)) {
        tests_total += 4;
        if (test_sha3_256_empty()) tests_passed++;
        if (test_sha3_256_abc()) tests_passed++;
        if (test_sha3_512_empty()) tests_passed++;
        if (test_sha3_256_long()) tests_passed++;
    } else if (test_name) {
        if (strcmp(test_name, "empty") == 0) {
            tests_total++;
            if (test_sha3_256_empty()) tests_passed++;
        } else if (strcmp(test_name, "abc") == 0) {
            tests_total++;
            if (test_sha3_256_abc()) tests_passed++;
        } else if (strcmp(test_name, "sha512") == 0) {
            tests_total++;
            if (test_sha3_512_empty()) tests_passed++;
        } else if (strcmp(test_name, "long") == 0) {
            tests_total++;
            if (test_sha3_256_long()) tests_passed++;
        } else {
            fprintf(stderr, "Unknown test: %s\n", test_name);
            hw_cleanup();
            return 1;
        }
    }
    
    // Summary
    printf("\n========================================\n");
    printf("  Test Summary\n");
    printf("========================================\n");
    printf("Passed: %d / %d\n", tests_passed, tests_total);
    
    if (tests_passed == tests_total) {
        printf("Result: \033[32mALL TESTS PASSED\033[0m\n");
    } else {
        printf("Result: \033[31mSOME TESTS FAILED\033[0m\n");
    }
    printf("\n");
    
    if (verbose_mode) {
        print_core_status();
    }
    
    hw_cleanup();
    
    return (tests_passed == tests_total) ? 0 : 1;
}
