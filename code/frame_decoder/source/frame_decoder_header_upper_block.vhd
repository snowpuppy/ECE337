-- $Id: $
-- File name:   frame_decoder_header_upper_block.vhd
-- Created:     11/24/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: header upper block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.all;

entity frame_decoder_header_upper_block is 
  port (
    clk 	    : in std_logic;
    rst 	    : in std_logic;
    reset_error     : in std_logic; 
    data_read       : in std_logic;
    input_sel       : in std_logic;
    frame_done      : in std_logic;
    data_in         : in std_logic_vector(7 downto 0);
    switch_buffer   : out std_logic;
    valid_header    : out std_logic;
    control         : out std_logic_vector(2 downto 0);
    num_byte        : out std_logic_vector(7 downto 0);
    num_vertices    : out std_logic_vector(7 downto 0));
end frame_decoder_header_upper_block;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_UNSIGNED.all;

architecture struct of frame_decoder_header_upper_block is
  signal  control_clk_in  : std_logic;
  signal  num_clk_in      : std_logic;
  signal  num_correct     : std_logic;
  signal  control_correct : std_logic;
  signal  move_buffer     : std_logic;

  component frame_decoder_header_main_controller
    port (
      clk 	      : in std_logic;
      rst 	      : in std_logic;
      data_read       : in std_logic;
      input_sel       : in std_logic;
      control_correct : in std_logic;
      num_correct     : in std_logic; 
      move_buffer     : in std_logic;   
      frame_done      : in std_logic;
      reset_error     : in std_logic; 
      control_clk_in  : out std_logic;
      num_clk_in      : out std_logic;
      switch_buffer   : out std_logic;
      valid_header    : out std_logic);
    end component;
-------------------------------------------------------------------------------
 component frame_decoder_header_body_block
  port (
    clk             : in std_logic;
    rst             : in std_logic;
    control_clk_in  : in std_logic;
    num_byte_clk_in : in std_logic;
    data_in         : in std_logic_vector(7 downto 0);
    control_correct : out std_logic;
    num_correct     : out std_logic;
    switch_buffer   : out std_logic;
    control         : out std_logic_vector(2 downto 0);
    num_byte        : out std_logic_vector(7 downto 0);
    num_vertices    : out std_logic_vector(7 downto 0)); 
  end component;
-------------------------------------------------------------------------------
begin 

    U_0:frame_decoder_header_main_controller
    port map (
      clk 	      => clk,
      rst 	      => rst,
      data_read       => data_read,
      input_sel       => input_sel,
      control_correct => control_correct,
      num_correct     => num_correct,
      move_buffer     => move_buffer,   
      frame_done      => frame_done,
      reset_error     => reset_error, 
      control_clk_in  => control_clk_in,
      num_clk_in      => num_clk_in,
      switch_buffer   => switch_buffer,
      valid_header    => valid_header);
-------------------------------------------------------------------------------
 U_1:frame_decoder_header_body_block
  port map (
    clk             => clk,
    rst             => rst,
    control_clk_in  => control_clk_in,
    num_byte_clk_in => num_clk_in,
    data_in         => data_in,
    control_correct => control_correct,
    num_correct     => num_correct,
    switch_buffer   => move_buffer,
    control         => control,
    num_byte        => num_byte,
    num_vertices    => num_vertices);
-------------------------------------------------------------------------------
end struct;
