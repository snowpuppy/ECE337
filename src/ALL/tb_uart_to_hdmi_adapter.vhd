-- $Id: $
-- File name:   tb_uart_to_hdmi_adapter.vhd
-- Created:     12/4/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model
library ECE337_IP;
--use ECE337_IP.scalable_off_chip_sram;
use ECE337_IP.all;


entity tb_uart_to_hdmi_adapter is
generic (
         Period : Time := 4 ns;
         DATA_PERIOD : Time := 40 ns
         );
end tb_uart_to_hdmi_adapter;

architecture TEST of tb_uart_to_hdmi_adapter is

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

  function to_string(sv: Std_Logic_Vector) return string is
    use Std.TextIO.all;
    variable bv: bit_vector(sv'range) := to_bitvector(sv);
    variable lp: line;
  begin
    write(lp, bv);
    return lp.all;
  end;

  -- DATA TYPES ---
  type point is record
    x, y, z : integer;
    connection : std_logic_vector(15 downto 0);
  end record;

  type coords is array(15 downto 0) of point;

  type type_offset is record
    x, y, z : integer;
  end record;
  type type_cos is record
    x, y, z : std_logic_vector(15 downto 0);
  end record;
  type type_sin is record
    x, y, z : std_logic_vector(15 downto 0);
  end record;
  type type_color is record
    red, green, blue : integer;
  end record;

  -- define 3d frame construct
  type input_3dframe is record
    vertices : coords;
    num_verts : integer;
    color : type_color;
    cos   : type_cos;
    sin   : type_sin;
    offset: type_offset;
  end record;

  -- define 2d1,2 frame construct
  type input_2dframe is record
    x,y,w,h : integer;
    color   : type_color;
  end record;

  -- define 2d3 frame construct
  type input_2d3frame is record
    color   : type_color;
  end record;
-------------------------------------------------------------------------------------
  procedure send_bits(
        data : in std_logic_vector(7 downto 0);
        stop_bit : in std_logic;                  
        data_period : in time;
        signal serial_in_signal  :inout std_logic
        ) is
  
  begin
    -- Send the start bit
    serial_in_signal  <= '0';
    wait for data_period;
    -- Send data bits
    for i in 0 to 7 loop
        -- Send apropriate bit value
        serial_in_signal <= data(i);
        -- Wait for a full bit period
        wait for data_period;
    end loop;
    
    -- Send the stop bit
    serial_in_signal  <= stop_bit;
    wait for data_period;
  end procedure send_bits;
-------------------------------------------------------------------------------------
procedure send_3d_frame(
        frame       : in input_3dframe;
        data_period : in time;
        signal serial_in_signal  :inout std_logic
        ) is
        variable frame_type : std_logic_vector(7 downto 0);
        variable num_bytes : std_logic_vector(7 downto 0);
        variable color_vector : std_logic_vector(23 downto 0);
        variable sin_vector   : std_logic_vector(3*16-1 downto 0);
        variable cos_vector   : std_logic_vector(3*16-1 downto 0);
        variable offset_vector   : std_logic_vector(3*16-1 downto 0);
        variable vertices_vector  : std_logic_vector(16*16*4-1 downto 0);
        variable data_vector  : std_logic_vector(16*16*4+9*16+24+2*8-1 downto 0);
        variable large_frame_size : integer := (16*16*4+9*16+24)/8 + 2;
        variable frame_size   : integer := (16*16*4+9*16+24)/8 + 2;
        variable k,l          : integer;
begin
        -- construct data vector
        frame_size := (frame.num_verts*16*4 + 9*16 + 24)/8 + 2;
        frame_type := "00100000";
        num_bytes := UINT_TO_STDV(frame_size-2,8);
        color_vector := UINT_TO_STDV(frame.color.red,8) & UINT_TO_STDV(frame.color.green,8) & UINT_TO_STDV(frame.color.blue,8);
        --sin_vector := UINT_TO_STDV(frame.sin.x,16) & UINT_TO_STDV(frame.sin.y,16) & UINT_TO_STDV(frame.sin.z,16);
        --cos_vector := UINT_TO_STDV(frame.cos.x,16) & UINT_TO_STDV(frame.cos.y,16) & UINT_TO_STDV(frame.cos.z,16);
        sin_vector := frame.sin.x & frame.sin.y & frame.sin.z;
        cos_vector := frame.cos.x & frame.cos.y & frame.cos.z;
        offset_vector := UINT_TO_STDV(frame.offset.x,16) & UINT_TO_STDV(frame.offset.y,16) & UINT_TO_STDV(frame.offset.z,16);

        for i in 0 to frame.num_verts-1 loop
            k := (16*16*4-1-16*4*i);
            l := 16*16*4-16*4-i*16*4;
            vertices_vector( k downto l ) := frame.vertices(15-i).connection & UINT_TO_STDV(frame.vertices(15-i).x,16) & UINT_TO_STDV(frame.vertices(15-i).y,16) & UINT_TO_STDV(frame.vertices(15-i).z,16);
            report "from " & integer'image(k) & " to " & integer'image(l);
            report to_string(vertices_vector(k downto l));
        end loop;

        -- data format
        data_vector := frame_type & num_bytes & color_vector & sin_vector & cos_vector & offset_vector & vertices_vector;

        -- send out the data
        k := 16*16*4+9*16+24+2*8-1;
        for i in 0 to frame_size-1 loop
            send_bits(data_vector((k-1-8*i) downto k-8-i*8), '1', data_period, serial_in_signal);
        end loop;

end procedure send_3d_frame;
-------------------------------------------------------------------------------------
procedure send_2d_frame(
        frame       : in input_2dframe;
        data_period : in time;
        signal serial_in_signal  :inout std_logic
        ) is
        variable frame_type : std_logic_vector(7 downto 0);
        variable num_bytes : std_logic_vector(7 downto 0);
        variable color_vector : std_logic_vector(23 downto 0);
        variable data_vector : std_logic_vector(103 downto 0);
        variable frame_size : integer := 13;
begin
        -- construct data vector
        frame_type := "01000000";
        num_bytes := UINT_TO_STDV(frame_size-2,8);
        color_vector := UINT_TO_STDV(frame.color.red,8) & UINT_TO_STDV(frame.color.green,8) & UINT_TO_STDV(frame.color.blue,8);
        data_vector := frame_type & num_bytes & UINT_TO_STDV(frame.x,16) & UINT_TO_STDV(frame.y,16) & UINT_TO_STDV(frame.w,16) & UINT_TO_STDV(frame.h,16) & color_vector;

        -- send out the data
        for i in 0 to frame_size-1 loop
            send_bits(data_vector((frame_size*8-1-8*i) downto frame_size*8-8-i*8), '1', data_period, serial_in_signal);
        end loop;
end procedure send_2d_frame;
-------------------------------------------------------------------------------------
procedure send_2d3_frame(
        frame       : in input_2d3frame;
        data_period : in time;
        signal serial_in_signal  :inout std_logic
        ) is
        variable frame_type : std_logic_vector(7 downto 0);
        variable num_bytes : std_logic_vector(7 downto 0);
        variable color_vector : std_logic_vector(23 downto 0);
        variable data_vector : std_logic_vector(5*8-1 downto 0);
        variable frame_size : integer := 5;
begin
        -- construct data vector
        frame_type := "10000000";
        num_bytes := UINT_TO_STDV(frame_size-2,8);
        color_vector := UINT_TO_STDV(frame.color.red,8) & UINT_TO_STDV(frame.color.green,8) & UINT_TO_STDV(frame.color.blue,8);
        data_vector := frame_type & num_bytes & color_vector;

        -- send out the data
        for i in 0 to frame_size-1 loop
            send_bits(data_vector((frame_size*8-1-8*i) downto frame_size*8-8-i*8), '1', data_period, serial_in_signal);
        end loop;
end procedure send_2d3_frame;
-------------------------------------------------------------------------------------
procedure send_switch_frame(
        data_period : in time;
        signal serial_in_signal  :inout std_logic
        ) is
        variable frame_type : std_logic_vector(7 downto 0);
        variable num_bytes : std_logic_vector(7 downto 0);
        variable data_vector : std_logic_vector(16 downto 0);
        variable frame_size : integer := 2;
begin
        data_vector := (others => '0');
        send_bits(data_vector(15 downto 8),'1', data_period, serial_in_signal);
        send_bits(data_vector(7 downto 0),'1', data_period, serial_in_signal);
end procedure send_switch_frame;
-------------------------------------------------------------------------------------


  component uart_to_hdmi_adapter
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         micro_data_in : in std_logic;
         tmds_data2 : out std_logic;
         tmds_data1 : out std_logic;
         tmds_data0 : out std_logic;
         tmds_clock : out std_logic;
         address_one : out std_logic_vector(19 downto 0);
         address_two : out std_logic_vector(19 downto 0);
         write_enable : out std_logic_vector(1 downto 0);
         data1_in : in std_logic_vector(31 downto 0);
         data1_out : out std_logic_vector(31 downto 0);
         data2_in : in std_logic_vector(31 downto 0);
         data2_out : out std_logic_vector(31 downto 0);
         output_enable : out std_logic_vector(1 downto 0);
         busy : out std_logic;
         system_in_error : out std_logic
    );
  end component;

  
    component scalable_off_chip_sram is
    generic (
            -- Memory Model parameters
            ADDR_SIZE_BITS  : natural  := 12;  
                                               
            WORD_SIZE_BYTES  : natural  := 1;     
            DATA_SIZE_WORDS  : natural  := 1;      -- Data bus size in "words"
            READ_DELAY      : time    := 10 ns; 
                                                
            WRITE_DELAY      : time    := 10 ns   
                                               
          );
  port   (
          -- Test bench control signals
          mem_clr        : in  boolean;
          mem_init      : in  boolean;
          mem_dump      : in  boolean;
          verbose        : in  boolean;
          init_filename  : in   string;
          dump_filename  : in   string;
          start_address  : in  natural;
          last_address  : in  natural;
          
          -- Memory interface signals
          r_enable  : in    std_logic;
          w_enable  : in    std_logic;
          
          addr      : in    std_logic_vector((ADDR_SIZE_BITS-1) downto 0);
          data      : inout  std_logic_vector( ((data_size_words * word_size_bytes * 8) - 1) downto 0)


        );
  end component scalable_off_chip_sram;


  
