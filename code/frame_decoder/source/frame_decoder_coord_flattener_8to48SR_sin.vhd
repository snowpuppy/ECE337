-- $Id: $
-- File name:   frame_decoder_coord_flattener_8to48SR_sin.vhd
-- Created:     11/18/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: frame decoder coordinate flattener sin part
-- 


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.all;
entity frame_decoder_coord_flattener_8to48SR_sin is
  port (
    clk        : in std_logic;
    rst        : in std_logic;
    data_in    : in std_logic_vector(7 downto 0);
    clk_sr     : in std_logic_vector(3 downto 0);
    rx_enable  : in std_logic_vector(3 downto 0);
    rx_data    : out signed(47 downto 0)
  );
end frame_decoder_coord_flattener_8to48SR_sin;

architecture behavioral of frame_decoder_coord_flattener_8to48SR_sin is
  signal present_val : std_logic_vector(47 downto 0);
  signal next_val : std_logic_vector(47 downto 0);
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
    next_val <= present_val(39 downto 0) & data_in   when (clk_sr = "1000") and (rx_enable = "1000") else present_val;
--output logic
    rx_data <= signed(present_val);

end behavioral;

    

