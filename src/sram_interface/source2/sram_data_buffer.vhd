-- $Id: $
-- File name:   sram_data_buffer.vhd
-- Created:     11/22/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity sram_data_buffer is
  
  port (
    rst_n     : in  std_logic;
    clk       : in  std_logic;
    data_in   : in  std_logic_vector(23 downto 0);
    data_load : in  std_logic;
    data      : out std_logic_vector(31 downto 0));

end sram_data_buffer;

architecture ro_arc of sram_data_buffer is
     signal data_now : std_logic_vector(31 downto 0);
     signal data_next : std_logic_vector(31 downto 0);
  
begin  -- ro_arc
     rst_me: process (clk, rst_n)
     begin  -- process rst_me
       if rst_n = '0' then              -- asynchronous reset (active low)
        --                "01234567890123456789012345678901"
         data_now <="00000000000000000000000000000000";
       elsif clk'event and clk = '1' then  -- rising clock edge
         data_now <= data_next;
       end if;
     end process rst_me;


     load_logic: process (data_in,data_next,data_load,data_now)
     begin  -- process load_logic
       data_next <= data_now;
       if data_load = '1' then
         data_next(23 downto 0) <= data_in;
         --                        "01234567"
         data_next(31 downto 24)<= "00000000";
       end if;
     end process load_logic;
     
    data <= data_now;
end ro_arc;
