-- $Id: $
-- File name:   frame_decoder_2D3_upper_block.vhd
-- Created:     11/24/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: upper block for 2D3


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.all;

entity frame_decoder_2D3_upper_block is
  port ( 
    clk                  : in std_logic;
    rst 		 : in std_logic;
    reset_error          : in std_logic; 
    input_sel            : in std_logic;
    data_read            : in std_logic;
    data_done            : in std_logic;
    threed_clk_in        : in std_logic;
    twodonetwo_clk_in    : in std_logic;
    twodonetwo_block_sel : in std_logic; 
    threed_block_sel     : in std_logic_vector(1 downto 0);
    control              : in std_logic_vector(2 downto 0);
    data_in              : in std_logic_vector(7 downto 0);
    rx_data              : out std_logic_vector(23 downto 0);
    done                 : out std_logic);
end frame_decoder_2D3_upper_block;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_UNSIGNED.all;

architecture struct of frame_decoder_2D3_upper_block is
  signal clk_in : std_logic;
  signal clk_sr : std_logic;

  component frame_decoder_2D3_8to24SR
    port (
      clk                  : in std_logic; 
      rst 	           : in std_logic; 
      clk_sr               : in std_logic; 
      data_in              : in std_logic_vector(7 downto 0);
      rx_data 	           : out std_logic_vector(23 downto 0));
   end component;
-------------------------------------------------------------------------------
   component frame_decoder_2D3_main_controller
     port (
       clk 	         : in std_logic;
       rst 	         : in std_logic;
       reset_error       : in std_logic;   
       threed_clk_in     : in std_logic;
       twodonetwo_clk_in : in std_logic;
       twodthree_clk_in  : in std_logic;
       data_done         : in std_logic; --data done signal from 48 to 756 
       twodonetwo_block_sel : in std_logic;
       threed_block_sel     : in std_logic_vector(1 downto 0);
       control              : in std_logic_vector(2 downto 0);
       clk_sr            : out std_logic;
       done 	         : out std_logic);
    end component;
-------------------------------------------------------------------------------
   component frame_decoder_2D3_clk_in_main_controller
    port (
      clk 	     : in std_logic;
      rst 	     : in std_logic;
      input_sel      : in std_logic;
      reset_error    : in std_logic; 
      data_read      : in std_logic;
      control        : in std_logic_vector(2 downto 0);
      clk_in 	     : out std_logic);
    end component;
-------------------------------------------------------------------------------  
begin  -- struct
  U_0:frame_decoder_2D3_8to24SR
    port map (
      clk                  => clk,
      rst 	           => rst,
      clk_sr               => clk_sr, 
      data_in              => data_in,
      rx_data 	           => rx_data);

------------------------------------------------------------------------------- 
  U_1:frame_decoder_2D3_main_controller
    port map (
       clk 	         => clk,
       rst 	         => rst,
       reset_error       => reset_error,
       threed_clk_in     => threed_clk_in,
       twodonetwo_clk_in => twodonetwo_clk_in,
       twodthree_clk_in  => clk_in,
       data_done         => data_done, --data done signal from 48 to 756 
       twodonetwo_block_sel => twodonetwo_block_sel,
       threed_block_sel     => threed_block_sel,
       control           => control,
       clk_sr            => clk_sr,
       done 	         => done);  

------------------------------------------------------------------------------- 
  U_2:frame_decoder_2D3_clk_in_main_controller
    port map (
      clk 	     => clk,
      rst 	     => rst,
      input_sel      => input_sel,
      reset_error    => reset_error, 
      data_read      => data_read,
      control        => control,
      clk_in 	     => clk_in);
end struct;
