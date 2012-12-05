-- $Id: $
-- File name:   frame_decoder_register_block.vhd
-- Created:     11/20/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: register buffer input and selection block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_register_block is 
  port ( 
    clk        : in std_logic;
    rst        : in std_logic;
    data_ready : in std_logic;
    data_in    : in std_logic_vector(7 downto 0);
    data_out   : out std_logic_vector(7 downto 0)
  );
end frame_decoder_register_block;

architecture behavioral of frame_decoder_register_block is
  signal data_buffer : std_logic_vector(7 downto 0);
begin 
  regist: process (clk,rst,data_ready)
 begin
    if (rst = '1') then
      data_buffer <= (others => '0');
    elsif (clk'event) and (clk = '1') then
      data_out <= data_buffer;
      if (data_ready = '1') then
        data_buffer <= data_in;
      end if;
   end if;
 end process regist;
------------------------------------------------------------
end behavioral;
