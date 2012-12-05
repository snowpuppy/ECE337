-- $Id: $
-- File name:   frame_decoder_2D3_8to24SR.vhd
-- Created:     11/20/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 2D3 block in frame decoder for 8 to 24 bit of shift register


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_2D3_8to24SR is
  port (
    clk                  : in std_logic;
    rst 	         : in std_logic;
    clk_sr               : in std_logic;
    data_in              : in std_logic_vector(7 downto 0);
    rx_data 	         : out std_logic_vector(23 downto 0)
  );
 
end frame_decoder_2D3_8to24SR;

architecture behavioral of frame_decoder_2D3_8to24SR is
  signal present_val : std_logic_vector(23 downto 0);
  signal next_val : std_logic_vector(23 downto 0);
begin  -- behavioral
    regist: process (clk,rst)
  begin  -- process regist
    if (rst = '1') then
      present_val <= (others=>'0');
    elsif (rising_edge(clk))then
      present_val <= next_val;
    end if;
  end process regist;
-------------------------------------------------------------------------------
--next value logic
    next_val <= present_val(15 downto 0) & data_in when (clk_sr = '1') else present_val;
--output logic
    rx_data <= present_val;

end behavioral;



