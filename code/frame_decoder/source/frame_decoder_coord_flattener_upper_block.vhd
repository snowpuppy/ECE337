-- $Id: $
-- File name:   frame_decoder_coord_flattener_upper_block.vhd
-- Created:     11/24/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: coord flattener upper block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.all;

entity frame_decoder_coord_flattener_upper_block is
  port (
    clk : in std_logic;
    rst : in std_logic;
    data_read     : in std_logic;
    reset_error   : in std_logic; 
    threed_enable : in std_logic_vector(1 downto 0);
    data_in       : in std_logic_vector(7 downto 0);
    connection    : in std_logic_vector(15 downto 0);
    num_vertices  : in std_logic_vector(7 downto 0);
    result        : out std_logic_vector(47 downto 0);
    ready1        : out std_logic;
    throw_frame   : out std_logic); 
end frame_decoder_coord_flattener_upper_block;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_UNSIGNED.all;

architecture struct of frame_decoder_coord_flattener_upper_block is
  signal rx_enable  : std_logic_vector(3 downto 0);
  signal clk_sr     : std_logic_vector(3 downto 0);
  signal sin        : signed(47 downto 0);
  signal cos        : signed(47 downto 0);
  signal point      : signed(47 downto 0);
  signal offset     : signed(47 downto 0);
  signal resultx    : signed(15 downto 0);
  signal resulty    : signed(15 downto 0);
  signal resultz    : signed(15 downto 0);
  signal placer_x   : std_logic_vector(15 downto 0);
  signal placer_y   : std_logic_vector(15 downto 0);
  signal placer_z   : std_logic_vector(15 downto 0);
  signal start      : std_logic;
  signal quotient_xz :  std_logic_vector(15 downto 0); --results for x/z
  signal quotient_yz :  std_logic_vector(15 downto 0); --results for y/z
  signal done        :  std_logic;
  signal restart     : std_logic;
  signal clk_up      : std_logic;
  signal all_vertices_done : std_logic;
  signal packet_received   : std_logic;
  signal data_wrong : std_logic;    
  signal error_z : std_logic;      
  signal xstart : std_logic;
  signal ystart : std_logic;
  signal zstart : std_logic;
  signal restart_vertices  : std_logic;
  signal done_one_vertices : std_logic;

  component frame_decoder_coord_flattener_main_controller 
    port (
      clk 	        : in std_logic;
      rst 	        : in std_logic;
      done 	        : in std_logic;
      data_read 	: in std_logic;
      reset_error       : in std_logic; 
      packet_received   : in std_logic;
      all_vertices_done : in std_logic;
      data_wrong        : in std_logic; 
      error_z           : in std_logic;
      threed_enable 	: in std_logic_vector(1 downto 0);
      clk_up            : out std_logic;
      restart           : out std_logic;
      start_divide      : out std_logic;
      ready1            : out std_logic; 
      throw_frame       : out std_logic;
      restart_vertices  : out std_logic;
      done_one_vertices : out std_logic;
      clk_sr            : out std_logic_vector(3 downto 0);
      enable            : out std_logic_vector(3 downto 0));
    end component;
----------------------------------------------------------------------------------------
   component frame_decoder_coord_flattener_8to48SR_cos 
     port (
      clk        : in std_logic;
      rst        : in std_logic;
      data_in    : in std_logic_vector(7 downto 0);
      clk_sr     : in std_logic_vector(3 downto 0);
      rx_enable  : in std_logic_vector(3 downto 0);
      rx_data    : out signed(47 downto 0));
     end component;
----------------------------------------------------------------------------------------
  component frame_decoder_coord_flattener_8to48SR_offset
    port (
      clk        : in std_logic;
      rst        : in std_logic;
      data_in    : in std_logic_vector(7 downto 0);
      clk_sr     : in std_logic_vector(3 downto 0);
      rx_enable  : in std_logic_vector(3 downto 0);
      rx_data    : out signed(47 downto 0));
    end component;
