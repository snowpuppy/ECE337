-- $Id: $
-- File name:   data_select.vhd
-- Created:     11/25/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: fdf.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity data_select is
  
  port (
    data       : in  std_logic_vector(31 downto 0);
    data_sel_w : in  std_logic;
    clk        : in  std_logic;
    rst_n      : in  std_logic;
    SRAM1_data : out std_logic_vector(31 downto 0);
    SRAM2_data : out std_logic_vector(31 downto 0));

end data_select;

architecture ar_sel of data_select is
    --signal data_now : std_logic_vector(31 downto 0);
    --signal data_next : std_logic_vector(31 downto 0);


    
begin  -- ar_sel
    rst_me: process (clk, rst_n)
    begin  -- process rst_me
      if rst_n = '0' then               -- asynchronous reset (active low)
        --           0        1         2         3
        --           12345678901234567890123456789012
        SRAM1_data <= "00000000000000000000000000000000";
          --           0        1         2         3
          --           12345678901234567890123456789012
        SRAM2_data <= "00000000000000000000000000000000";
        
      elsif clk'event and clk = '1' then  -- rising clock edge
       
           if data_sel_w = '0' then
               SRAM1_data <= data;
                SRAM2_data <= "00000000000000000000000000000000";
           else
                SRAM1_data <= "00000000000000000000000000000000";
                 SRAM2_data <= data;
           end if;

        
      end if;
    end process rst_me;

 
    

end ar_sel;

