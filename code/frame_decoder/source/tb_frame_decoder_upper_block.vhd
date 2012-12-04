-- $Id: $
-- File name:   tb_frame_decoder_upper_block.vhd
-- Created:     12/3/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_frame_decoder_upper_block is
generic (Period : Time := 4 ns);
end tb_frame_decoder_upper_block;

architecture TEST of tb_frame_decoder_upper_block is

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

  component frame_decoder_upper_block
    PORT(
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
         color_rx_data : out std_logic_vector(23 downto 0);
         frame_decoder_rx_data : out std_logic_vector(767 downto 0)
    );
  end component;
-------------------------------------------------------------------------------------- 
  procedure send_byte (
    numbers               : in integer; --numbers of byte  max is 148 
    data_uart             : in std_logic_vector(1183 downto 0);
    reset_error           : in std_logic;
    signal data_ready     : out std_logic;
    signal data_in        : out std_logic_vector(7 downto 0)
    ) is
 
  begin
    for i in 0 to numbers-1 loop
     data_in <= data_uart(1183-i*8 downto 1184-8-i*8);
     wait for 316 ns;
     data_ready <= '1';
     wait for 4 ns;
     data_ready <= '0';
    end loop;
  end procedure;
--------------------------------------------------------------------------------------
  procedure test_send_2D1 (
    header1               : in std_logic_vector(7 downto 0);
    header2               : in std_logic_vector(7 downto 0);
    x                     : in integer;
    y                     : in integer;
    width                 : in integer;
    length                : in integer;
    color1                : in integer;
    color2                : in integer;
    color3                : in integer;
    signal busy                  : out std_logic;
    signal data_ready            : inout std_logic;
    signal system_framing_error  : out std_logic;
    signal system_overrun_error  : out std_logic;
    signal data_in               : inout std_logic_vector(7 downto 0);
    control               : in std_logic_vector(2 downto 0);
    data_read             : in std_logic;
    switch_buffer         : in std_logic;
    reset_error           : in std_logic;
    frame_done            : in std_logic;
    num_vertices          : in std_logic_vector(7 downto 0);
    color_rx_data         : in std_logic_vector(23 downto 0);
    frame_decoder_rx_data : in std_logic_vector(767 downto 0)
    ) is
 
   variable data_come_in  : std_logic_vector(1183 downto 0);
	 variable intermediat : std_logic_vector(13*8-1 downto 0);
   variable color    : std_logic_vector(23 downto 0); 
   variable coordinate : std_logic_vector(63 downto 0);
	 variable zero_frame : std_logic_vector((1183-13*8) downto 0);
   variable zero       : std_logic_vector((95-64) downto 0);
  begin
    color := UINT_TO_STDV(color1,8) & UINT_TO_STDV(color2,8) & UINT_TO_STDV(color3,8);
    coordinate := UINT_TO_STDV(x,16) & UINT_TO_STDV(y,16) & UINT_TO_STDV(width,16) & UINT_TO_STDV(length,16);

    intermediat := header1 & header2  & color &  coordinate;
    zero_frame := (others => '0');
    zero := (others => '0');
    data_come_in := intermediat & zero_frame;
    send_byte(13,data_come_in,reset_error,data_ready,data_in);
  
  wait for 316 ns;
    if not(frame_decoder_rx_data(95 downto 95-64+1) = coordinate) then
      report "coorindate wrong";
    end if;
    if not(frame_decoder_rx_data(95-64 downto 0 ) = zero) then
      report "zero wrong";
    end if;
    if not (color_rx_data = color) then
      report "color wrong";
    end if;
 
   report  to_string(frame_decoder_rx_data(95 downto 0));
   report  to_string(coordinate & zero);
    

  end procedure;
