-- $Id: $
-- File name:   tb_frame_decoder_2D12_upper_block.vhd
-- Created:     11/29/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_frame_decoder_2D12_upper_block is
  generic (Period : Time := 4 ns);
end tb_frame_decoder_2D12_upper_block;

architecture TEST of tb_frame_decoder_2D12_upper_block is

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

  component frame_decoder_2D12_upper_block
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         data_read : in std_logic;
         input_sel : in std_logic;
         framing_error : in std_logic;
         overrun_error : in std_logic;
         data_in : in std_logic_vector(7 downto 0);
         control : in std_logic_vector(2 downto 0);
         ready2 : out std_logic;
         clk_in_color : out std_logic;
         rx_data : out std_logic_vector(47 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal data_read : std_logic;
  signal input_sel : std_logic;
  signal framing_error : std_logic;
  signal overrun_error : std_logic;
  signal data_in : std_logic_vector(7 downto 0);
  signal control : std_logic_vector(2 downto 0);
  signal ready2 : std_logic;
  signal clk_in_color : std_logic;
  signal rx_data : std_logic_vector(47 downto 0);

-- signal <name> : <type>;

begin
    CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;
  DUT: frame_decoder_2D12_upper_block port map(
                clk => clk,
                rst => rst,
                data_read => data_read,
                input_sel => input_sel,
                framing_error => framing_error,
                overrun_error => overrun_error,
                data_in => data_in,
                control => control,
                ready2 => ready2,
                clk_in_color => clk_in_color,
                rx_data => rx_data
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

	--rst stage
	rst <= '1';
	data_read <= '0';
	input_sel <= '0';
	framing_error <= '0';
	overrun_error <= '0';
	data_in <= "00000000";
	control <= "000";
	wait for 316 ns;

	--wrong sel
	rst <= '0';
	input_sel <= '0';
	data_in <= "01101111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	input_sel <= '1';
	--wrong 3D control
	control <= "001";
	data_in <= "10100001";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--wrong 2D3 control
	control <= "100";
	data_in <= "00000000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--wrong switch control
	control <= "000";
	data_in <= "00000000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--case 1 2D1 control
	--1 byte
	control <= "010";
	data_in <= "10011111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--2 byte
	data_in <= "01101011";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--3 byte
	data_in <= "10101011";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--4 byte
	data_in <= "11110000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--5 byte
	data_in <= "10010000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--6 byte
	data_in <= "10000001";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--7 byte
	data_in <= "10101010";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--8 byte
	data_in <= "01101011";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--9 byte
	data_in <= "11110111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--10 byte
	data_in <= "10101111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--11 byte
	data_in <= "00101111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

------------------------------------------------------------
	--case 2 2D2 control
	--1 byte
	control <= "011";
	data_in <= "11001111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--2 byte
	data_in <= "01010101";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--3 byte
	data_in <= "00001111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--4 byte
	data_in <= "01101101";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--5 byte
	data_in <= "10010000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--6 byte
	data_in <= "10000001";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--7 byte
	data_in <= "01111000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--8 byte
	data_in <= "01000111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--9 byte
	data_in <= "00000001";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--10 byte
	data_in <= "01101110";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--11 byte
	data_in <= "11011111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--framing error
	--1 byte
	control <= "011";
	data_in <= "01111011";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--2 byte
	data_in <= "11111111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
  	wait for 316 ns;
	framing_error <= '1';
	wait for 4 ns;
	framing_error <= '0';
	wait for 316 ns;
	
	--over run error
	--1 byte
	control <= "011";
	data_in <= "10101001";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;

	--2 byte
	data_in <= "00000000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
  	wait for 316 ns;
	overrun_error <= '1';
	wait for 4 ns;
	overrun_error <= '0';
	wait for 316 ns;

  end process;
end TEST;
