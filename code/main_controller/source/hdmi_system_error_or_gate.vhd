-- $Id: $
-- File name:   hdmi_system_error_or_gate.vhd
-- Created:     12/2/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: error or gate to output to outside of asic


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


entity hdmi_system_error_or_gate is
  port (
    system_framing_error : in std_logic;
    system_overrun_error : in std_logic;
    reset_error          : in std_logic;
    system_in_error      : out std_logic
   );

end hdmi_system_error_or_gate;

architecture struct of hdmi_system_error_or_gate  is
begin
  system_in_error <= '1' when (system_framing_error = '1') or (system_overrun_error = '1') or (reset_error = '1') else '0';
end struct;

 


