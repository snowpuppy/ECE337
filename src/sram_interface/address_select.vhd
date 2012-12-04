-- $Id: $
-- File name:   address_select.vhd
-- Created:     11/26/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity address_select is
  
  port (
    address       : in std_logic_vector(19 downto 0);
    ad_r          : in std_logic_vector(19 downto 0);
    ad_sel_w      : in std_logic;
    clk           : in std_logic;
    rst_n         : in std_logic;
    SRAM1_address : out std_logic_vector(19 downto 0);
    SRAM2_address : out std_logic_vector(19 downto 0)

    );

end address_select;

architecture ar_sel of address_select is

begin  -- ar_sel
  rst_me: process (clk, rst_n)
  begin  -- process rst_me
    if rst_n = '0' then                 -- asynchronous reset (active low)
      --                01234567890123456789
      SRAM1_address <= "00000000000000000000";
      SRAM2_address <= "00000000000000000000";
      
    elsif clk'event and clk = '1' then  -- rising clock edge
      if ad_sel_w = '1' then
         SRAM1_address <= ad_r;
         SRAM2_address <= address;
      else
         SRAM1_address <= address;
         SRAM2_address <= ad_r;
      end if;
    end if;
  end process rst_me;

  

end ar_sel;
