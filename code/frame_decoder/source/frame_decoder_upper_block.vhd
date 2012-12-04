-- $Id: $
-- File name:   frame_decoder_upper_block.vhd
-- Created:     11/24/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: overall upper block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_arith.all;

entity frame_decoder_upper_block is
  port ( 
    clk : in std_logic;
    rst : in std_logic;
    busy : in std_logic;
    data_ready : in std_logic;
    system_framing_error : in std_logic;
    system_overrun_error : in std_logic;
    data_in : in std_logic_vector(7 downto 0);
   control : out std_logic_vector(2 downto 0);
   data_read : out std_logic;
   switch_buffer : out std_logic;
   reset_error : out std_logic;
   frame_done : out std_logic;
   num_vertices : out std_logic_vector(7 downto 0);
   color_rx_data  : out std_logic_vector(23 downto 0);
   frame_decoder_rx_data :  out std_logic_vector(767 downto 0));

end frame_decoder_upper_block;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_UNSIGNED.all;

architecture struct of frame_decoder_upper_block is
  signal reset_error1 : std_logic;
  signal valid_header : std_logic;
  signal switch_buffer1 : std_logic;
  signal frame_received : std_logic;
  signal send_error  : std_logic;
  signal failed_frame  : std_logic;
  signal input_sel : std_logic;
  signal throw_frame : std_logic;
  signal body_parsed : std_logic;
  signal num_byte : std_logic_vector(7 downto 0);
  signal data_out : std_logic_vector(7 downto 0);
  signal control1 : std_logic_vector(2 downto 0);
  signal frame_done1 : std_logic;
  signal num_vertices1 : std_logic_vector(7 downto 0);
  signal threed_block_sel : std_logic_vector(1 downto 0);
  signal threed_clk_in : std_logic;
  signal twodonetwo_clk_in : std_logic;
  signal twodonetwo_block_sel : std_logic;
  signal ready1 : std_logic;
  signal ready2 : std_logic;
  signal data_done : std_logic;
  signal color_done : std_logic;
  signal connection : std_logic_vector(15 downto 0);
  signal result_coord : std_logic_vector(47 downto 0);
  signal twodonetwo_data : std_logic_vector(47 downto 0);
  signal data_read1 : std_logic;

  component frame_decoder_main_controller
  port (
    clk 	  	  : in std_logic;
    rst 	 	  : in std_logic;
    busy 	          : in std_logic;
    valid_header   	  : in std_logic;
    switch_buffer         : in std_logic;
    frame_received	  : in std_logic;
    system_overrun_error  : in std_logic;  -- overrun error from UART 
    send_error            : in std_logic;  -- send error to reset the all system
    failed_frame          : in std_logic;  -- failed frame no frame done
    input_sel 	          : out std_logic;
    reset_error           : out std_logic; -- reset for the error to all over the system
    frame_done 	          : out std_logic);
  end component;
-------------------------------------------------------------------------------
 component frame_decoder_main_timer 
  port (
    clk                      : in std_logic;
    rst 	             : in std_logic;
    throw_frame 	     : in std_logic;
    body_parsed              : in std_logic;
    data_ready               : in std_logic;
    valid_header   	         : in std_logic;
    system_framing_error     : in std_logic;
    control                  : in std_logic_vector(2 downto 0);
    num_byte                 : in std_logic_vector(7 downto 0);
    data_read                : out std_logic;
    frame_received           : out std_logic;
    failed_frame             : out std_logic;   -- frame does not received
    send_error               : out std_logic);   -- reset
end component;
------------------------------------------------------------------------------
 component frame_decoder_register_block 
  port ( 
    clk        : in std_logic;
    rst        : in std_logic;
    data_ready : in std_logic;
    data_in    : in std_logic_vector(7 downto 0);
    data_out   : out std_logic_vector(7 downto 0));
  end component;
-------------------------------------------------------------------------------
 component frame_decoder_header_upper_block  
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
  end component;
-------------------------------------------------------------------------------
 component frame_decoder_3D_upper_block  
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
  end component;
-------------------------------------------------------------------------------
 component frame_decoder_2D12_upper_block 
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
  end component;
-------------------------------------------------------------------------------
 component frame_decoder_2D3_upper_block 
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
 end component;
-------------------------------------------------------------------------------
 component frame_decoder_coord_flattener_upper_block 
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
  end component;
-------------------------------------------------------------------------------

 component frame_decoder_48to756_upper_block
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
  end component;

