-- $Id: $
-- File name:   frame_decoder_48to756_block_shift_register.vhd
-- Created:     11/23/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 48 to 756 block shift register


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_48to756_block_shift_register is
  port (
    clk              : in std_logic;
    rst              : in std_logic;
    clk_in_sr        : in std_logic;
    control          : in std_logic_vector(2 downto 0);
    threed_data      : in std_logic_vector(47 downto 0);
    twodonetwo_data  : in std_logic_vector(47 downto 0);
    rx_data          : out std_logic_vector(767 downto 0)
  );
end frame_decoder_48to756_block_shift_register;

architecture behavioral of frame_decoder_48to756_block_shift_register is
  signal present_val : std_logic_vector(767 downto 0);
  signal next_val : std_logic_vector(767 downto 0);
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
    next_val <= present_val(719 downto 0) & threed_data      when (clk_in_sr = '1') and (control = "001") else
                present_val(719 downto 0) & twodonetwo_data  when (clk_in_sr = '1') and (control = "010") else 
                present_val(719 downto 0) & twodonetwo_data  when (clk_in_sr = '1') and (control = "011") else 
                present_val;
--output logic
    rx_data <= present_val;

end behavioral;

    
