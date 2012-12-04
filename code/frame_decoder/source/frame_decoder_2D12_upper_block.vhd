-- $Id: $
-- File name:   frame_decoder_2D12_upper_block.vhd
-- Created:     11/24/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: 2D12 upper block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.all;

entity frame_decoder_2D12_upper_block is
  port (
    clk   	  : in std_logic;
    rst   	  : in std_logic;
    data_read     : in std_logic;
    input_sel     : in std_logic;
    reset_error   : in std_logic; 
    data_in       : in std_logic_vector(7 downto 0);
    control 	  : in std_logic_vector(2 downto 0);
    ready2        : out std_logic;
    clk_in_color  : out std_logic;
    sel           : out std_logic;
    rx_data       : out std_logic_vector(47 downto 0));
end frame_decoder_2D12_upper_block;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_UNSIGNED.all;

architecture struct of frame_decoder_2D12_upper_block is
  signal restart : std_logic;
  signal clk_up  : std_logic;
  signal six_assert : std_logic;
  signal concat  : std_logic;
  signal clk_in_packet : std_logic;
  signal sel1 : std_logic;

  component frame_decoder_2D12_8to48SR 
    port (
      clk        : in std_logic;
      rst        : in std_logic;
      data_in    : in std_logic_vector(7 downto 0);
      clk_sr     : in std_logic;
      rx_enable  : in std_logic;
      concat     : in std_logic;
      rx_data    : out std_logic_vector(47 downto 0));
    end component;
-------------------------------------------------------------------------------
  component frame_decoder_2D12_timer 
    port (
      clk             : in std_logic;
      rst 	      : in std_logic;
      restart 	      : in std_logic;
      clk_up          : in std_logic;
      six_assert      : out std_logic);
    end component;
-------------------------------------------------------------------------------
  component frame_decoder_2D12_main_controller
    port (
      clk 	     : in std_logic;
      rst 	     : in std_logic;
      data_read      : in std_logic;
      input_sel      : in std_logic;
      six_assert     : in std_logic;
      reset_error    : in std_logic; 
      control 	     : in std_logic_vector(2 downto 0);
      concat         : out std_logic;
      sel            : out std_logic;
      clk_in_color   : out std_logic;
      clk_in_packet  : out std_logic;
      ready2 	     : out std_logic;
      restart 	     : out std_logic;
      clk_up 	     : out std_logic);
  end component;
-------------------------------------------------------------------------------
begin
    U_0:frame_decoder_2D12_8to48SR 
      port map (
        clk        => clk,
        rst        => rst,
        data_in    => data_in,
        clk_sr     => clk_in_packet,
        rx_enable  => sel1,
        concat     => concat,
        rx_data    => rx_data);
-------------------------------------------------------------------------------
    U_1:frame_decoder_2D12_timer 
      port map (
        clk           => clk,
        rst 	      => rst,
        restart       => restart,
        clk_up        => clk_up,
        six_assert    => six_assert);
-------------------------------------------------------------------------------
    U_2:frame_decoder_2D12_main_controller
      port map (
        clk 	       => clk,
        rst 	       => rst,
        data_read      => data_read,
        input_sel      => input_sel,
        six_assert     => six_assert,
        reset_error    => reset_error,
        control        => control,
        concat         => concat,
        sel            => sel1,
        clk_in_color   => clk_in_color,
        clk_in_packet  => clk_in_packet,
        ready2 	       => ready2,
        restart        => restart,
        clk_up 	       => clk_up);
-------------------------------------------------------------------------------
  sel <= sel1;
end struct;
