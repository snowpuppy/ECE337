-- $Id: $
-- File name:   tb_frame_decoder_48to756_upper_block.vhd
-- Created:     11/30/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_frame_decoder_48to756_upper_block is
  generic (Period : Time := 4 ns);
end tb_frame_decoder_48to756_upper_block;

architecture TEST of tb_frame_decoder_48to756_upper_block is

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

  component frame_decoder_48to756_upper_block
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         threed_ready : in std_logic;
         twod_ready : in std_logic;
         framing_error : in std_logic;
         overrun_error : in std_logic;
         num_vertices : in std_logic_vector(7 downto 0);
         control : in std_logic_vector(2 downto 0);
         threed_data : in std_logic_vector(47 downto 0);
         twodonetwo_data : in std_logic_vector(47 downto 0);
         color_done : in std_logic;
         body_parsed : out std_logic;
         done : out std_logic;
         rx_data : out std_logic_vector(767 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal threed_ready : std_logic;
  signal twod_ready : std_logic;
  signal framing_error : std_logic;
  signal overrun_error : std_logic;
  signal num_vertices : std_logic_vector(7 downto 0);
  signal control : std_logic_vector(2 downto 0);
  signal threed_data : std_logic_vector(47 downto 0);
  signal twodonetwo_data : std_logic_vector(47 downto 0);
  signal color_done : std_logic;
  signal body_parsed : std_logic;
  signal done : std_logic;
  signal rx_data : std_logic_vector(767 downto 0);

-- signal <name> : <type>;

begin
    CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;
  DUT: frame_decoder_48to756_upper_block port map(
                clk => clk,
                rst => rst,
                threed_ready => threed_ready,
                twod_ready => twod_ready,
                framing_error => framing_error,
                overrun_error => overrun_error,
                num_vertices => num_vertices,
                control => control,
                threed_data => threed_data,
                twodonetwo_data => twodonetwo_data,
                color_done => color_done,
                body_parsed => body_parsed,
                done => done,
                rx_data => rx_data
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

	--reset stage	
	rst <= '1';
        threed_ready <= '0';
        twod_ready <= '0';
        framing_error <= '0';
        overrun_error <= '0';
        num_vertices <= "00000000";
        control <= "000";
        threed_data <= "000000000000000000000000000000000000000000000000";
        twodonetwo_data <= "000000000000000000000000000000000000000000000000";
        color_done <= '0';

	wait for 100 ns;
	color_done <= '1';
	rst <= '0';
	threed_data <= "111111111111111111111111111111111111111111111111";
        twodonetwo_data <= "111111111111111111111111111111111111111111111111";
	-- 3D wrong control or no ready signal
	control <= "111";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';
	wait for 316 ns;
	control <= "001";
	wait for 316 ns;

	-- 2D1 wrong control or no ready signal
	control <= "001";
	twod_ready <= '1';
	wait for 4 ns;
	twod_ready <= '0';
	wait for 316 ns;
	control <= "001";
	wait for 316 ns;

	-- 2D2 wrong control or no ready signal
	control <= "000";
	twod_ready <= '1';
	wait for 4 ns;
	twod_ready <= '0';
	wait for 316 ns;
	control <= "001";
	wait for 316 ns;


	--case 1 3D with 16 vertices
	num_vertices <= "00010000";
	control <= "001";
	--1 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--2 byte
	threed_data <= "010101101101000101011010101101010101000001110101";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--3 byte
	threed_data <= "110010101011011011001010101011010101000111001111";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--4 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;
	
	--5 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--6 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--7 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--8 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--9 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--10 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--11 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--12 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--13 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--14 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--15 byte
	threed_data <= "010110111000011101010000101010000011111011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--16 byte
	threed_data <= "010110111000000000000111111111111111100000000000";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;


       --case 7 3D with 4 vertices
	num_vertices <= "00000100";
	control <= "001";
	--1 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--2 byte
	threed_data <= "010101101101000101011010101101010101000001110101";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--3 byte
	threed_data <= "110010101011011011001010101011010101000111001111";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--4 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;


	--case 2 2D1 with 2 vertices
	control <= "010";
	--1 byte
	twodonetwo_data <= "000000000000000001111111111111000000000000000000";
	twod_ready <= '1';
	wait for 4 ns;
	twod_ready <= '0';	
	wait for 316 ns;

	--2 byte
	twodonetwo_data <= "111111111111100000000001111111110000000000111111";
	twod_ready <= '1';
	wait for 4 ns;
	twod_ready <= '0';	
	wait for 316 ns;

	--case 3 2D2 with 2 vertices
	control <= "011";
	--1 byte
	twodonetwo_data <= "000000000000000001111111111111000000000000000000";
	twod_ready <= '1';
	wait for 4 ns;
	twod_ready <= '0';	
	wait for 316 ns;

	--2 byte
	twodonetwo_data <= "111111111111100000000001111111110000000000111111";
	twod_ready <= '1';
	wait for 4 ns;
	twod_ready <= '0';	
	wait for 316 ns;


	--case 4 framing error
	control <= "010";
	--1 byte
	threed_data <= "000000000000000001111111111111000000000000000000";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	framing_error <= '1';
	wait for 4 ns;
	framing_error <= '0';
	wait for 316 ns;


	--case 5 over run error
	control <= "011";
	threed_data <= "111111111111100000000001111111110000000000111111";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	overrun_error <= '1';
	wait for 4 ns;
	overrun_error <= '0';
	wait for 316 ns;

        --case 6 3D with 11 vertices
	num_vertices <= "00001011";
	control <= "001";
	--1 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--2 byte
	threed_data <= "010101101101000101011010101101010101000001110101";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--3 byte
	threed_data <= "110010101011011011001010101011010101000111001111";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--4 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;
	
	--5 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--6 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--7 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--8 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--9 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--10 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;

	--11 byte
	threed_data <= "010110111000011101010000101010101010101011100001";
	threed_ready <= '1';
	wait for 4 ns;
	threed_ready <= '0';	
	wait for 316 ns;


	
	

  end process;
end TEST;
