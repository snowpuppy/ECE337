-- $Id: $
-- File name:   frame_decoder_48to756_upper_block.vhd
-- Created:     11/24/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 48 to 756 upper block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.all;

entity frame_decoder_48to756_upper_block is
  port ( 
    clk 	     : in std_logic;
    rst 	     : in std_logic;
    threed_ready     : in std_logic;
    twod_ready       : in std_logic;
    reset_error      : in std_logic; 
    num_vertices     : in std_logic_vector(7 downto 0);
    control          : in std_logic_vector(2 downto 0);
    threed_data      : in std_logic_vector(47 downto 0);
    twodonetwo_data  : in std_logic_vector(47 downto 0);
    color_done       : in std_logic;
    body_parsed      : out std_logic;
    done             : out std_logic;
    rx_data          : out std_logic_vector(767 downto 0));
end frame_decoder_48to756_upper_block;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_UNSIGNED.all;

architecture struct of frame_decoder_48to756_upper_block is
  signal done_transfer : std_logic;
  signal restart       : std_logic;
  signal count_up      : std_logic;
  signal clk_in_sr     : std_logic;
  signal done1         : std_logic;

  component frame_decoder_48to756_block_main_controller 
    port (
      clk 	     : in std_logic;
      rst 	     : in std_logic;
      done_transfer  : in std_logic;
      threed_ready   : in std_logic;
      twod_ready     : in std_logic;
      reset_error    : in std_logic; 
      control        : in std_logic_vector(2 downto 0);
      done 	     : out std_logic;
      count_up       : out std_logic;
      clk_in_sr      : out std_logic;
      restart        : out std_logic);
   end component;
-------------------------------------------------------------------------------
  component frame_decoder_48to756_block_shift_register 
    port (
      clk              : in std_logic;
      rst              : in std_logic;
      clk_in_sr        : in std_logic;
      control          : in std_logic_vector(2 downto 0);
      threed_data      : in std_logic_vector(47 downto 0);
      twodonetwo_data  : in std_logic_vector(47 downto 0);
      rx_data          : out std_logic_vector(767 downto 0));
    end component;
-------------------------------------------------------------------------------
  component frame_decoder_48to756_block_timer
    port (
      clk               : in std_logic;
      rst 	        : in std_logic;
      restart 	        : in std_logic;
      count_up          : in std_logic;
      control           : in std_logic_vector(2 downto 0);
      num_vertices      : in std_logic_vector(7 downto 0);
      done_transfer     : out std_logic);
    end component;
-------------------------------------------------------------------------------
  component frame_decoder_48to756_block_body_parsed 
    port (
    data_done        : in std_logic;
    color_done       : in std_logic;
    body_parsed      : out std_logic);
    end component;
-------------------------------------------------------------------------------
begin
  U_0:frame_decoder_48to756_block_main_controller 
    port map (
      clk 	     => clk,
      rst 	     => rst,
      done_transfer  => done_transfer,
      threed_ready   => threed_ready,
      twod_ready     => twod_ready,
      reset_error    => reset_error, 
      control        => control,
      done 	     => done1,
      count_up       => count_up,
      clk_in_sr      => clk_in_sr,
      restart        => restart);
-------------------------------------------------------------------------------
  U_1:frame_decoder_48to756_block_shift_register 
    port map (
      clk              => clk,
      rst              => rst,
      clk_in_sr        => clk_in_sr,
      control          => control,
      threed_data      => threed_data,
      twodonetwo_data  => twodonetwo_data,
      rx_data          => rx_data);
-------------------------------------------------------------------------------
  U_2:frame_decoder_48to756_block_timer
    port map (
      clk               => clk,
      rst 	        => rst,
      restart 	        => restart,
      count_up          => count_up,
      control           => control,
      num_vertices      => num_vertices,
      done_transfer     => done_transfer);
-------------------------------------------------------------------------------
  U_3:frame_decoder_48to756_block_body_parsed 
    port map (
      data_done        => done1,
      color_done       => color_done,
      body_parsed      => body_parsed);
-------------------------------------------------------------------------------
  done <= done1;
end struct;
