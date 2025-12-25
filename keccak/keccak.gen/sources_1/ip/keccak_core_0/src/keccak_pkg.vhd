-- ============================================================================
-- Keccak Package
-- Contains types, constants, and helper functions for Keccak-f[1600]
-- ============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package keccak_pkg is
    -- Lane type (64-bit)
    subtype lane_t is std_logic_vector(63 downto 0);
    
    -- State array: 5x5 lanes = 25 lanes of 64 bits = 1600 bits
    type state_t is array (0 to 24) of lane_t;
    
    -- 5-element lane array for theta step (C and D arrays)
    type lane5_t is array (0 to 4) of lane_t;
    
    -- Round constants for iota step (24 rounds)
    type rc_array_t is array (0 to 23) of lane_t;
    constant RC : rc_array_t := (
        x"0000000000000001", x"0000000000008082", x"800000000000808A", x"8000000080008000",
        x"000000000000808B", x"0000000080000001", x"8000000080008081", x"8000000000008009",
        x"000000000000008A", x"0000000000000088", x"0000000080008009", x"000000008000000A",
        x"000000008000808B", x"800000000000008B", x"8000000000008089", x"8000000000008003",
        x"8000000000008002", x"8000000000000080", x"000000000000800A", x"800000008000000A",
        x"8000000080008081", x"8000000000008080", x"0000000080000001", x"8000000080008008"
    );
    
    -- Rotation offsets for rho step (indexed [x][y])
    -- Note: state[x + 5*y] = state[x,y] in standard notation
    type rho_offsets_row_t is array (0 to 4) of natural range 0 to 63;
    type rho_offsets_t is array (0 to 4) of rho_offsets_row_t;
    constant RHO_OFFSETS : rho_offsets_t := (
        (0,  36,  3, 41, 18),   -- x=0
        (1,  44, 10, 45,  2),   -- x=1
        (62,  6, 43, 15, 61),   -- x=2
        (28, 55, 25, 21, 56),   -- x=3
        (27, 20, 39,  8, 14)    -- x=4
    );
    
    -- Helper function: rotate left
    function rol64(x : lane_t; n : natural) return lane_t;
    
    -- Index conversion: (x, y) -> linear index
    function idx(x, y : natural) return natural;
    
end package keccak_pkg;

package body keccak_pkg is

    function rol64(x : lane_t; n : natural) return lane_t is
        variable result : lane_t;
        variable shift : natural;
    begin
        shift := n mod 64;
        if shift = 0 then
            result := x;
        else
            result := x(63 - shift downto 0) & x(63 downto 64 - shift);
        end if;
        return result;
    end function;
    
    function idx(x, y : natural) return natural is
    begin
        return (x mod 5) + 5 * (y mod 5);
    end function;

end package body keccak_pkg;
