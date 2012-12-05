
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TMDSCLK is
  
  port (
    clk:       in std_logic;
    rst_n    : in  std_logic;
    tx_load  : in  std_logic;
    TMDS_enable: out std_logic;
    TMDS_CLK : out std_logic);

end TMDSCLK;


architecture struct_tmds of TMDSCLK is
 type statetype is (idle,clkone1,clkone2,clkone3,clkone4,clkone5,clkzero1,clkzero2,clkzero3,clkzero4,clkzero5);
 signal state,nextstate: statetype;
 signal tmp_clk,rTMDS_enable : std_logic;
begin 
-----------------------------------------------
tmds_reg: process(clk,rst_n)
 begin
   if rst_n = '1' then
     state <= idle;
     TMDS_CLK <= '0';
     TMDS_enable <= '0';
  elsif(rising_edge(clk)) then
     state <= nextstate;
     TMDS_CLK <= tmp_clk;
     TMDS_enable <= rTMDS_enable;
   end if;
end process;
------------------------------------------------
nextstate_logic: process(state,tx_load)
begin
  case state is
  when idle =>
    if (tx_load = '1') then
      nextstate <= clkone2;
      rTMDS_enable <= '1';
      tmp_clk <= '1';
    else
      nextstate <= idle;
      tmp_clk <= '0';
      rTMDS_enable <= '0';
    end if;
    
  when clkone1 =>
      nextstate <= clkone2;
      tmp_clk <= '1';
      rTMDS_enable <= '1';
      
  when clkone2 =>
      nextstate <= clkone3;
      tmp_clk <= '1';
      rTMDS_enable <= '0';
      
  when clkone3 =>
      nextstate <= clkone4;
      tmp_clk <= '1';
      rTMDS_enable <= '0';
      
  when clkone4 =>
      nextstate <= clkone5;      
      tmp_clk <= '1';  
      rTMDS_enable <= '0';
  
  when clkone5 =>
      nextstate <= clkzero1;      
      tmp_clk <= '1';  
      rTMDS_enable <= '0';

  when clkzero1 =>
      nextstate <= clkzero2;
      tmp_clk <= '0'; 
      rTMDS_enable <= '0';

  when clkzero2 =>
      nextstate <= clkzero3;
      tmp_clk <= '0'; 
      rTMDS_enable <= '0';
      
  when clkzero3 =>
      nextstate <= clkzero4;
      tmp_clk <= '0'; 
      rTMDS_enable <= '0';
      
  when clkzero4 =>
      nextstate <= clkzero5;
      tmp_clk <= '0'; 
      rTMDS_enable <= '0';
      
  when clkzero5 =>
      nextstate <= clkone1;
      tmp_clk <= '0'; 
      rTMDS_enable <= '0';
     
  when others =>
      nextstate <= idle;
      tmp_clk <= '1'; 
      rTMDS_enable <= '0';
    
  end case;
end process;

end struct_tmds;
  
  
  
   
   
  
