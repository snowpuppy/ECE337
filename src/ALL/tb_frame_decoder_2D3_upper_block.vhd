-- $Id: $
-- File name:   tb_frame_decoder_2D3_upper_block.vhd
-- Created:     11/30/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_frame_decoder_2D3_upper_block is
  generic (Period : Time := 4 ns);
end tb_frame_decoder_2D3_upper_block;

architecture TEST of tb_frame_decoder_2D3_upper_block is

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

  component frame_decoder_2D3_upper_block
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         framing_error : in std_logic;
         overrun_error : in std_logic;
         input_sel : in std_logic;
         data_read : in std_logic;
         data_done : in std_logic;
         threed_clk_in : in std_logic;
         twodonetwo_clk_in : in std_logic;
         twodonetwo_block_sel : in std_logic;
         threed_block_sel : in std_logic_vector(1 downto 0);
         control : in std_logic_vector(2 downto 0);
         data_in : in std_logic_vector(7 downto 0);
         rx_data : out std_logic_vector(23 downto 0);
         done : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal framing_error : std_logic;
  signal overrun_error : std_logic;
  signal input_sel : std_logic;
  signal data_read : std_logic;
  signal data_done : std_logic;
  signal threed_clk_in : std_logic;
  signal twodonetwo_clk_in : std_logic;
  signal twodonetwo_block_sel : std_logic;
  signal threed_block_sel : std_logic_vector(1 downto 0);
  signal control : std_logic_vector(2 downto 0);
  signal data_in : std_logic_vector(7 downto 0);
  signal rx_data : std_logic_vector(23 downto 0);
  signal done : std_logic;

-- signal <name> : <type>;

begin
    CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;
  DUT: frame_decoder_2D3_upper_block port map(
                clk => clk,
                rst => rst,
                framing_error => framing_error,
                overrun_error => overrun_error,
                input_sel => input_sel,
                data_read => data_read,
                data_done => data_done,
                threed_clk_in => threed_clk_in,
                twodonetwo_clk_in => twodonetwo_clk_in,
                twodonetwo_block_sel => twodonetwo_block_sel,
                threed_block_sel => threed_block_sel,
                control => control,
                data_in => data_in,
                rx_data => rx_data,
                done => done
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

	--rst case
 	rst <= '1';
        data_done <= '0';
        framing_error <= '0';
        overrun_error <= '0';
        input_sel <= '0';
        data_read <= '0';
        threed_clk_in <= '0';
        twodonetwo_clk_in <= '0';
        twodonetwo_block_sel <= '0';
        threed_block_sel <= "00";
        control <= "000";
        data_in <= "11111111";
	wait for 100 ns;

	rst <= '0';
	data_done <= '1';

	--wrong sel case
	control <= "001";
	data_read <= '1';
	wait for 4 ns;
	data_read <= '0';
	wait for 316 ns;

	control <= "010";
	data_read <= '1';
	wait for 4 ns;
	data_read <= '0';
	wait for 316 ns;

	control <= "011";
	data_read <= '1';
	wait for 4 ns;
	data_read <= '0';
	wait for 316 ns;

	control <= "111";
	data_read <= '1';
	wait for 4 ns;
	data_read <= '0';
	wait for 316 ns;

	--good in sel but wrong control
	input_sel <= '1';
	control <= "000";
	data_read <= '1';
	wait for 4 ns;
	data_read <= '0';
	wait for 316 ns;

	control <= "111";
	data_read <= '1';
	wait for 4 ns;
	data_read <= '0';
	wait for 316 ns;

	control <= "110";
	data_read <= '1';
	wait for 4 ns;
	data_read <= '0';
	wait for 316 ns;

	--3D good control and sel but bad sel
	control <= "001";
        threed_block_sel <= "00";
        threed_clk_in <= '1';
	wait for 4 ns;
	threed_clk_in <= '0';
	wait for 316 ns;

        threed_block_sel <= "01";
        threed_clk_in <= '1';
	wait for 4 ns;
	threed_clk_in <= '0';
	wait for 316 ns;

	--3D in
        data_done <= '0';
	data_in <= "01010101";
        threed_block_sel <= "10";
        threed_clk_in <= '1';
	wait for 4 ns;
	threed_clk_in <= '0';
	wait for 316 ns;

	data_in <= "01011100";
        threed_clk_in <= '1';
	wait for 4 ns;
	threed_clk_in <= '0';
	wait for 316 ns;

	data_in <= "11011101";
        threed_clk_in <= '1';
	wait for 4 ns;
	threed_clk_in <= '0';
	wait for 316 ns;
        data_done <= '1';
	wait for 4 ns;
	data_done <= '0';

	--2D1 and 2D2 testing
	data_in <= "11111111";
	control <= "001";
        twodonetwo_block_sel <= '1';
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;

	control <= "010";
        twodonetwo_block_sel <= '0';
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;

	control <= "011";
        twodonetwo_block_sel <= '0';
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;

	control <= "000";
        twodonetwo_block_sel <= '1';
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;

	-- 2D1
	control <= "010";
	data_in <= "01010111";
        twodonetwo_block_sel <= '1';
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;

	data_in <= "10101101";
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;

	data_in <= "10101110";
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;
        data_done <= '1';
	wait for 4 ns;
	data_done <= '0';

	--2D2
	control <= "011";
	data_in <= "10101011";
        twodonetwo_block_sel <= '1';
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;

	data_in <= "00000111";
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;

	data_in <= "11110000";
	twodonetwo_clk_in <= '1';
	wait for 4 ns;
	twodonetwo_clk_in <= '0';
	wait for 316 ns;
        data_done <= '1';
	wait for 4 ns;
	data_done <= '0';

	--2D3
	control <= "100";
	data_in <= "01010111";
        data_read <= '1';
	wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;

	data_in <= "00001110";
        data_read <= '1';
	wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;

	data_in <= "01000101";
        data_read <= '1';
	wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;	


	--framing error
	--3D in
	control <= "001";
	data_in <= "01010101";
        threed_block_sel <= "10";
        threed_clk_in <= '1';
	wait for 4 ns;
	threed_clk_in <= '0';
	wait for 316 ns;

	data_in <= "01011100";
        threed_clk_in <= '1';
	wait for 4 ns;
	threed_clk_in <= '0';
	wait for 316 ns;

	framing_error <= '1';
	wait for 4 ns;
	framing_error <= '0';
	wait for 316 ns;

	--over run error

	--3D in
	control <= "001";
	data_in <= "01010101";
        threed_block_sel <= "10";
        threed_clk_in <= '1';
	wait for 4 ns;
	threed_clk_in <= '0';
	wait for 316 ns;

	data_in <= "01011100";
        threed_clk_in <= '1';
	wait for 4 ns;
	threed_clk_in <= '0';
	wait for 316 ns;
	
	overrun_error <= '1';
	wait for 4 ns;
	overrun_error <= '0';
	wait for 316 ns;

	
  end process;
end TEST;
