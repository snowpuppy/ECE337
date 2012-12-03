-- $Id: $
-- File name:   coord_to_address.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This block converts a given coordinate to an address that
-- can be used by the SRAM interface. It also includes a validity check for the input
-- coordinates making sure that no invalid addresses are passed to the SRAM interface.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity coord_to_address is
    port (
        fill_coord         : in    std_logic_vector(31 downto 0);
        line_coord         : in    std_logic_vector(31 downto 0);
        mode               : in    std_logic;
        valid_address      : out   std_logic; -- logic to make sure the address is actually valid!
        address            : out   std_logic_vector(19 downto 0)
        );
end entity coord_to_address;

architecture coord_to_address_arch of coord_to_address is
    signal x_fill, y_fill, x_line, y_line : std_logic_vector(15 downto 0);
    signal x_fill_mult_y_fill, x_line_mult_y_line : std_logic_vector(31 downto 0);
    signal x_fill_valid, y_fill_valid : std_logic;
    signal x_line_valid, y_line_valid : std_logic;
begin
    x_fill <= fill_coord(31 downto 16);
    y_fill <= fill_coord(15 downto 0);
    x_line <= line_coord(31 downto 16);
    y_line <= line_coord(15 downto 0);

    -- calculate validity of address.
    x_fill_valid <= '1' when signed(x_fill) >= x"0000" and signed(x_fill) <= x"02D0" else '0';
    y_fill_valid <= '1' when signed(y_fill) >= x"0000" and signed(y_fill) <= x"01E0" else '0';
    x_line_valid <= '1' when signed(x_line) >= x"0000" and signed(x_line) <= x"02D0" else '0';
    y_line_valid <= '1' when signed(y_line) >= x"0000" and signed(y_line) <= x"01E0" else '0';

    x_line_valid <= (x_fill_valid and y_fill_valid) when mode = '1' else (x_line_valid and y_line_valid);

    -- calculate address
    -- mode = 1 for fill and mode = 0 for line
    x_fill_mult_y_fill <= std_logic_vector( (signed(y_fill)*480 + signed(x_fill)) );
    x_line_mult_y_line <= std_logic_vector( (signed(y_line)*480 + signed(x_line)) );

    address <= x_fill_mult_y_fill(19 downto 0) when mode = '1' else x_line_mult_y_line(19 downto 0);

end architecture coord_to_address_arch;
