-- $Id: $
-- File name:   tb_frame_decoder_header_upper_block.vhd
-- Created:     11/27/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_frame_decoder_header_upper_block is
  generic (Period : Time := 4 ns);
end tb_frame_decoder_header_upper_block;

architecture TEST of tb_frame_decoder_header_upper_block is

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

  component frame_decoder_header_upper_block
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         overrun_error : in std_logic;
         framing_error : in std_logic;
         data_read : in std_logic;
         input_sel : in std_logic;
         frame_done : in std_logic;
         data_in : in std_logic_vector(7 downto 0);
         switch_buffer : out std_logic;
         valid_header : out std_logic;
         control : out std_logic_vector(2 downto 0);
         num_byte : out std_logic_vector(7 downto 0);
         num_vertices : out std_logic_vector(7 downto 0)
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal overrun_error : std_logic;
  signal framing_error : std_logic;
  signal data_read : std_logic;
  signal input_sel : std_logic;
  signal frame_done : std_logic;
  signal data_in : std_logic_vector(7 downto 0);
  signal switch_buffer : std_logic;
  signal valid_header : std_logic;
  signal control : std_logic_vector(2 downto 0);
  signal num_byte : std_logic_vector(7 downto 0);
  signal num_vertices : std_logic_vector(7 downto 0);

-- signal <name> : <type>;

begin
    CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;

  DUT: frame_decoder_header_upper_block port map(
                clk => clk,
                rst => rst,
                overrun_error => overrun_error,
                framing_error => framing_error,
                data_read => data_read,
                input_sel => input_sel,
                frame_done => frame_done,
                data_in => data_in,
                switch_buffer => switch_buffer,
                valid_header => valid_header,
                control => control,
                num_byte => num_byte,
                num_vertices => num_vertices
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    --rst,overrun_error,framing_error,data_read,input_sel,frame_done,data_in
     
        rst <= '1';
        framing_error <= '0';
        overrun_error <= '0';
        data_read <= '0';
        input_sel <= '0';
        frame_done <= '0';
        data_in <= "00000000";
        wait for 100 ns;
    	
	--switch case
	rst <= '0';
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_read <= '1';
	wait for 4 ns;
	data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--001 3D case 1
	data_in <= "00100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "01010101";  --85
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--001 3D case 2
	data_in <= "00100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "01101101";  --109
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--001 3D case 2
	data_in <= "00100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "00100101";  --109
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--010 2D1 case
	data_in <= "01000000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "00001011";  --11
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';
	
	--011 2D2 case
	data_in <= "01100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "00001011";  --11
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--100 2D3 case
	data_in <= "10000000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "00000011"; --3
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	-----------------
	--error case
	--switch error
	data_in <= "00000000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "00001011";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--3D over data error
	data_in <= "00100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "11111111";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--3D less data error
	data_in <= "00100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "00000000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--3D data cant divide by 8
	data_in <= "00100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "01001111"; --79
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--2D3 data not equal to 3
	data_in <= "10000000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "01001100";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--2D1 data not equal to 11
	data_in <= "01000000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "10101010";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--3D good 
	data_in <= "00100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "01010101";  --85
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

 	--framing error test
	data_in <= "01100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
        wait for 316 ns;
        framing_error <= '1';
        wait for 4 ns;
        framing_error <= '0';
        wait for 100 ns;


	--wrong address
	data_in <= "11100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
    	wait for 316 ns;
	data_in <= "01101010";   --106
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
	wait for 316 ns;
        frame_done <= '1';
        wait for 4 ns;
        frame_done <= '0';

	--over run error test
	data_in <= "00100000";
	data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
        wait for 316 ns;
        overrun_error <= '1';
	wait for 4 ns;
        overrun_error <= '0';
        wait for 100 ns;



  end process;
end TEST;
