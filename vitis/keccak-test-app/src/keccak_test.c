/**
 * Keccak IP Core Test Application
 *
 * This application tests the Keccak SHA-3 hardware accelerator IP core
 * on the FPGA using the Zynq UltraScale+ MPSoC.
 *
 * Hardware Configuration:
 * - Keccak Control (AXI-Lite): 0xA0000000 (4KB)
 * - AXI FIFO MM S:             0xB0000000 (64KB)
 *
 * Test Vectors:
 * - SHA3-256("") 
 * - SHA3-256("abc")
 * - SHA3-512("")
 */

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

/* ==========================================================================
 * Hardware Base Addresses (from AddressSegments.csv)
 * ========================================================================== */

#define KECCAK_CTRL_BASEADDR    0xA0000000UL   // Keccak control interface (4KB)
#define AXI_FIFO_BASEADDR       0xB0000000UL   // AXI FIFO MM S (64KB)

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
 * Register Access Macros
 * ========================================================================== */

// Memory-mapped I/O write
static inline void reg_write(uint64_t addr, uint32_t value)
{
    volatile uint32_t *ptr = (volatile uint32_t *)addr;
    *ptr = value;
}

// Memory-mapped I/O read
static inline uint32_t reg_read(uint64_t addr)
{
    volatile uint32_t *ptr = (volatile uint32_t *)addr;
    return *ptr;
}

// Write 64-bit value to FIFO data port (two 32-bit writes)
static inline void fifo_write64(uint64_t data)
{
    // AXI FIFO is 64-bit wide, write as two 32-bit words (little-endian)
    reg_write(AXI_FIFO_BASEADDR + FIFO_TDFD, (uint32_t)(data & 0xFFFFFFFF));
    reg_write(AXI_FIFO_BASEADDR + FIFO_TDFD + 4, (uint32_t)(data >> 32));
}

