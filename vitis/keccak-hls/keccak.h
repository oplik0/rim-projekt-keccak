/*
 * Keccak HLS Implementation Header
 * 
 * This module implements the Keccak sponge construction for SHA-3 and SHAKE
 * variants using AXI4-Stream interfaces for high-throughput operation.
 */

#pragma once

#include "ap_axi_sdata.h"
#include "ap_int.h"
#include "hls_stream.h"

// ============================================================================
// Configuration Constants
// ============================================================================

// Keccak state size: 25 lanes * 64 bits = 1600 bits
constexpr int KECCAK_STATE_SIZE = 25;
constexpr int KECCAK_ROUNDS = 24;

// Data width for streaming interface (64-bit lanes match Keccak-f[1600])
constexpr int DATA_WIDTH = 64;

// Rate constants (in bytes) for different SHA-3/SHAKE variants
// rate = 1600 - 2*security_level for SHA-3
// SHA3-224: rate = 1152 bits = 144 bytes
// SHA3-256: rate = 1088 bits = 136 bytes  
// SHA3-384: rate = 832 bits  = 104 bytes
// SHA3-512: rate = 576 bits  = 72 bytes
// SHAKE128: rate = 1344 bits = 168 bytes
// SHAKE256: rate = 1088 bits = 136 bytes

constexpr int RATE_SHA3_224 = 144;
constexpr int RATE_SHA3_256 = 136;
constexpr int RATE_SHA3_384 = 104;
constexpr int RATE_SHA3_512 = 72;
constexpr int RATE_SHAKE128 = 168;
constexpr int RATE_SHAKE256 = 136;

// Domain separation delimiters
const ap_uint<8> DELIM_SHA3 = 0x06;   // SHA-3: 01 || 1
const ap_uint<8> DELIM_SHAKE = 0x1F;  // SHAKE: 1111 || 1

// Maximum rate in 64-bit words (for SHA3-224 / SHAKE128)
constexpr int MAX_RATE_WORDS = 21;  // 168 bytes / 8

// ============================================================================
// AXI4-Stream Packet Types
// ============================================================================

// Input/Output packet: 64-bit data with TLAST signal
// Using ap_axiu for unsigned data with no side-channels except LAST
typedef ap_axiu<DATA_WIDTH, 0, 0, 0> axis_pkt_t;

// ============================================================================
// Keccak Round Constants
// ============================================================================

// Round constants for iota step
static const ap_uint<64> RC_TABLE[KECCAK_ROUNDS] = {
    0x0000000000000001ULL, 0x0000000000008082ULL, 0x800000000000808aULL, 0x8000000080008000ULL,
    0x000000000000808bULL, 0x0000000080000001ULL, 0x8000000080008081ULL, 0x8000000000008009ULL,
    0x000000000000008aULL, 0x0000000000000088ULL, 0x0000000080008009ULL, 0x000000008000000aULL,
    0x000000008000808bULL, 0x800000000000008bULL, 0x8000000000008089ULL, 0x8000000000008003ULL,
    0x8000000000008002ULL, 0x8000000000000080ULL, 0x000000000000800aULL, 0x800000008000000aULL,
    0x8000000080008081ULL, 0x8000000000008080ULL, 0x0000000080000001ULL, 0x8000000080008008ULL
};

// ============================================================================
// Mode Enumeration for SHA-3/SHAKE Variants
// ============================================================================

// Mode selection for the Keccak core
// Encoded as: [7:4] = output length in 8-byte units (0 for XOF), [3:0] = rate in 8-byte units offset
typedef ap_uint<8> keccak_mode_t;

const keccak_mode_t MODE_SHA3_224 = 0x00;  // Configured via registers
const keccak_mode_t MODE_SHA3_256 = 0x01;
const keccak_mode_t MODE_SHA3_384 = 0x02;
const keccak_mode_t MODE_SHA3_512 = 0x03;
const keccak_mode_t MODE_SHAKE128 = 0x04;
const keccak_mode_t MODE_SHAKE256 = 0x05;

// ============================================================================
// Top-Level Function Declaration
// ============================================================================

/**
 * Keccak HLS Top-Level Function
 * 
 * This function implements a streaming Keccak hash computation with:
 * - AXI4-Stream input for message data (64-bit words, TLAST marks end of message)
 * - AXI4-Stream output for hash digest (64-bit words, TLAST marks end of output)
 * - AXI-Lite control interface for configuration
 * 
 * The input stream is TLAST-driven: keep sending data packets until the final
 * packet which should have TLAST=1. For empty messages, send a single packet
 * with TLAST=1 and TKEEP=0, or simply don't send any packets (the module will
 * detect empty stream and proceed to padding).
 * 
 * @param input_stream  Input AXI4-Stream for message bytes (packed as 64-bit words)
 * @param output_stream Output AXI4-Stream for hash digest
 * @param rate_bytes    Rate parameter in bytes (depends on variant)
 * @param delimiter     Domain separation delimiter (0x06 for SHA-3, 0x1F for SHAKE)
 * @param output_len    Desired output length in bytes
 */
void keccak_top(
    hls::stream<axis_pkt_t>& input_stream,
    hls::stream<axis_pkt_t>& output_stream,
    ap_uint<8> rate_bytes,
    ap_uint<8> delimiter,
    ap_uint<16> output_len
);

// ============================================================================
// Internal Function Declarations (for potential manual optimization)
// ============================================================================

/**
 * Keccak-f[1600] permutation function
 * Performs 24 rounds of the Keccak permutation
 * 
 * @param state 25 x 64-bit state array (modified in place)
 */
void keccak_f1600(ap_uint<64> state[KECCAK_STATE_SIZE]);