----------------------------------------------------------------------------------------
  component frame_decoder_coord_flattener_8to48SR_point
    port (
      clk        : in std_logic;
      rst        : in std_logic;
      data_in    : in std_logic_vector(7 downto 0);
      clk_sr     : in std_logic_vector(3 downto 0);
      rx_enable  : in std_logic_vector(3 downto 0);
      rx_data    : out signed(47 downto 0));
    end component;
----------------------------------------------------------------------------------------
  component frame_decoder_coord_flattener_8to48SR_sin
    port (
      clk        : in std_logic;
      rst        : in std_logic;
      data_in    : in std_logic_vector(7 downto 0);
      clk_sr     : in std_logic_vector(3 downto 0);
      rx_enable  : in std_logic_vector(3 downto 0);
      rx_data    : out signed(47 downto 0));
    end component;
----------------------------------------------------------------------------------------
  component frame_decoder_coord_flattener_rotator 
    port (
     sin     : in signed(47 downto 0);
     cos     : in signed(47 downto 0);
     point   : in signed(47 downto 0);
     resultx : out signed(15 downto 0);
     resulty : out signed(15 downto 0);
     resultz : out signed(15 downto 0));
    end component;
----------------------------------------------------------------------------------------
  component frame_decoder_coord_flattener_placer 
    port (
     rotator_result_x : in signed(15 downto 0);
     rotator_result_y : in signed(15 downto 0);
     rotator_result_z : in signed(15 downto 0);
     offset           : in signed(47 downto 0);
     placer_x         : out std_logic_vector(15 downto 0);
     placer_y         : out std_logic_vector(15 downto 0);
     placer_z         : out std_logic_vector(15 downto 0));
    end component;
----------------------------------------------------------------------------------------
  component frame_decoder_coord_flattener_scalar
    port (
      clk         : in std_logic;
      rst         : in std_logic;
      start       : in std_logic;
      placer_z_in : in std_logic_vector(15 downto 0); --z component
      placer_y_in : in std_logic_vector(15 downto 0); --y component
      placer_x_in : in std_logic_vector(15 downto 0); --x component
      quotient_xz : out std_logic_vector(15 downto 0); --results for x/z
      quotient_yz : out std_logic_vector(15 downto 0); --results for y/z
      error_z     : out std_logic;
      done        : out std_logic);
    end component;
----------------------------------------------------------------------------------------
  component frame_decoder_coord_flattener_final_result
    port (
      quotient_xz : in std_logic_vector(15 downto 0); --results for x/z
      quotient_yz : in std_logic_vector(15 downto 0); --results for y/z
      connection  : in std_logic_vector(15 downto 0);
      done        : in std_logic;
      result      : out std_logic_vector(47 downto 0));
    end component;
----------------------------------------------------------------------------------------
  component frame_decoder_coord_flattener_timer
    port (
      clk               : in std_logic;
      rst 	        : in std_logic;
      restart 	        : in std_logic;
      clk_up            : in std_logic;
      restart_vertices  : in std_logic;
      done_one_vertices : in std_logic;
      num_vertices      : in std_logic_vector(7 downto 0);
      all_vertices_done : out std_logic;
      xstart            : out std_logic;
      ystart            : out std_logic;
      zstart            : out std_logic;
      packet_received   : out std_logic);
    end component;
----------------------------------------------------------------------------------------
 component frame_decoder_coord_flattener_data_verification
   port (
      xstart : in std_logic;
      ystart : in std_logic;
      zstart : in std_logic;
      enable : in std_logic_vector(3 downto 0);
      data_in : in std_logic_vector(7 downto 0);
      data_wrong : out std_logic);
   end component;
