-- $Id: $
-- File name:   frame_decoder_2D12_timer.vhd
-- Created:     11/20/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 2D1/2 frame decoder's timer


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_ARITH.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;

entity frame_decoder_2D12_timer is
  port (
    clk               : in std_logic;
    rst 	      : in std_logic;
    restart 	      : in std_logic;
    clk_up            : in std_logic;
    six_assert        : out std_logic
  );
end frame_decoder_2D12_timer;

architecture behavioral of frame_decoder_2D12_timer is 
  signal count_byte, next_count_byte : std_logic_vector(2 downto 0);
begin

  regist: process (rst,clk)
    begin
      if (rst = '1') then
        count_byte <= (others => '0');
      elsif (rising_edge(clk)) then
        count_byte <= next_count_byte;
      end if;
    end process regist;
--------------------------------------------------------------------
   nextstatelogic: process (count_byte,restart,clk_up) 
      begin
        next_count_byte <= count_byte;
	
	if (restart = '1') then
	  next_count_byte <= "000";
        elsif (clk_up = '1') then
          next_count_byte <= count_byte + 1;
        end if;

   end process nextstatelogic;
--------------------------------------------------------------------
 outputlogic : process(count_byte)
    begin
     if (count_byte = "110") then -- count to 6
       six_assert <= '1';
     else
       six_assert <= '0';
     end if;

   end process outputlogic;
end behavioral;
