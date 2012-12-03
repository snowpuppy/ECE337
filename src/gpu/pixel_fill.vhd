-- $Id: $
-- File name:   pixel_fill.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This block counts up to a given value specified by the user
-- to fill a color or multiple colors into a given region of the screen.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity pixel_fill is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        strobe_fill         : in    std_logic;
        new_data            : in    std_logic;
        xi                  : in    std_logic_vector(15 downto 0);
        yi                  : in    std_logic_vector(15 downto 0);
        w                   : in    std_logic_vector(15 downto 0);
        h                   : in    std_logic_vector(15 downto 0);
        done2               : out   std_logic;
        x                   : out   std_logic_vector(15 downto 0);
        y                   : out   std_logic_vector(15 downto 0)
        );
end entity pixel_fill;

architecture pixel_fill_arch of pixel_fill is
    signal countx_reg, county_reg : std_logic_vector(15 downto 0);
    signal countx_nxt, county_nxt : std_logic_vector(15 downto 0);
    signal y_pulse : std_logic;
begin
  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
        countx_reg <= (others => '0');
        county_reg <= (others => '0');
    elsif rising_edge(clk) then  -- check clock edge
        countx_reg <= countx_nxt;
        county_reg <= county_nxt;
    end if;
  end process reg;

  countxNext:process(countx_reg, xi, new_data, strobe_fill)
  begin
    countx_nxt <= countx_reg;
    if (new_data = '1') then
        countx_nxt <= xi;
    elsif strobe_fill = '1' then
        countx_nxt <= countx_reg + 1;
    elsif y_pulse = '1' then
        countx_nxt <= (others => '0');
    end if;
  end process countxNext;

  countyNext:process(county_reg)
  begin
    county_nxt <= county_reg;
    if new_data = '1' then
        county_nxt <= yi;
    elsif y_pulse = '1' then
        county_nxt <= county_reg + 1;
    end if;
  end process countyNext;

  x <= countx_reg;
  y <= county_reg;

  done2 <= '1' when county_reg = h else '0';
  y_pulse <= '1' when countx_reg = w else '0';

end architecture pixel_fill_arch;