----------------------------------------------------------------------------------------
begin
   U_0:frame_decoder_coord_flattener_main_controller 
    port map (
      clk 	        => clk,
      rst 	        => rst,
      done 	        => done,
      data_read 	=> data_read,
      reset_error       => reset_error,
      packet_received   => packet_received,
      all_vertices_done => all_vertices_done,
      threed_enable 	=> threed_enable,
      data_wrong        => data_wrong,
      error_z           => error_z,
      restart_vertices  => restart_vertices,
      done_one_vertices => done_one_vertices,
      throw_frame       => throw_frame,
      clk_up            => clk_up,
      restart           => restart,
      start_divide      => start,
      ready1            => ready1, 
      clk_sr            => clk_sr,
      enable            => rx_enable);
----------------------------------------------------------------------------------------
  U_9:frame_decoder_coord_flattener_timer
    port map (
      clk               => clk,
      rst 	        => rst,
      restart 	        => restart,
      clk_up            => clk_up,
      restart_vertices  => restart_vertices,
      done_one_vertices => done_one_vertices,
      num_vertices      => num_vertices,
      xstart            => xstart,
      ystart            => ystart,
      zstart            => zstart,
      all_vertices_done => all_vertices_done,
      packet_received   => packet_received);
----------------------------------------------------------------------------------------
   U_1:frame_decoder_coord_flattener_8to48SR_cos 
     port map (
      clk        => clk,
      rst        => rst,
      data_in    => data_in,
      clk_sr     => clk_sr,
      rx_enable  => rx_enable,
      rx_data    => cos);
----------------------------------------------------------------------------------------
  U_2:frame_decoder_coord_flattener_8to48SR_offset
    port map (
      clk        => clk,
      rst        => rst,
      data_in    => data_in,
      clk_sr     => clk_sr,
      rx_enable  => rx_enable,
      rx_data    => offset);
----------------------------------------------------------------------------------------
  U_3:frame_decoder_coord_flattener_8to48SR_point
    port map (
      clk        => clk,
      rst        => rst,
      data_in    => data_in,
      clk_sr     => clk_sr,
      rx_enable  => rx_enable,
      rx_data    => point);
----------------------------------------------------------------------------------------
  U_4:frame_decoder_coord_flattener_8to48SR_sin
    port map (
      clk        => clk,
      rst        => rst,
      data_in    => data_in,
      clk_sr     => clk_sr,
      rx_enable  => rx_enable,
      rx_data    => sin);
----------------------------------------------------------------------------------------
  U_5:frame_decoder_coord_flattener_rotator 
    port map (
     sin     => sin,
     cos     => cos,
     point   => point,
     resultx => resultx,
     resulty => resulty,
     resultz => resultz);
----------------------------------------------------------------------------------------
  U_6:frame_decoder_coord_flattener_placer 
    port map (
     rotator_result_x => resultx,
     rotator_result_y => resulty,
     rotator_result_z => resultz,
     offset           => offset,
     placer_x         => placer_x,
     placer_y         => placer_y,
     placer_z         => placer_z);
----------------------------------------------------------------------------------------
  U_7:frame_decoder_coord_flattener_scalar
    port map (
      clk         => clk,
      rst         => rst,
      start       => start,
      placer_z_in => placer_z,       --z component
      placer_y_in => placer_y,        --y component
      placer_x_in => placer_x,        --x component
      quotient_xz => quotient_xz, --results for x/z
      quotient_yz => quotient_yz, --results for y/z
      error_z     => error_z,
      done        => done);
----------------------------------------------------------------------------------------
  U_8:frame_decoder_coord_flattener_final_result
    port map (
      quotient_xz => quotient_xz, --results for x/z
      quotient_yz => quotient_yz, --results for y/z
      connection  => connection,
      done        => done,
      result      => result);
----------------------------------------------------------------------------------------
  U_10: frame_decoder_coord_flattener_data_verification
   port map (
      xstart => xstart,
      ystart => ystart,
      zstart => zstart,
      enable => rx_enable,
      data_in => data_in,
      data_wrong => data_wrong);
----------------------------------------------------------------------------------------
end struct;
