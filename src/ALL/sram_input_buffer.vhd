-- $Id: $
-- File name:   sram_input_buffer.vhd
-- Created:     11/25/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity sram_input_buffer is
  
  port (
    data_two : in  std_logic_vector(31 downto 0);
    data_one : in  std_logic_vector(31 downto 0);
    
    data_out : out std_logic_vector(23 downto 0);
    rst_n    : in  std_logic;
    clk      : in   std_logic;
    sram_sel_out : in  std_logic;
    out_en   : in  std_logic);

end sram_input_buffer;


architecture ro_ar of sram_input_buffer is
   signal data_now : std_logic_vector(23 downto 0);
   signal data_next : std_logic_vector(23 downto 0);
  
begin  -- ro-ar
    rst_me: process (clk, rst_n)
    begin  -- process rst_me
      if rst_n = '1' then               -- asynchronous reset (active low)
              --    012345678901234567890123
        data_now <="000000000000000000000000";
      elsif clk'event and clk = '1' then  -- rising clock edge
               --   012345678901234567890123
        data_now <= data_next;
      end if;
    end process rst_me;

    load_logic: process (sram_sel_out,out_en,data_one,data_two,data_now)
    begin  -- process load_logic
      data_next <= data_now;
      if sram_sel_out = '1' then            -- read sram 1
        
        if out_en = '1' then
          data_next <= data_two(23 downto 0);
        end if;
       
      else
        if out_en = '0' then
          data_next <= data_one(23 downto 0);
        end if;
         
      end if;
        
    end process load_logic;
     data_out <= data_now;
end ro_ar;
