-- $Id: $
-- File name:   hdmi_system_main_controller_upper_block.vhd
-- Created:     12/2/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: upper block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.all;


entity hdmi_system_main_controller_upper_block is
  port ( 
    clk              : in std_logic;
    rst              : in std_logic;
    data_ready       : in std_logic;
    frame_done       : in std_logic;
    computation_done : in std_logic;
    buffer_switch    : in std_logic;
    write_done       : in std_logic;
    system_framing_error : in std_logic;
    system_overrun_error : in std_logic;
    reset_error          : in std_logic;
    system_in_error      : out std_logic;  -- goes out of HDMI system
    busy 	           : out std_logic;  -- goes out of HDMI and frame deocder
    read_frame       : out std_logic;  
    switch_buffer    : out std_logic  -- SRAM
   );

end hdmi_system_main_controller_upper_block;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_UNSIGNED.all;



architecture struct of  hdmi_system_main_controller_upper_block is
  signal data_received : std_logic;

  component hdmi_system_pulse_generator
    port (
      clk : in std_logic;
      rst : in std_logic;
      data_ready : in std_logic;  -- from UART
      rising_edge_found : out std_logic);  --send to both frame decoder and controller
    end component;
------------------------------------------------------------------

   component hdmi_system_main_controller
     port (
       clk 	     : in std_logic;
       rst 	     : in std_logic;
       data_received    : in std_logic;  -- from the rising edge found of pulse generator
       frame_done       : in std_logic;
       computation_done : in std_logic;
       buffer_switch    : in std_logic;
       write_done       : in std_logic;
       busy 	     : out std_logic;
       read_frame       : out std_logic;
       switch_buffer    : out std_logic);
   end component;
------------------------------------------------------------------
   component hdmi_system_error_or_gate
  port (
    system_framing_error : in std_logic;
    system_overrun_error : in std_logic;
    reset_error          : in std_logic;
    system_in_error      : out std_logic);
 end component;
------------------------------------------------------------------
begin

  U_0: hdmi_system_pulse_generator
    port map (
      clk => clk,
      rst => rst,
      data_ready => data_ready,
      rising_edge_found => data_received);
------------------------------------------------------------------

   U_1: hdmi_system_main_controller
     port map(
       clk 	     => clk,
       rst 	     => rst,
       data_received => data_received,
       frame_done       => frame_done,
       computation_done => computation_done,
       buffer_switch    => buffer_switch,
       write_done       => write_done,
       busy 	        => busy,
       read_frame       => read_frame,
       switch_buffer    => switch_buffer);
------------------------------------------------------------------
 U_2: hdmi_system_error_or_gate
  port map (
    system_framing_error => system_framing_error,
    system_overrun_error => system_overrun_error,
    reset_error          => reset_error,
    system_in_error      => system_in_error);
end struct;

