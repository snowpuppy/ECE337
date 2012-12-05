-- $Id: $
-- File name:   sram_Address_generator.vhd
-- Created:     11/26/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sram_Address_generator is
  
  port (
    update        : in  std_logic;
    rst_n           : in  std_logic;    
    clk           : in  std_logic;
   
    done          : out  std_logic;
    address_input : out std_logic_vector(19 downto 0));

end sram_Address_generator;

architecture ro_ar of sram_Address_generator is
 function UINT_TO_STD_LOGIC( X: INTEGER; NumBits: INTEGER )
      return STD_LOGIC_VECTOR is
        begin
      return std_logic_vector(to_unsigned(X, NumBits));
      end;
      
      --0        1
      --1234567890123456789
      --1010100011000000000
signal state,nextstate : std_logic_vector(18 downto 0);

  

  
begin  -- ro_ar
          
     state_next: process (clk, rst_n)
         begin  -- process state_next
           if  rst_n = '1' then          -- asynchronous reset (active low)
                      --0        1
                      --1234567890123456789
                      --1010100011000000000
              state <= "0000000000000000000";       
           elsif clk'event and clk = '1' then  -- rising clock edge
             state <= nextstate ;
           end if;
         end process state_next;

     nextstate_logic: process (update,state)
         begin  -- process nextstate_logic
           nextstate <= state;
           --done <= '0';
           if update = '1' then

             
             if state =  "1010100011000000000" then
               nextstate <= "0000000000000000001";
               --done <= '1';
              
             else
               nextstate <= state + 1;
               --done <= '0';
             end if;


             
           end if;
         end process nextstate_logic;    

    out_put_logic: process (state)
    begin  -- process out_put_logic
      if state ="1010100011000000000"  then
        address_input <= '0'&"0000000000000000000";
      else
         address_input <= '0'&state;
      end if;
     
      
      done <= '0';
       if state = "1010100011000000000"  then
         
          done <= '1';
         
       end if;  
    end process out_put_logic;

         

end ro_ar;


