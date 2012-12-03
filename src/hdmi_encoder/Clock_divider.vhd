
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity Clock_divider is
  
  port (
    clk      : in  std_logic;
    rst_n    : in  std_logic;
    clock_me : out std_logic);

end Clock_divider;

architecture clock_divider_struct of Clock_divider is
 signal tmp_clk: std_logic;
begin  -- re_f
  clk_divdiv: process (clk,rst_n)
  begin  -- process clk_divdiv
   if rst_n = '0' then  -- rising clock edge
     tmp_clk <= '0';
   elsif (rising_edge(clk)) then
  tmp_clk <= not tmp_clk;
    end if;
  end process clk_divdiv;
  clock_me <= tmp_clk;

end clock_divider_struct;
