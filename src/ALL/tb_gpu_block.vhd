-- $Id: $
-- File name:   tb_gpu_block.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_gpu_block is
generic (Period : Time := 4 ns);
end tb_gpu_block;

architecture TEST of tb_gpu_block is

  function UINT_TO_STDV( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_unsigned(X, NumBits));
  end;

  function SINT_TO_STDV( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_signed(X, NumBits));
  end;

  function STDV_TO_UINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(unsigned(x));
  end;

  type point is 
  record
    x : integer;
    y : integer;
    connection : std_logic_vector(15 downto 0);
  end record;

  type coords is array(15 downto 0) of point;

  type input_frame is
  record
    coordinates : coords;
    num_vertices: integer;
    control     : std_logic_vector(2 downto 0);
    red         : integer;
    green       : integer;
    blue        : integer;
  end record;

  component gpu_block
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         read_frame : in std_logic;
         pixel_done : in std_logic;
         control_in : in std_logic_vector(2 downto 0);
         num_vertices_in : in std_logic_vector(7 downto 0);
         color_in : in std_logic_vector(23 downto 0);
         vertices_in : in std_logic_vector(767 downto 0);
         computation_done : out std_logic;
         pixel_ready : out std_logic;
         data_in : out std_logic_vector(23 downto 0);
         address_in : out std_logic_vector(19 downto 0)
    );
  end component;

  procedure insert_frame( 
         frame             : in input_frame;
         signal read_frame : out std_logic;
         signal pixel_done : out std_logic; -- tell gpu that sram is done with pixel.
         signal control_in : out std_logic_vector(2 downto 0);
         signal num_vertices_in : out std_logic_vector(7 downto 0);
         signal color_in : out std_logic_vector(23 downto 0);
         signal vertices_in : out std_logic_vector(767 downto 0);
         signal computation_done : in std_logic;
         signal pixel_ready : in std_logic;
         signal data_in : in std_logic_vector(23 downto 0);
         signal address_in : in std_logic_vector(19 downto 0)
         ) is
  begin
    -- initialize all of the variables.
    control_in <= frame.control;
    color_in <= UINT_TO_STDV(frame.red,8) & UINT_TO_STDV(frame.green,8) & UINT_TO_STDV(frame.blue,8);
    -- Assign the vertices appropriately.
    for i in 0 to 15 loop
        vertices_in(767 -i*48 downto 768-48-i*48 )  <= frame.coordinates(15-i).connection & SINT_TO_STDV(frame.coordinates(i).x,16) & SINT_TO_STDV(frame.coordinates(15-i).y,16);
        report integer'image(767 - i*48) & " downto " & integer'image(768-48-i*48);
        report integer'image(frame.coordinates(i).x) & "," & integer'image(frame.coordinates(i).y);
    end loop;
    num_vertices_in <= UINT_TO_STDV(frame.num_vertices,8);

    -- Tell the gpu to read in the frame.
    read_frame <= '1';
    wait for 2*Period;
    read_frame <= '0';
    if (computation_done = '1') then
        report "Error: computation should not be done.";
    end if;

    while computation_done = '0' loop
        while pixel_ready = '0' loop
            wait for Period;
        end loop;
        -- simulate the sram writing.
        wait for 3*Period; -- approx 10 ns.
        pixel_done <= '1';
        wait for Period;
        pixel_done <= '0';
    end loop;

    report "Done with computation.";
    wait for Period;
    
  end procedure insert_frame;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal read_frame : std_logic;
  signal pixel_done : std_logic;
  signal control_in : std_logic_vector(2 downto 0);
  signal num_vertices_in : std_logic_vector(7 downto 0);
  signal color_in : std_logic_vector(23 downto 0);
  signal vertices_in : std_logic_vector(767 downto 0);
  signal computation_done : std_logic;
  signal pixel_ready : std_logic;
  signal data_in : std_logic_vector(23 downto 0);
  signal address_in : std_logic_vector(19 downto 0);

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: gpu_block port map(
                clk => clk,
                rst => rst,
                read_frame => read_frame,
                pixel_done => pixel_done,
                control_in => control_in,
                num_vertices_in => num_vertices_in,
                color_in => color_in,
                vertices_in => vertices_in,
                computation_done => computation_done,
                pixel_ready => pixel_ready,
                data_in => data_in,
                address_in => address_in
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

    variable frame : input_frame;
  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    read_frame <= '0';
    pixel_done <= '0';
    control_in <= (others => '0');
    num_vertices_in <= (others => '0');
    color_in <= (others => '0');
    vertices_in <= (others => '0');
    wait for Period/2;
    rst <= '0';

    frame.red := 255;
    frame.green := 255;
    frame.blue := 255;
    frame.control := "001";
    frame.num_vertices := 8;
    frame.coordinates := ( (16,7,"0000000010001010"), (3,20,"0000000001000100"), (7,32,"0000000000101000"), (20,19,"0000000000010000"),
                           (17,19,"0000000010100000"), (9,27,"0000000001000000"), (6,20,"0000000010000000"), (14,12,"0000000000000000"),
                           (0,0,"0000000000000000"), (0,0,"0000000000000000"), (0,0,"0000000000000000"), (0,0,"0000000000000000"),
                           (0,0,"0000000000000000"), (0,0,"0000000000000000"), (0,0,"0000000000000000"), (0,0,"0000000000000000") );
    --frame.coordinates := ( (0,0,"00000000"), (0,0,"00000000"), (0,0,"00000000"), (0,0,"00000000"),
     --                      (0,0,"00000000"), (0,0,"00000000"), (0,0,"00000000"), (0,0,"00000000"),
     --                      (0,0,"00000000"), (0,0,"00000000"), (0,0,"00000000"), (0,0,"00000000"),
     --                      (0,0,"00000000"), (0,0,"00000000"), (0,0,"00000000"), (0,0,"00000000") );
    -- build a frame, then send it to the GPU.
    -- 1 is 3d mode, 2 is 2d mode, 3 and 4 are other 2d mode
    insert_frame(frame, read_frame, pixel_done, control_in, num_vertices_in, color_in, vertices_in, computation_done, pixel_ready, data_in, address_in );
    wait for Period;

  end process;
end TEST;