// Read 64-bit value from FIFO data port
static inline uint64_t fifo_read64(void)
{
    uint64_t low = reg_read(AXI_FIFO_BASEADDR + FIFO_RDFD);
    uint64_t high = reg_read(AXI_FIFO_BASEADDR + FIFO_RDFD + 4);
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

// SHA3-512("") = a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a6
//                15b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26
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

/**
 * Print a hex dump of data
 */
static void print_hex(const char *label, const uint8_t *data, size_t len)
{
    printf("%s: ", label);
    for (size_t i = 0; i < len; i++) {
        printf("%02x", data[i]);
    }
    printf("\n");
}

/**
 * Compare two byte arrays
 */
static bool compare_bytes(const uint8_t *a, const uint8_t *b, size_t len)
{
    for (size_t i = 0; i < len; i++) {
        if (a[i] != b[i]) {
            return false;
        }
    }
    return true;
}

/**
 * Reset the AXI FIFO
 */
static void fifo_reset(void)
{
    // Reset transmit FIFO
    reg_write(AXI_FIFO_BASEADDR + FIFO_TDFR, FIFO_RESET_VALUE);
    
    // Reset receive FIFO
    reg_write(AXI_FIFO_BASEADDR + FIFO_RDFR, FIFO_RESET_VALUE);
    
    // Full AXI-Stream reset
    reg_write(AXI_FIFO_BASEADDR + FIFO_SRR, FIFO_RESET_VALUE);
    
    // Clear any pending interrupts
    reg_write(AXI_FIFO_BASEADDR + FIFO_ISR, 0xFFFFFFFF);
    
    // Small delay for reset to complete
    for (volatile int i = 0; i < 1000; i++);
}

/**
 * Wait for Keccak core to become idle
 */
static bool wait_for_idle(uint32_t timeout)
{
    for (uint32_t i = 0; i < timeout; i++) {
        uint32_t status = reg_read(KECCAK_CTRL_BASEADDR + KECCAK_AP_CTRL);
        if (status & AP_CTRL_IDLE) {
            return true;
        }
    }
    return false;
}

/**
 * Wait for Keccak core to complete
 */
static bool wait_for_done(uint32_t timeout)
{
    for (uint32_t i = 0; i < timeout; i++) {
        uint32_t status = reg_read(KECCAK_CTRL_BASEADDR + KECCAK_AP_CTRL);
        if (status & AP_CTRL_DONE) {
            return true;
        }
    }
    return false;
}

/**
 * Configure the Keccak core
 */
static void keccak_configure(uint8_t rate_bytes, uint8_t delimiter, uint16_t output_len)
{
    reg_write(KECCAK_CTRL_BASEADDR + KECCAK_RATE_BYTES, rate_bytes);
    reg_write(KECCAK_CTRL_BASEADDR + KECCAK_DELIMITER, delimiter);
    reg_write(KECCAK_CTRL_BASEADDR + KECCAK_OUTPUT_LEN, output_len);
}

/**
 * Start the Keccak core
 */
static void keccak_start(void)
{
    reg_write(KECCAK_CTRL_BASEADDR + KECCAK_AP_CTRL, AP_CTRL_START);
}

/**
 * Read hash output from FIFO
 */
static int read_hash_output(uint8_t *output, size_t output_len)
{
    size_t bytes_read = 0;
    uint32_t timeout = 100000;
    
    while (bytes_read < output_len && timeout > 0) {
        // Check if data is available
        uint32_t occupancy = reg_read(AXI_FIFO_BASEADDR + FIFO_RDFO);
        
        if (occupancy > 0) {
            // Read 64-bit word from FIFO
            uint64_t data = fifo_read64();
            
            // Extract bytes (little-endian)
            for (int i = 0; i < 8 && bytes_read < output_len; i++) {
                output[bytes_read++] = (uint8_t)(data >> (i * 8));
            }
        } else {
            timeout--;
        }
    }
    
    return (timeout > 0) ? 0 : -1;
}

/* ==========================================================================
 * Test Cases
 * ========================================================================== */

/**
 * Test SHA3-256 with empty message
 */
static bool test_sha3_256_empty(void)
{
    printf("\n=== Test: SHA3-256 (empty message) ===\n");
    
    uint8_t result[32];
    
    // Reset FIFO
    fifo_reset();
    
    // Wait for core to be idle
    if (!wait_for_idle(10000)) {
        printf("ERROR: Keccak core not idle\n");
        return false;
    }
    
    // Configure for SHA3-256
    keccak_configure(RATE_SHA3_256, DELIM_SHA3, 32);
    
    // Start the core
    keccak_start();
    
    // For empty message: send a packet through FIFO that signals end
    // The FIFO transmits to the AXI-Stream interface
    // We need to set TLR to 0 to indicate empty packet
    reg_write(AXI_FIFO_BASEADDR + FIFO_TLR, 0);
    
    // Wait for completion
    if (!wait_for_done(100000)) {
        printf("ERROR: Keccak core did not complete\n");
        return false;
    }
    
    // Read output
    if (read_hash_output(result, 32) != 0) {
        printf("ERROR: Failed to read hash output\n");
        return false;
    }
    
    // Compare results
    print_hex("Expected", SHA3_256_EMPTY, 32);
    print_hex("Got     ", result, 32);
    
    bool pass = compare_bytes(result, SHA3_256_EMPTY, 32);
    printf("Result: %s\n", pass ? "PASS" : "FAIL");
    
    return pass;
}

/**
 * Test SHA3-256 with "abc"
 */
static bool test_sha3_256_abc(void)
{
    printf("\n=== Test: SHA3-256 (\"abc\") ===\n");
    
    uint8_t result[32];
    const uint8_t message[] = { 0x61, 0x62, 0x63 };  // "abc"
    
    // Reset FIFO
    fifo_reset();
    
    // Wait for core to be idle
    if (!wait_for_idle(10000)) {
        printf("ERROR: Keccak core not idle\n");
        return false;
    }
    
    // Configure for SHA3-256
    keccak_configure(RATE_SHA3_256, DELIM_SHA3, 32);
    
    // Start the core
    keccak_start();
    
    // Write message to FIFO (pack "abc" into 64-bit word, little-endian)
    // "abc" = 0x63 0x62 0x61 in memory, as 64-bit LE: 0x0000000000636261
    uint64_t data_word = 0x0000000000636261ULL;
    fifo_write64(data_word);
    
    // Set transmit length (3 bytes)
    reg_write(AXI_FIFO_BASEADDR + FIFO_TLR, 3);
    
    // Wait for completion
    if (!wait_for_done(100000)) {
        printf("ERROR: Keccak core did not complete\n");
        return false;
    }
    
    // Read output
    if (read_hash_output(result, 32) != 0) {
        printf("ERROR: Failed to read hash output\n");
        return false;
    }
    
    // Compare results
    print_hex("Expected", SHA3_256_ABC, 32);
    print_hex("Got     ", result, 32);
    
    bool pass = compare_bytes(result, SHA3_256_ABC, 32);
    printf("Result: %s\n", pass ? "PASS" : "FAIL");
    
    return pass;
}

/**
 * Test SHA3-512 with empty message
 */
static bool test_sha3_512_empty(void)
{
    printf("\n=== Test: SHA3-512 (empty message) ===\n");
    
    uint8_t result[64];
    
    // Reset FIFO
    fifo_reset();
    
    // Wait for core to be idle
    if (!wait_for_idle(10000)) {
        printf("ERROR: Keccak core not idle\n");
        return false;
    }
    
    // Configure for SHA3-512
    keccak_configure(RATE_SHA3_512, DELIM_SHA3, 64);
    
    // Start the core
    keccak_start();
    
    // Empty message: set TLR to 0
    reg_write(AXI_FIFO_BASEADDR + FIFO_TLR, 0);
    
    // Wait for completion
    if (!wait_for_done(100000)) {
        printf("ERROR: Keccak core did not complete\n");
        return false;
    }
    
    // Read output
    if (read_hash_output(result, 64) != 0) {
        printf("ERROR: Failed to read hash output\n");
        return false;
    }
    
    // Compare results
    print_hex("Expected", SHA3_512_EMPTY, 64);
    print_hex("Got     ", result, 64);
    
    bool pass = compare_bytes(result, SHA3_512_EMPTY, 64);
    printf("Result: %s\n", pass ? "PASS" : "FAIL");
    
    return pass;
}

/**
 * Test with longer message (200 bytes of zeros)
 */
static bool test_sha3_256_long(void)
{
    printf("\n=== Test: SHA3-256 (200 bytes of zeros) ===\n");
    
    uint8_t result[32];
    
    // Reset FIFO
    fifo_reset();
    
    // Wait for core to be idle
    if (!wait_for_idle(10000)) {
        printf("ERROR: Keccak core not idle\n");
        return false;
    }
    
    // Configure for SHA3-256
    keccak_configure(RATE_SHA3_256, DELIM_SHA3, 32);
    
    // Start the core
    keccak_start();
    
    // Write 200 bytes of zeros (25 x 64-bit words)
    // First 24 full words (192 bytes)
    for (int i = 0; i < 25; i++) {
        fifo_write64(0);
    }
    
    // Set transmit length (200 bytes)
    reg_write(AXI_FIFO_BASEADDR + FIFO_TLR, 200);
    
    // Wait for completion
    if (!wait_for_done(100000)) {
        printf("ERROR: Keccak core did not complete\n");
        return false;
    }
    
    // Read output
    if (read_hash_output(result, 32) != 0) {
        printf("ERROR: Failed to read hash output\n");
        return false;
    }
    
    // Print result (no expected value for this test, just verify we get output)
    print_hex("Got", result, 32);
    
    // Verify we got non-zero output
    bool has_nonzero = false;
    for (int i = 0; i < 32; i++) {
        if (result[i] != 0) {
            has_nonzero = true;
            break;
        }
    }
    
    printf("Result: %s (non-zero output received)\n", has_nonzero ? "PASS" : "FAIL");
    
    return has_nonzero;
}

/**
 * Print core status information
 */
static void print_core_status(void)
{
    printf("\n=== Keccak Core Status ===\n");
    
    uint32_t ctrl = reg_read(KECCAK_CTRL_BASEADDR + KECCAK_AP_CTRL);
    printf("AP_CTRL: 0x%08X\n", ctrl);
    printf("  - START: %d\n", (ctrl >> 0) & 1);
    printf("  - DONE:  %d\n", (ctrl >> 1) & 1);
    printf("  - IDLE:  %d\n", (ctrl >> 2) & 1);
    printf("  - READY: %d\n", (ctrl >> 3) & 1);
    
    printf("\n=== AXI FIFO Status ===\n");
    
    uint32_t fifo_isr = reg_read(AXI_FIFO_BASEADDR + FIFO_ISR);
    uint32_t fifo_tdfv = reg_read(AXI_FIFO_BASEADDR + FIFO_TDFV);
    uint32_t fifo_rdfo = reg_read(AXI_FIFO_BASEADDR + FIFO_RDFO);
    
    printf("ISR:  0x%08X\n", fifo_isr);
    printf("TDFV: %u (TX vacancy)\n", fifo_tdfv);
    printf("RDFO: %u (RX occupancy)\n", fifo_rdfo);
}

/* ==========================================================================
 * Main Entry Point
 * ========================================================================== */

int main(void)
{
    int tests_passed = 0;
    int tests_total = 0;
    
    printf("\n");
    printf("========================================\n");
    printf("  Keccak IP Core Test Application\n");
    printf("========================================\n");
    printf("\n");
    printf("Hardware Configuration:\n");
    printf("  Keccak Control: 0x%08lX\n", KECCAK_CTRL_BASEADDR);
    printf("  AXI FIFO:       0x%08lX\n", AXI_FIFO_BASEADDR);
    printf("\n");
    
    // Print initial status
    print_core_status();
    
    // Initialize: Reset FIFO
    printf("\nInitializing hardware...\n");
    fifo_reset();
    
    // Wait for core to be idle
    if (!wait_for_idle(10000)) {
        printf("ERROR: Keccak core not ready (not idle)\n");
        printf("  Check that the bitstream is loaded correctly.\n");
        return -1;
    }
    printf("Keccak core is ready.\n");
    
    // Run tests
    printf("\n========================================\n");
    printf("  Running Tests\n");
    printf("========================================\n");
    
    // Test 1: SHA3-256 empty
    tests_total++;
    if (test_sha3_256_empty()) {
        tests_passed++;
    }
    
    // Test 2: SHA3-256 "abc"
    tests_total++;
    if (test_sha3_256_abc()) {
        tests_passed++;
    }
    
    // Test 3: SHA3-512 empty
    tests_total++;
    if (test_sha3_512_empty()) {
        tests_passed++;
    }
    
    // Test 4: SHA3-256 long message
    tests_total++;
    if (test_sha3_256_long()) {
        tests_passed++;
    }
    
    // Summary
    printf("\n========================================\n");
    printf("  Test Summary\n");
    printf("========================================\n");
    printf("Passed: %d / %d\n", tests_passed, tests_total);
    printf("Result: %s\n", (tests_passed == tests_total) ? "ALL TESTS PASSED" : "SOME TESTS FAILED");
    printf("\n");
    
    // Print final status
    print_core_status();
    
    return (tests_passed == tests_total) ? 0 : -1;
}
