-- $Id: $
-- File name:   sram_TMDS_clk.vhd
-- Created:     11/21/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: ldjfadf


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


entity sram_TMDS_clk is
  
  port (
    clock_me : in  std_logic;
    rst_n    : in  std_logic;
    TMDS_CLK : out std_logic);

end sram_TMDS_clk;


architecture re_f of sram_TMDS_clk is
 signal tmp_clk : std_logic := '0';
begin  -- re_f
   clk_divdiv: process (clock_me, rst_n)
  begin  -- process clk_divdiv
    if rst_n = '1' then                 -- asynchronous reset (active low)
      tmp_clk <= '0';
    elsif clock_me'event and clock_me = '1' then  -- rising clock edge
      tmp_clk <= not tmp_clk;
    end if;
  end process clk_divdiv;
  TMDS_CLK <= tmp_clk;
  

end re_f;