-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal micro_data_in : std_logic;
  signal tmds_data2 : std_logic;
  signal tmds_data1 : std_logic;
  signal tmds_data0 : std_logic;
  signal tmds_clock : std_logic;
  signal address_one : std_logic_vector(19 downto 0);
  signal address_two : std_logic_vector(19 downto 0);
  signal write_enable : std_logic_vector(1 downto 0);
  signal data1_in : std_logic_vector(31 downto 0);
  signal data1_out : std_logic_vector(31 downto 0);
  signal data2_in : std_logic_vector(31 downto 0);
  signal data2_out : std_logic_vector(31 downto 0);
  signal output_enable : std_logic_vector(1 downto 0);
  signal busy : std_logic;
  signal system_in_error : std_logic;

-- signal <name> : <type>;
  -- sram signal
   -- signal declarations for SRAM
     -- Test bench control signals
  
     signal tb_mem_clr: boolean;
     signal tb_mem_init: boolean;
    signal  tb_mem_dump: boolean;
  
    signal  tb_verbose: boolean; 
    signal  tb_init_filename:string(24 downto 1);
    signal  tb_dump_filename: string(24 downto 1);
    signal  tb_start_address: natural;
   signal  tb_last_address: natural;
  
   signal sr_data : std_logic_vector(31 downto 0);

