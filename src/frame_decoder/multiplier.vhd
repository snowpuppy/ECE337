-- $Id: $
-- File name:   multiply.vhdl
-- Created:     11/9/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This is an example multiplication script.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;

entity multiplier is
    port (
    arg11 : in signed(15 downto 0);
    arg12 : in signed(15 downto 0);
    arg21 : in signed(15 downto 0);
    arg22 : in signed(15 downto 0);
    arg31 : in signed(15 downto 0);
    arg32 : in signed(15 downto 0);
    res : out signed(31 downto 0)
    );
end entity multiplier;

architecture multarch of multiplier is
    signal ret1, ret2, ret3 : signed(31 downto 0);
begin
    ret1 <= arg11 * arg12;
    ret2 <= arg11 * arg12;
    ret3 <= arg11 * arg12;
    res <= ret1 + ret2 + ret3;
end architecture multarch;
