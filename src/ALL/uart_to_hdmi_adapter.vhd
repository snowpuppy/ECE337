-- $Id: $
-- File name:   uart_to_hdmi_adapter.vhd
-- Created:     12/4/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This is the overall file for the entire design.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity uart_to_hdmi_adapter is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        micro_data_in       : in    std_logic;
        tmds_data2          : out    std_logic;
        tmds_data1          : out    std_logic;
        tmds_data0          : out    std_logic;
        tmds_clock          : out    std_logic;
        address_one         : out    std_logic_vector(19 downto 0);
        address_two         : out    std_logic_vector(19 downto 0);
        --chip_select1        : out    std_logic_vector(1 downto 0);
        --chip_select2        : out    std_logic_vector(1 downto 0);
        --chip_select3        : out    std_logic_vector(1 downto 0);
        --chip_select4        : out    std_logic_vector(1 downto 0);
        write_enable        : out    std_logic_vector(1 downto 0);
        data1_in            : in    std_logic_vector(31 downto 0);
        data1_out           : out    std_logic_vector(31 downto 0);
        data2_in            : in    std_logic_vector(31 downto 0);
        data2_out           : out    std_logic_vector(31 downto 0);
        output_enable       : out    std_logic_vector(1 downto 0);
        busy                : out    std_logic;
        system_in_error     : out   std_logic
        );
end entity uart_to_hdmi_adapter;

architecture uart_to_hdmi_adapter_arch of uart_to_hdmi_adapter is

component rcv_block is
  port (
    clk           : in  std_logic;
    rst           : in  std_logic;
    serial_in     : in  std_logic;
    data_read     : in  std_logic;
    rx_data       : out std_logic_vector(7 downto 0);
    data_ready    : out std_logic;
    overrun_error : out std_logic;
    framing_error : out std_logic);
end component rcv_block;

component gpu_block is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        read_frame          : in    std_logic;
        pixel_done          : in    std_logic;
        control_in          : in    std_logic_vector(2 downto 0);
        num_vertices_in     : in    std_logic_vector(7 downto 0);
        color_in            : in    std_logic_vector(23 downto 0);
        vertices_in         : in    std_logic_vector(767 downto 0);
        computation_done    : out   std_logic;
        pixel_ready         : out   std_logic; -- note that pixel ready really maps to data ready and vice versa. This was due to a poor naming choice.
        data_in             : out   std_logic_vector(23 downto 0);
        address_in          : out   std_logic_vector(19 downto 0)
        );
end component gpu_block;

component frame_decoder_upper_block is
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
   frame_decoder_rx_data :  out std_logic_vector(767 downto 0)
   );
end component frame_decoder_upper_block;

component hdmi_system_main_controller_upper_block is
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
    switch_buffer    : out std_logic;  -- SRAM
    data_received    : out std_logic
   );
end component hdmi_system_main_controller_upper_block;

component Sram_Interface is
port(
  clk: in std_logic;
  rst_n: in std_logic;
  address_in: in std_logic_vector(19 downto 0);
  data_in: in std_logic_vector(23 downto 0);
  data_ready: in std_logic;
  pixel_ready: out std_logic;
  sram_sel: in std_logic;
  pixel_done: out std_logic;
  SRAM1_address: out std_logic_vector(19 downto 0);
  SRAM2_address: out std_logic_vector(19 downto 0);
  SRAM1_data: out std_logic_vector(31 downto 0);
  SRAM2_data: out std_logic_vector(31 downto 0);
  WE_ONE: out std_logic;
  WE_TWO: out std_logic;
  write_done: out std_logic;
  need_input: in std_logic;
  data_one: in std_logic_vector(31 downto 0);
  data_two: in std_logic_vector(31 downto 0);
  data_out: out std_logic_vector(23 downto 0);
  OE_ONE: out std_logic;
  OE_TWO: out std_logic
);
end component Sram_Interface;

component HDMI_Encoder is
port(
  clk: in std_logic;
  rst_n: in std_logic;
  pixel_data: in std_logic_vector(23 downto 0);
  data_ready: in std_logic;
  need_data: out std_logic;
  RO: out std_logic;
  GO: out std_logic;
  BO: out std_logic;
  TMDS_CLK: out std_logic
);
end component HDMI_Encoder;

-- DECLARE SIGNALS HERE.
signal data_in              : std_logic_vector(23 downto 0);
signal address_in           : std_logic_vector(19 downto 0);
signal data_ready_sram      : std_logic;
signal pixel_ready_sram     : std_logic;
signal sram_sel             : std_logic;
signal pixel_done_sram      : std_logic;
signal write_done_sram      : std_logic;
signal need_input_sram      : std_logic;
signal data_out_sram        : std_logic_vector(23 downto 0);
signal read_frame_gpu       : std_logic;
signal control_in_gpu       : std_logic_vector(2 downto 0);
signal num_vertices_in_gpu  : std_logic_vector(7 downto 0);
signal color_in_gpu         : std_logic_vector(23 downto 0);
signal vertices_in_gpu      : std_logic_vector(767 downto 0);
signal computation_done_gpu : std_logic;
signal data_read_frdec      : std_logic;
signal switch_buffer_frdec  : std_logic;
signal reset_error_frdec    : std_logic;
signal frame_done_frdec     : std_logic;
signal data_in_frdec        : std_logic_vector(7 downto 0);
signal data_ready_frdec     : std_logic;
signal system_framing_error_frdec : std_logic;
signal system_overrun_error_frdec : std_logic;
signal data_ready_cntr     : std_logic; 
signal busy_collective     : std_logic;
signal data1_in_sig        : std_logic_vector(31 downto 0);
signal data2_in_sig        : std_logic_vector(31 downto 0);
signal data1_out_sig       : std_logic_vector(31 downto 0);
signal data2_out_sig       : std_logic_vector(31 downto 0);

