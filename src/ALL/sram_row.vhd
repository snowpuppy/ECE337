-- $Id: $
-- File name:   sram_row.vhd
-- Created:     11/10/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: sram_row


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity sram_row is
  
  port (
    TMDS_CLK : in  std_logic;
    one_sram_row  : in  std_logic;
    rst_n    : in  std_logic;
    sram_row_num      : out std_logic_vector(9 downto 0));

end sram_row;


architecture ro_arc of sram_row is
 function UINT_TO_STD_LOGIC( X: INTEGER; NumBits: INTEGER )
      return STD_LOGIC_VECTOR is
        begin
      return std_logic_vector(to_unsigned(X, NumBits));
      end;

 signal state,nextstate : std_logic_vector(9 downto 0) ;
 signal past_one_sram_row : std_logic;
 signal now_one_sram_row : std_logic;     
                                           


  
begin  -- ro_arc

  
     state_next: process (TMDS_CLK, rst_n)
     begin  -- process state_next
       if rst_n = '1'  then              -- asynchronous reset (active low)
         state <= "0000000000";
       
       elsif TMDS_CLK'event and TMDS_CLK = '1' then  -- rising clock edge
         state <= nextstate;
       end if;
     end process state_next;
     
  nextstate_logic: process (one_sram_row,state)
  begin  -- process nextstate_logic
    past_one_sram_row <= '0';
    past_one_sram_row <= '0';
    
    
     if  one_sram_row = '1' then
       --nextstate <= state+1;
       if state = "1000001100" then
         nextstate <= "0000000000";
       else
         nextstate <= state + 1;
       end if;
     else
      
       nextstate <= state;
       
     end if;
    
  end process nextstate_logic;


    


-- purpose: output logic
-- type   : combinational
-- inputs : state
-- outputs: 
out_put_logic: process (state)
begin  -- process out_put_logic
    sram_row_num <= state;


    
end process out_put_logic;

     
end ro_arc;

