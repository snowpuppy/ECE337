-- $Id: $
-- File name:   frame_decoder_3D_upper_block.vhd
-- Created:     11/24/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 3D upper block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.all;

entity frame_decoder_3D_upper_block is 
  port (
    clk		  : in std_logic;
    rst		  : in std_logic;
    data_read     : in std_logic;
    input_sel     : in std_logic;
    reset_error   : in std_logic; 
    control       : in std_logic_vector(2 downto 0);
    num_vertices  : in std_logic_vector(7 downto 0);
    data_in       : in std_logic_vector(7 downto 0);
    sel 	  : out std_logic_vector(1 downto 0);
    clk_in_color  : out std_logic;
    rx_data       : out std_logic_vector(15 downto 0));
end frame_decoder_3D_upper_block;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_UNSIGNED.all;

architecture struct of frame_decoder_3D_upper_block is
  signal clk_up : std_logic;
  signal packet_done : std_logic;
  signal all_vertices_done : std_logic;
  signal direction_done : std_logic;
  signal restart : std_logic;
  signal sel1  : std_logic_vector(1 downto 0);
  signal clk_in_connection : std_logic;

  component frame_decoder_3D_block_main_controller 
    port ( 
      clk               : in std_logic;
      rst               : in std_logic;
      data_read         : in std_logic;
      input_sel         : in std_logic;
      packet_done       : in std_logic;
      all_vertices_done : in std_logic;
      direction_done    : in std_logic;
      reset_error       : in std_logic; 
      control           : in std_logic_vector(2 downto 0);
      restart           : out std_logic;
      clk_up            : out std_logic;
      clk_in_color      : out std_logic;
      clk_in_connection : out std_logic;
      sel               : out std_logic_vector(1 downto 0));
    end component;
-----------------------------------------------------------

  component frame_decoder_3D_block_timer
    port (
      clk               : in std_logic;
      rst 	        : in std_logic;
      restart 	        : in std_logic;
      clk_up            : in std_logic;
      sel 	        : in std_logic_vector(1 downto 0);
      num_vertices      : in std_logic_vector(7 downto 0);
      all_vertices_done : out std_logic;
      packet_done       : out std_logic;
      direction_done    : out std_logic);
    end component;
-----------------------------------------------------------
  component frame_decoder_3D_block_8to16SR
    port (
      clk        : in std_logic;
      rst        : in std_logic;
      data_in    : in std_logic_vector(7 downto 0);
      clk_sr     : in std_logic;
      rx_enable  : in std_logic_vector(1 downto 0);
      rx_data    : out std_logic_vector(15 downto 0));
    end component;
-----------------------------------------------------------
begin
  U_0:frame_decoder_3D_block_main_controller 
    port map ( 
      clk               => clk,
      rst               => rst,
      data_read         => data_read,
      input_sel         => input_sel,
      packet_done       => packet_done,
      all_vertices_done => all_vertices_done,
      direction_done    => direction_done,
      reset_error       => reset_error,
      control           => control,
      restart           => restart,
      clk_up            => clk_up,
      clk_in_color      => clk_in_color,
      clk_in_connection => clk_in_connection,
      sel               => sel1);
-----------------------------------------------------------

  U_1:frame_decoder_3D_block_timer
    port map (
      clk               => clk,
      rst 	        => rst,
      restart 	        => restart,
      clk_up            => clk_up,
      sel               => sel1,
      num_vertices      => num_vertices,
      all_vertices_done => all_vertices_done,
      packet_done       => packet_done,
      direction_done    => direction_done);
-----------------------------------------------------------
  u_2:frame_decoder_3D_block_8to16SR
    port map (
      clk        => clk,
      rst        => rst,
      data_in    => data_in,
      clk_sr     => clk_in_connection,
      rx_enable  => sel1,
      rx_data    => rx_data);
-----------------------------------------------------------
   sel <= sel1;
end struct;