-------------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------------
  procedure test_send_2D23 (
    header1               : in std_logic_vector(7 downto 0);
    header2               : in std_logic_vector(7 downto 0);
    x                     : in integer;
    y                     : in integer;
    width                 : in integer;
    length                : in integer;
    color11               : in integer;
    color12               : in integer;
    color13               : in integer;
    header3               : in std_logic_vector(7 downto 0);
    header4               : in std_logic_vector(7 downto 0);
    color21               : in integer;
    color22               : in integer;
    color23               : in integer;
    signal busy                  : out std_logic;
    signal data_ready            : inout std_logic;
    signal system_framing_error  : out std_logic;
    signal system_overrun_error  : out std_logic;
    signal data_in               : inout std_logic_vector(7 downto 0);
    control               : in std_logic_vector(2 downto 0);
    data_read             : in std_logic;
    switch_buffer         : in std_logic;
    reset_error           : in std_logic;
    frame_done            : in std_logic;
    num_vertices          : in std_logic_vector(7 downto 0);
    color_rx_data         : in std_logic_vector(23 downto 0);
    frame_decoder_rx_data : in std_logic_vector(767 downto 0)
    ) is
 
   variable data_come_in : std_logic_vector(1183 downto 0);
	 variable intermediat1 : std_logic_vector(13*8-1 downto 0);
   variable intermediat2 : std_logic_vector(39 downto 0);
   variable color1,color2  : std_logic_vector(23 downto 0); 
   variable coordinate : std_logic_vector(63 downto 0);
	 variable zero_frame : std_logic_vector((1183-13*8) downto 0);
   variable zero       : std_logic_vector((95-64) downto 0);
   variable azero      : std_logic_vector(1143 downto 0);
  begin
    color1 := UINT_TO_STDV(color11,8) & UINT_TO_STDV(color12,8) & UINT_TO_STDV(color13,8);
    color2 := UINT_TO_STDV(color21,8) & UINT_TO_STDV(color22,8) & UINT_TO_STDV(color23,8);

    coordinate := UINT_TO_STDV(x,16) & UINT_TO_STDV(y,16) & UINT_TO_STDV(width,16) & UINT_TO_STDV(length,16);

    intermediat1 := header1 & header2  & color1 &  coordinate;
    intermediat2 := header3 & header4  & color2;
    zero_frame := (others => '0');
    zero := (others => '0');
    data_come_in := intermediat1 & zero_frame;
    send_byte(13,data_come_in,reset_error,data_ready,data_in);
   
    wait for 316 ns;
    if not(frame_decoder_rx_data(95 downto 95-64+1) = coordinate) then
      report "coorindate wrong";
    end if;
    if not(frame_decoder_rx_data(95-64 downto 0 ) = zero) then
      report "zero wrong";
    end if;
    if not (color_rx_data = color1) then
      report "color2 wrong";
    end if;
 
   report  to_string(frame_decoder_rx_data(95 downto 0));
   report  to_string(coordinate & zero);

 
        data_come_in := intermediat2 & azero;
    send_byte(5,data_come_in,reset_error,data_ready,data_in);
  wait for 316 ns;
    if not (color_rx_data = color2) then
      report "color3 wrong";
    end if;
    

  end procedure;
-------------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------------
  procedure test_send_3D (
    header1               : in std_logic_vector(7 downto 0);
    header2               : in std_logic_vector(7 downto 0);
    x                     : in integer;
    y                     : in integer;
    width                 : in integer;
    length                : in integer;
    color11               : in integer;
    color12               : in integer;
    color13               : in integer;
    header3               : in std_logic_vector(7 downto 0);
    header4               : in std_logic_vector(7 downto 0);
    color21               : in integer;
    color22               : in integer;
    color23               : in integer;
    --header1               : in std_logic_vector(7 downto 0);
   -- header2               : in std_logic_vector(7 downto 0);
   -- cos                   : in integer;
   -- sin                   : in integer;
   -- color1                : in integer;
   -- color2                : in integer;
   -- color3                : in integer;
   -- offsetx1              : in std_logic_vector(7 downto 0);
   -- offsetx2              : in integer;
   -- offsety1              : in std_logic_vecotr(7 downto 0);
   -- offsety2              : in integer;
   -- offsetz1              : in std_logic_vecotr(7 downto 0);
   -- offsetz2              : in integer;
   -- pointx1               : in std_logic_vecotr(7 downto 0);
   -- pointy2               : in integer;
   -- pointy1               : in std_logic_vecotr(7 downto 0);
   -- pointy2               : in integer;
    --pointz1               : in std_logic_vecotr(7 downto 0);
    --pointz2               : in integer;
    signal busy                  : out std_logic;
    signal data_ready            : inout std_logic;
    signal system_framing_error  : out std_logic;
    signal system_overrun_error  : out std_logic;
    signal data_in               : inout std_logic_vector(7 downto 0);
    control               : in std_logic_vector(2 downto 0);
    data_read             : in std_logic;
    switch_buffer         : in std_logic;
    reset_error           : in std_logic;
    frame_done            : in std_logic;
    num_vertices          : in std_logic_vector(7 downto 0);
    color_rx_data         : in std_logic_vector(23 downto 0);
    frame_decoder_rx_data : in std_logic_vector(767 downto 0)
    ) is
 
   variable data_come_in : std_logic_vector(1183 downto 0);
	 variable intermediat1 : std_logic_vector(13*8-1 downto 0);
   variable intermediat2 : std_logic_vector(39 downto 0);
   variable color1,color2  : std_logic_vector(23 downto 0); 
   variable coordinate : std_logic_vector(63 downto 0);
	 variable zero_frame : std_logic_vector((1183-13*8) downto 0);
   variable zero       : std_logic_vector((95-64) downto 0);
   variable azero      : std_logic_vector(1143 downto 0);
  begin
    color1 := UINT_TO_STDV(color11,8) & UINT_TO_STDV(color12,8) & UINT_TO_STDV(color13,8);
    color2 := UINT_TO_STDV(color21,8) & UINT_TO_STDV(color22,8) & UINT_TO_STDV(color23,8);

    coordinate := UINT_TO_STDV(x,16) & UINT_TO_STDV(y,16) & UINT_TO_STDV(width,16) & UINT_TO_STDV(length,16);

    intermediat1 := header1 & header2  & color1 &  coordinate;
    intermediat2 := header3 & header4  & color2;
    zero_frame := (others => '0');
    zero := (others => '0');
    data_come_in := intermediat1 & zero_frame;
    send_byte(13,data_come_in,reset_error,data_ready,data_in);
   
    wait for 316 ns;
    if not(frame_decoder_rx_data(95 downto 95-64+1) = coordinate) then
      report "coorindate wrong";
    end if;
    if not(frame_decoder_rx_data(95-64 downto 0 ) = zero) then
      report "zero wrong";
    end if;
    if not (color_rx_data = color1) then
      report "color2 wrong";
    end if;
 
   report  to_string(frame_decoder_rx_data(95 downto 0));
   report  to_string(coordinate & zero);

 
        data_come_in := intermediat2 & azero;
    send_byte(5,data_come_in,reset_error,data_ready,data_in);
  wait for 316 ns;
    if not (color_rx_data = color2) then
      report "color3 wrong";
    end if;
    

  end procedure;
