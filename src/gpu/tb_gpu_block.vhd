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

  function STDV_TO_UINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(unsigned(x));
  end;

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

  begin

-- Insert TEST BENCH Code Here

    rst <= '0';
    read_frame <= '0';
    pixel_done <= '0';
    control_in <= (others => '0');
    num_vertices_in <= (others => '0');
    color_in <= (others => '0');
    vertices_in <= (others => '0');
    wait for Period;

  end process;
end TEST;
