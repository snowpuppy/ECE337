
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TMDSCLK is
  
  port (
    clock_me : in  std_logic;
    rst_n    : in  std_logic;
    tx_load  : in  std_logic;
    TMDS_CLK : out std_logic);

end TMDSCLK;


architecture struct_tmds of TMDSCLK is
 type statetype is (idle,clkone1,clkone2,clkone3,clkone4,clkzero);
 signal state,nextstate: statetype;
 signal tmp_clk : std_logic;
begin 
-----------------------------------------------
tmds_reg: process(clock_me,rst_n,tx_load)
 begin
   if rst_n = '0' then
     state <= idle;
     TMDS_CLK <= '0';
  elsif(clock_me'event and clock_me = '1') then
     state <= nextstate;
     TMDS_CLK <= tmp_clk;
  end if;
end process;
------------------------------------------------
nextstate_logic: process(state,tx_load)
begin
  case state is
  when idle =>
    if (tx_load = '1') then
      nextstate <= clkone1;
      tmp_clk<= '1';
    else
      nextstate <= idle;
      tmp_clk <= '0';
    end if;
    
  when clkone1 =>
      nextstate <= clkone2;
      tmp_clk <= '1';
      
  when clkone2 =>
      nextstate <= clkone3;
      tmp_clk <= '1';
      
  when clkone3 =>
      nextstate <= clkone4;
      tmp_clk <= '1';
      
  when clkone4 =>
      nextstate <= clkzero;
      tmp_clk <= '1';
      
  when clkzero =>
    if (tx_load = '1') then 
      nextstate <= clkone1;
      tmp_clk <= '1';
    else
      nextstate <= clkzero;
      tmp_clk <= '0';
    end if;
    
  when others =>
      tmp_clk <= '0';
      nextstate <= idle;
    
  end case;
end process;
------------------------------------------

end struct_tmds;
  

  
  
   
   
  