-- signal for sram 2
   signal tb_mem_clr_two: boolean;
     signal tb_mem_init_two: boolean;
    signal  tb_mem_dump_two: boolean;
    signal sr_data_2 : std_logic_vector(31 downto 0);

  


  -- constant for all sram

  
    constant     TB_ADDR_SIZE_BITS : natural  := 21;			
     constant   TB_WORD_SIZE_BYTES	 : natural  := 2; 	
    constant    TB_DATA_SIZE_WORDS	: natural  := 2; 	
    constant    TB_CLK_PERIOD  : time    := 10 ns;
     
   constant   TB_MAX_ADDRESS : natural :=1036800;          
      


  
begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: uart_to_hdmi_adapter port map(
                clk => clk,
                rst => rst,
                micro_data_in => micro_data_in,
                tmds_data2 => tmds_data2,
                tmds_data1 => tmds_data1,
                tmds_data0 => tmds_data0,
                tmds_clock => tmds_clock,
                address_one => address_one,
                address_two => address_two,
                write_enable => write_enable,
                data1_in => data1_in,
                data1_out => data1_out,
                data2_in => data2_in,
                data2_out => data2_out,
                output_enable => output_enable,
                busy => busy,
                system_in_error => system_in_error
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

--#####################          SRAM 1                    ##################################
--#####################################################################################################################
--#####################################################################################################################
  
  Memory: scalable_off_chip_sram
   generic map (
                  -- Memory interface parameters
                  ADDR_SIZE_BITS  => TB_ADDR_SIZE_BITS,				-- Set the address length in bits
                  WORD_SIZE_BYTES  => TB_WORD_SIZE_BYTES,			-- Set the word size in Bytes
                  DATA_SIZE_WORDS  => TB_DATA_SIZE_WORDS,			-- Set the data access size in words (how many words do you want to access each time)
                  READ_DELAY      => (TB_CLK_PERIOD - 2 ns),  -- CLK is 2 ns longer than access delay for conservative padding for flipflop setup times and propagation delays from the external SRAM chip to the internal flipflops
                  WRITE_DELAY      => (TB_CLK_PERIOD - 2 ns)  -- CLK is 2 ns longer than access delay for conservative padding for Real SRAM hold times and propagation delays from the internal flipflops to the external SRAM chip
                )

    
    port map  (
                -- Test bench control signals
                mem_clr        => tb_mem_clr,
                mem_init      => tb_mem_init,
                mem_dump      => tb_mem_dump,
                verbose        => tb_verbose,
                init_filename  => tb_init_filename,
                dump_filename  => tb_dump_filename,
                start_address  => tb_start_address,
                last_address  => tb_last_address,
                
                -- Memory interface signals
                r_enable  => output_enable(0),
                w_enable  => write_enable(0),
                addr(20 downto 1)      => address_one,
                addr(0)   => '0',
                data      => sr_data
              );

--#####################          SRAM 2                    ##################################
--#####################################################################################################################
--#####################################################################################################################
  
  Memory2: scalable_off_chip_sram
   generic map (
                  -- Memory interface parameters
                  ADDR_SIZE_BITS  => TB_ADDR_SIZE_BITS,				-- Set the address length in bits
                  WORD_SIZE_BYTES  => TB_WORD_SIZE_BYTES,			-- Set the word size in Bytes
                  DATA_SIZE_WORDS  => TB_DATA_SIZE_WORDS,			-- Set the data access size in words (how many words do you want to access each time)
                  READ_DELAY      => (TB_CLK_PERIOD - 2 ns),  -- CLK is 2 ns longer than access delay for conservative padding for flipflop setup times and propagation delays from the external SRAM chip to the internal flipflops
                  WRITE_DELAY      => (TB_CLK_PERIOD - 2 ns)  -- CLK is 2 ns longer than access delay for conservative padding for Real SRAM hold times and propagation delays from the internal flipflops to the external SRAM chip
                )

    
    port map  (
                -- Test bench control signals
                mem_clr        => tb_mem_clr_two,
                mem_init      => tb_mem_init_two,
                mem_dump      => tb_mem_dump_two,
                verbose        => tb_verbose,
                init_filename  => tb_init_filename,
                dump_filename  => tb_dump_filename,
                start_address  => tb_start_address,
                last_address  => tb_last_address,
                
                -- Memory interface signals
                r_enable  => output_enable(1),
                w_enable  => write_enable(1),
                addr(20 downto 1)      => address_two,
                addr(0)   => '0',
                data      => sr_data_2
              );

--#####################################################################################################################
--#####################          SRAM 1    process                ##################################
--#####################################################################################################################
  
  IO_DATA: process (output_enable(0), write_enable(0), sr_data, data1_in)
  begin
    if (output_enable(0) = '1') then
      -- Read mode -> the data pins should connect to the r_data bus & the other bus should float
      data1_out  <= sr_data;
      sr_data        <= (others=>'Z');
    elsif(write_enable(0)= '1') then
      -- Write mode -> the data pins should connect to the w_data bus & the other bus should float
      data1_out  <= (others=>'Z');
      sr_data  <= data1_in;
    else
      -- Disconnect both busses
      data1_out  <= (others=>'Z');
      sr_data        <= (others=>'Z');
    end if;
  end process IO_DATA;

--#####################################################################################################################
--#####################          SRAM 2    process                ##################################
--#####################################################################################################################
  
  IO_DATA_2: process (output_enable(1), write_enable(1), sr_data_2, data2_in)
  begin
    if (output_enable(1) = '1') then
      -- Read mode -> the data pins should connect to the r_data bus & the other bus should float
      data2_out  <= sr_data_2;
      sr_data_2        <= (others=>'Z');
    elsif(write_enable(1) = '1') then
      -- Write mode -> the data pins should connect to the w_data bus & the other bus should float
      data2_out  <= (others=>'Z');
      sr_data_2  <= data2_in;
    else
      -- Disconnect both busses
      data2_out  <= (others=>'Z');
      sr_data_2        <= (others=>'Z');
    end if;
  end process IO_DATA_2;





process

    variable frame2d : input_2dframe;
    variable frame3d : input_3dframe;
    variable value : integer;
  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    micro_data_in <= '0';
    data1_in <= (others => '0');
    data2_in <= (others => '0');
    wait for Period/2 + 1 ns;
    rst <= '0';

    -- test 2d frame.
    frame2d.x := 120;
    frame2d.y := 20;
    frame2d.w := 100;
    frame2d.h := 120;
    frame2d.color.red := 255;
    frame2d.color.green := 255;
    frame2d.color.blue := 255;
    send_2d_frame(frame2d, DATA_PERIOD,micro_data_in);

    -- test 3d frame.
    value := 20;
    frame3d.vertices := 
        ( (-value,-2*value,-value,"0000000010001010"), (-value,2*value,-value,"0000000001000100"), (value,2*value,-value,"0000000000101000"),
          (value,-2*value,-value,"0000000000010000"), (value,2*value,value,"0000000010100000"), (-value,2*value,value,"0000000001000000"),
          (-value,-2*value,value,"0000000010000000"), (0,0,0,"0000000000000000"), (0,0,0,"0000000000000000"),
          (0,0,0,"0000000000000000"), (0,0,0,"0000000000000000"), (0,0,0,"0000000000000000"),
          (0,0,0,"0000000000000000"), (0,0,0,"0000000000000000"), (0,0,0,"0000000000000000"),
          (0,0,0,"0000000000000000") );
    frame3d.num_verts := 8;
    frame3d.sin.x := "0010000000000000"; -- 1/2 in binary fraction.
    frame3d.sin.y := "0010000000000000"; -- 1/2 in binary fraction.
    frame3d.sin.z := "0010000000000000";  -- 1/2 in binary fraction.
    frame3d.cos.x := "0011011101101110"; -- sqrt(3)/2 in binary fraction.
    frame3d.cos.y := "0011011101101110"; -- sqrt(3)/2 in binary fraction.
    frame3d.cos.z := "0011011101101110"; -- sqrt(3)/2 in binary fraction.
    frame3d.offset.x := 50;
    frame3d.offset.y := 50;
    frame3d.offset.z := 50;
    frame3d.color.red := 255;
    frame3d.color.green := 0;
    frame3d.color.blue := 255;
    send_3d_frame(frame3d, DATA_PERIOD,micro_data_in);

    wait for 8 us;

  end process;
end TEST;
