-- $Id: $
-- File name:   tb_frame_decoder_coord_flattener_upper_block.vhd
-- Created:     11/30/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_frame_decoder_coord_flattener_upper_block is
    generic (Period : Time := 4 ns);
end tb_frame_decoder_coord_flattener_upper_block;

architecture TEST of tb_frame_decoder_coord_flattener_upper_block is

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

  component frame_decoder_coord_flattener_upper_block
    PORT(
         clk : in std_logic;
         rst : in std_logic;
         data_read : in std_logic;
         reset_error : in std_logic;
         threed_enable : in std_logic_vector(1 downto 0);
         data_in : in std_logic_vector(7 downto 0);
         connection : in std_logic_vector(15 downto 0);
         num_vertices : in std_logic_vector(7 downto 0);
         result : out std_logic_vector(47 downto 0);
         ready1 : out std_logic;
         throw_frame : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst : std_logic;
  signal data_read : std_logic;
  signal reset_error : std_logic;
  signal threed_enable : std_logic_vector(1 downto 0);
  signal data_in : std_logic_vector(7 downto 0);
  signal connection : std_logic_vector(15 downto 0);
  signal num_vertices : std_logic_vector(7 downto 0);
  signal result : std_logic_vector(47 downto 0);
  signal ready1 : std_logic;
  signal throw_frame : std_logic;

-- signal <name> : <type>;

begin
    CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for Period/2;
end process;
  DUT: frame_decoder_coord_flattener_upper_block port map(
                clk => clk,
                rst => rst,
                data_read => data_read,
                reset_error => reset_error,
                threed_enable => threed_enable,
                data_in => data_in,
                connection => connection,
                num_vertices => num_vertices,
                result => result,
                ready1 => ready1,
                throw_frame => throw_frame
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

	--rst
   	rst <= '1';
   	data_read <= '0';
    	reset_error <= '0';
    	threed_enable <= "11";
    	data_in <= "11111111";
    	connection <= "1111111111111111";
    	num_vertices <= "00000001";
	wait for 316 ns;
        wait for 2 ns;
	rst <= '0';
        wait for 4 ns;

	threed_enable <= "01";
--all correct 2 vertices but dont know about if error will occur or not
	num_vertices <= "00000010";
	connection <= "1010101110101011";
	--case 1


	-- sin 1
       --1 byte
	data_in <= "10011010";
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
        data_in <= "10000010";
        data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
        wait for 316 ns;
        --4 byte
        data_in <= "01111110";
        data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
        wait for 316 ns;
        --5 byte
        data_in <= "01010110";
        data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
        wait for 316 ns;
        --6 byte
        data_in <= "10111100";
        data_read <= '1';
        wait for 4 ns;
        data_read <= '0';
        wait for 316 ns;

       --cosine 2
       --7 byte
       data_in <= "10011111";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --8 byte
       data_in <= "00000001";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --9 byte
       data_in <= "01101111";
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
       data_in <= "00000000";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --12 byte
       data_in <= "10000100";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

	--offset x 1
       --13 byte
       data_in <= "00000111";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --14 byte
       data_in <= "01110111";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

	--offset y 1
       --15 byte
       data_in <= "11111110";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --16 byte
       data_in <= "10000000";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

	--offset z 1
       --17 byte
       data_in <= "11111000";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --18 byte
       data_in <= "00101010";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;


	--direction done
	--connection 1
      threed_enable <= "00";
       --19 byte
       data_in <= "10101011";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --20 byte
       data_in <= "10101001";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

	connection <= "1010101110101001";

	--point x 1
       threed_enable <= "01";
       --21 byte
       data_in <= "00000111";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --22 byte
       data_in <= "01011011";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

	-- point y  1
       --23 byte
       data_in <= "11111010";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --24 byte
       data_in <= "10100111";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

	-- point z 1
      --25 byte
       data_in <= "11111010";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --26 byte
       data_in <= "01101011";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

-------------------------------------------------
	--connection 2
      threed_enable <= "00";
       --27 byte
       data_in <= "10011101";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --28 byte
       data_in <= "10010100";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

 	connection <= "1001110110010100";

	--point x 2
       threed_enable <= "01";
       --29 byte
       data_in <= "00000101";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --30 byte
       data_in <= "10101110";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

	-- point y  2
       --31 byte
       data_in <= "11111111";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --32 byte
       data_in <= "01010110";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;

	-- point z 2
      --33 byte
       data_in <= "11111010";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait for 316 ns;
       --34 byte
       data_in <= "01010101";
       data_read <= '1';
       wait for 4 ns;
       data_read <= '0';
       wait;



  end process;
end TEST;
