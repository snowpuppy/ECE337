-- $Id: $
-- File name:   tb_hdmi_system_main_controller_upper_block.vhd
-- Created:     12/2/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_hdmi_system_main_controller_upper_block is
  generic (Period : Time := 4 ns);
end tb_hdmi_system_main_controller_upper_block;

architecture TEST of tb_hdmi_system_main_controller_upper_block is

  function UINT_TO_STDV( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_unsigned(X, NumBits));
  end;

  function STDV_TO_UINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(unsigned(x));
  end;

  component hdmi_system_main_controller_upper_block
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         data_ready : in std_logic;
         frame_done : in std_logic;
         computation_done : in std_logic;
         buffer_switch : in std_logic;
         write_done : in std_logic;
         busy : out std_logic;
         read_frame : out std_logic;
         switch_buffer : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal data_ready : std_logic;
  signal frame_done : std_logic;
  signal computation_done : std_logic;
  signal buffer_switch : std_logic;
  signal write_done : std_logic;
  signal busy : std_logic;
  signal read_frame : std_logic;
  signal switch_buffer : std_logic;

-- signal <name> : <type>;

begin
    CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;
  DUT: hdmi_system_main_controller_upper_block port map(
                clk => clk,
                rst => rst,
                data_ready => data_ready,
                frame_done => frame_done,
                computation_done => computation_done,
                buffer_switch => buffer_switch,
                write_done => write_done,
                busy => busy,
                read_frame => read_frame,
                switch_buffer => switch_buffer
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here
    rst <= '1';
    data_ready <= '0';
    computation_done <= '0';
    buffer_switch <= '0';
    write_done <= '0';
    frame_done <= '0';
    
    wait for 316 ns;

	rst <= '0';


    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;
    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;
    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;
    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;

    buffer_switch <= '1';
    frame_done <= '1';
    data_ready <= '1';
    wait for 4 ns;
    buffer_switch <= '0';
    frame_done <= '0';
    data_ready <= '0';
    wait for 316 ns;
  
    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;
    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;

    frame_done <= '1';
    computation_done <= '0';
    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;

    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;
    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;

    computation_done <= '1';
    data_ready <= '1';
    wait for 4 ns;
    data_ready <= '0';
    wait for 316 ns;

    frame_done <= '0';
    computation_done <= '0';
 
    buffer_switch <= '1';
    frame_done <= '1';
    data_ready <= '1';
    wait for 4 ns;
    buffer_switch <= '0';
    frame_done <= '0';
    data_ready <= '0';
    wait for 316 ns;

    write_done <= '1';
    data_ready <= '1';
    wait for 4 ns;
    write_done <= '0';
    data_ready <= '0';
    wait for 316 ns;




  end process;
end TEST;