begin

-------------------
--     GPU       --
-------------------
HDMIgpu_block:gpu_block port map (
        clk => clk,
        rst => rst,
        read_frame => read_frame_gpu,
        pixel_done => pixel_done_sram,
        control_in => control_in_gpu,
        num_vertices_in => num_vertices_in_gpu,
        color_in => color_in_gpu,
        vertices_in => vertices_in_gpu,
        computation_done => computation_done_gpu,
        pixel_ready => data_ready_sram,
        data_in => data_in, -- done
        address_in => address_in -- done
        );

-------------------
-- FRAME DECODER --
-------------------
HDMIframe_decoder_upper_block: frame_decoder_upper_block port map ( 
    clk => clk, -- done
    rst => rst, -- done
    busy => busy_collective, -- To Controller
    data_ready => data_ready_frdec, -- To Main Controller
    system_framing_error => system_framing_error_frdec, -- To Main UART and Micro and Main controller
    system_overrun_error => system_overrun_error_frdec,
    data_in => data_in_frdec, -- To UART
   control => control_in_gpu, -- To GPU
   data_read => data_read_frdec, -- 
   switch_buffer => switch_buffer_frdec,
   reset_error => reset_error_frdec,
   frame_done => frame_done_frdec,
   num_vertices => num_vertices_in_gpu,
   color_rx_data => color_in_gpu,
   frame_decoder_rx_data => vertices_in_gpu
   );

-------------------
-- CONTROLLER -----
-------------------
HDMIhdmi_system_main_controller_upper_block: hdmi_system_main_controller_upper_block port map ( 
    clk => clk, -- done
    rst => rst, -- done
    data_ready => data_ready_cntr, -- To UART
    frame_done => frame_done_frdec, -- To Frame Decoder
    computation_done => computation_done_gpu, -- To GPU
    buffer_switch => switch_buffer_frdec, -- To frame_decoder
    write_done => write_done_sram, -- To ?
    system_framing_error => system_framing_error_frdec, -- To UART and Frame Decoder and Micro
    system_overrun_error => system_overrun_error_frdec, -- To UART and Frame Decoder and Micro
    reset_error => reset_error_frdec, -- To Frame Decoder
    system_in_error => system_in_error, -- To Microcontroller
    busy => busy_collective, -- done To micro
    read_frame => read_frame_gpu, -- To GPU
    switch_buffer => sram_sel, -- To SRAM
    data_received => data_ready_frdec
   );

-------------------
--    UART    -----
-------------------
HDMIrcv_block: rcv_block port map (
    clk => clk, -- done
    rst => rst, -- done
    serial_in => micro_data_in,  -- done -- To Microcontroler
    data_read => data_read_frdec, -- To Frame Decoder
    rx_data => data_in_frdec, -- To microcontroller
    data_ready => data_ready_cntr, -- To Main Controller
    overrun_error => system_overrun_error_frdec, -- To Frame Decoder and Micro
    framing_error => system_framing_error_frdec -- To Frame Decoder and Micro
    );

-------------------
--    SRAM    -----
-------------------
HDMISram_Interface: Sram_Interface port map(
  clk => clk, -- done
  rst_n => rst, -- done
  address_in => address_in, -- done GPU
  data_in => data_in, -- done GPU
  data_ready => data_ready_sram,
  pixel_ready => pixel_ready_sram,
  sram_sel => sram_sel,
  pixel_done => pixel_done_sram,
  SRAM1_address => address_one,
  SRAM2_address => address_two,
  SRAM1_data => data1_in_sig,
  SRAM2_data => data2_in_sig,
  WE_ONE => write_enable(0),
  WE_TWO => write_enable(1),
  write_done => write_done_sram,
  need_input => need_input_sram,
  data_one => data1_out_sig,
  data_two => data2_out_sig,
  data_out => data_out_sram,
  OE_ONE => output_enable(0),
  OE_TWO => output_enable(1)
);

---------------------------
--    HDMI ENCODER    -----
---------------------------
HDMIHDMI_Encoder: HDMI_Encoder port map(
  clk => clk,
  rst_n => rst,
  pixel_data => data_out_sram,
  data_ready => pixel_ready_sram,
  need_data => need_input_sram,
  RO => tmds_data2,
  GO => tmds_data1,
  BO => tmds_data0,
  TMDS_CLK => tmds_clock
);

busy <= busy_collective;
data1_in_sig <= data1_in;
data2_in_sig <= data2_in;
data1_out <= data1_out_sig;
data2_out <= data2_out_sig;

end architecture uart_to_hdmi_adapter_arch;