-------------------------------------------------------------------------------
begin 
 U_0: frame_decoder_main_controller
  port map (
    clk 	  	  => clk,
    rst 	 	  => rst,
    busy 	          => busy,
    valid_header   	  => valid_header,
    switch_buffer         => switch_buffer1,
    frame_received	  => frame_received,
    system_overrun_error  => system_overrun_error,  -- overrun error from UART
    send_error            => send_error,  -- send error to reset the all system
    failed_frame          => failed_frame,  -- failed frame no frame done
    input_sel 	          => input_sel,
    reset_error           => reset_error1, -- reset for the error to all over the system
    frame_done 	          => frame_done1);
-------------------------------------------------------------------------------
 U_1: frame_decoder_main_timer 
  port map (
    clk                      => clk,
    rst 	                   => rst,
    throw_frame 	           => throw_frame,
    body_parsed              => body_parsed,
    data_ready               => data_ready,
    system_framing_error     => system_framing_error,
    valid_header   	         => valid_header,
    control                  => control1,
    num_byte                 => num_byte,
    data_read                => data_read1,
    frame_received           => frame_received,
    failed_frame             => failed_frame,   -- frame does not received
    send_error               => send_error);   -- reset
------------------------------------------------------------------------------
 U_2: frame_decoder_register_block 
  port map ( 
    clk        => clk,
    rst        => rst,
    data_ready => data_ready,
    data_in    => data_in,
    data_out   => data_out);
-------------------------------------------------------------------------------
 U_3:frame_decoder_header_upper_block  
  port map (
    clk 	    => clk,
    rst 	    => rst,
    reset_error     => reset_error1, 
    data_read       => data_read1,
    input_sel       => input_sel,
    frame_done      => frame_done1,
    data_in         => data_out,
    switch_buffer   => switch_buffer1,
    valid_header    => valid_header,
    control         => control1,
    num_byte        => num_byte,
    num_vertices    => num_vertices1);
-------------------------------------------------------------------------------
 U_4:frame_decoder_3D_upper_block  
  port map (
    clk		  => clk,
    rst		  => rst,
    data_read     => data_read1,
    input_sel     => input_sel,
    reset_error   => reset_error1, 
    control       => control1,
    num_vertices  => num_vertices1,
    data_in       => data_out,
    sel 	  => threed_block_sel,
    clk_in_color  => threed_clk_in,
    rx_data       => connection);
-------------------------------------------------------------------------------
 U_5: frame_decoder_2D12_upper_block 
  port map (
    clk   	  => clk,
    rst   	  => rst,
    data_read     => data_read1,
    input_sel     => input_sel,
    reset_error   => reset_error1, 
    data_in       => data_out,
    control 	  => control1,
    ready2        => ready2,
    clk_in_color  => twodonetwo_clk_in,
    sel           => twodonetwo_block_sel,
    rx_data       => twodonetwo_data);
-------------------------------------------------------------------------------
 U_6: frame_decoder_2D3_upper_block 
  port map ( 
    clk                  => clk,
    rst 		 => rst,
    reset_error          => reset_error1, 
    input_sel            => input_sel,
    data_read            => data_read1,
    data_done            => data_done,
    threed_clk_in        => threed_clk_in,
    twodonetwo_clk_in    => twodonetwo_clk_in,
    twodonetwo_block_sel => twodonetwo_block_sel, 
    threed_block_sel     => threed_block_sel,
    control              => control1,
    data_in              => data_out,
    rx_data              => color_rx_data,
    done                 => color_done);
-------------------------------------------------------------------------------
 U_7: frame_decoder_coord_flattener_upper_block 
  port map (
    clk => clk,
    rst => rst,
    data_read     => data_read1,
    reset_error   => reset_error1, 
    threed_enable => threed_block_sel,
    data_in       => data_out,
    connection    => connection,
    num_vertices  => num_vertices1,
    result        => result_coord,
    ready1        => ready1,
    throw_frame   => throw_frame); 
-------------------------------------------------------------------------------
 U_8: frame_decoder_48to756_upper_block
  port map ( 
    clk 	     => clk,
    rst 	     => rst,
    threed_ready     => ready1,
    twod_ready       => ready2,
    reset_error      => reset_error1, 
    num_vertices     => num_vertices1,
    control          => control1,
    threed_data      => result_coord,
    twodonetwo_data  => twodonetwo_data,
    color_done       => color_done,
    body_parsed      => body_parsed,
    done             => data_done,
    rx_data          => frame_decoder_rx_data);

-------------------------------------------------------------------------------
switch_buffer <= switch_buffer1;
reset_error <= reset_error1;
frame_done <= frame_done1;
control <= control1;
num_vertices <= num_vertices1;
data_read <= data_read1;
end struct;



