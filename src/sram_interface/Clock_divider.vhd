-- $Id: $
-- File name:   Clock_divider.vhd
-- Created:     11/21/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: ./


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity Clock_divider is
  
  port (
    clk      : in  std_logic;
    rst_n    : in  std_logic;
    clock_me : out std_logic);

end Clock_divider;

architecture re_f of Clock_divider is
 signal tmp_clk : std_logic := '0';
begin  -- re_f
  clk_divdiv: process (clk, rst_n)
  begin  -- process clk_divdiv
    if rst_n = '0' then                 -- asynchronous reset (active low)
      tmp_clk <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
      tmp_clk <= not tmp_clk;
    end if;
  end process clk_divdiv;
  clock_me <= tmp_clk;

end re_f;
