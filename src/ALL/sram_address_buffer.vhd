-- $Id: $
-- File name:   sram_address_buffer.vhd
-- Created:     11/22/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity sram_address_buffer is
  
  port (
    address_in : in  std_logic_vector(19 downto 0);
    address        : out std_logic_vector(19 downto 0);
    rst_n         : in std_logic;
    clk           : in std_logic;
    ad_load        : in  std_logic);

end sram_address_buffer;


architecture ro_arc of sram_address_buffer is
  signal address_now : std_logic_vector(19 downto 0);
  signal address_next : std_logic_vector(19 downto 0);
  
begin  -- ro_arc
  xiehang: process (clk, rst_n)
  begin  -- process xiehang
    if rst_n = '1' then                 -- asynchronous reset (active low)
                    --1234567890123456789
      address_now <= "00000000000000000000";
    elsif clk'event and clk = '1' then  -- rising clock edge
     
        address_now <= address_next;
    
    end if;
  end process xiehang;
  
  heh: process (address_next,ad_load,address_now,address_in)
  begin  -- process heh
    address_next <= address_now;
    if ad_load = '1' then
      address_next <= address_in;
    end if;
  end process heh;

  address <= address_now;
end ro_arc;