-------------------------------------------------------------------------------------- 
-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal busy : std_logic;
  signal data_ready : std_logic;
  signal system_framing_error : std_logic;
  signal system_overrun_error : std_logic;
  signal data_in : std_logic_vector(7 downto 0);
  signal control : std_logic_vector(2 downto 0);
  signal data_read : std_logic;
  signal switch_buffer : std_logic;
  signal reset_error : std_logic;
  signal frame_done : std_logic;
  signal num_vertices : std_logic_vector(7 downto 0);
  signal color_rx_data : std_logic_vector(23 downto 0);
  signal frame_decoder_rx_data : std_logic_vector(767 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: frame_decoder_upper_block port map(
                clk => clk,
                rst => rst,
                busy => busy,
                data_ready => data_ready,
                system_framing_error => system_framing_error,
                system_overrun_error => system_overrun_error,
                data_in => data_in,
                control => control,
                data_read => data_read,
                switch_buffer => switch_buffer,
                reset_error => reset_error,
                frame_done => frame_done,
                num_vertices => num_vertices,
                color_rx_data => color_rx_data,
                frame_decoder_rx_data => frame_decoder_rx_data
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    busy <= '0';
    data_ready <= '0';
    system_framing_error <= '0'; 
    system_overrun_error <= '0';
    data_in <= "00000000";
    wait for 2 ns;
   
    rst <= '0';

-- 2D1 good case

-- test_send_2D1 ("01000000","00001011",128,20,100,120,255,255,255,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );

--test_send_2D1 ("01000000","00001011",40564,64711,5679,764,154,96,214,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );

--2D1 wrong address case

--test_send_2D1 ("11100000","00001011",1564,64711,5679,764,154,96,214,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );

--2D1 wrong num byte case
--test_send_2D1 ("01000000","00101010",128,20,100,120,255,255,255,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data ); 

-- more 2D1 good case

--test_send_2D1 ("01000000","00001011",716,8103,4,48834,203,5,176,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );

--test_send_2D1 ("01000000","00001011",567,8193,12345,7902,110,209,48,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );

--2D23 correct case

test_send_2D23 ("01100000","00001011",1462,40397,1,468,255,255,255,"10000000","00000011",164,195,49,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );

--test_send_2D23 ("01100000","00001011",19843,9,16,3893,46,95,103,"10000000","00000011",58,255,67,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );

--wrong 2D2 control
--test_send_2D23 ("11100000","00001011",1462,40397,32771,468,255,255,255,"10000000","00000011",164,195,49,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );
--wrong 2D2 byte
--test_send_2D23 ("01100000","01010011",1462,40397,1,468,255,255,255,"10000000","00000011",164,195,49,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );
--wrong 2D3 control
--test_send_2D23 ("01100000","00001011",1462,40397,1,468,255,255,255,"00011000","00000011",164,195,49,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );
--wrong 2D3 byte
--test_send_2D23 ("01100000","00001011",1462,40397,1,32771,255,255,255,"10000000","00000010",164,195,49,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );
-- more 2D23 correct case
--test_send_2D23 ("01100000","00001011",789,666,4732,19564,0,56,189,"10000000","00000011",20,99,70,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );

--test_send_2D23 ("01100000","00001011",40312,78,5642,555,100,1,56,"10000000","00000011",78,36,94,busy,data_ready,system_framing_error,system_overrun_error,data_in, control,data_read,switch_buffer,reset_error,frame_done,num_vertices,color_rx_data,frame_decoder_rx_data );

  end process;
end TEST;
