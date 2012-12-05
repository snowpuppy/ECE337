-- $Id: $
-- File name:   hdmi_system_pulse_generator.vhd
-- Created:     12/2/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: pulse generator for system


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity hdmi_system_pulse_generator is
  port (
    clk : in std_logic;
    rst : in std_logic;
    data_ready : in std_logic;  -- from UART
    rising_edge_found : out std_logic  --send to both frame decoder and controller
    );
end hdmi_system_pulse_generator;

architecture behavioral of hdmi_system_pulse_generator is
   signal Q_int2	: std_logic;
   signal Q_int1	: std_logic;
   signal Q_int3	: std_logic;
begin  -- behavioral
  REGIST: process(clk,rst,data_ready,Q_int2,Q_int1)
  begin
    if (rst = '1') then
      Q_int3 <= '1';
      Q_int2 <= '1';
      Q_int1 <= '1';
    elsif (rising_edge(clk))then
      Q_int3 <= Q_int2;
      Q_int2 <= Q_int1;
      Q_int1 <= data_ready;
  end if;
end process;


  --output logic
  rising_edge_found  <= (Q_int2) and (not(Q_int3));

end behavioral;
