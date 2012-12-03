-- $Id: $
-- File name:   tb_HDMI_Encoder.vhd
-- Created:     11/25/2012
-- Author:      Xiao Zuguang
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_HDMI_Encoder is
        generic (Period: Time:= 10 ns);
end tb_HDMI_Encoder;

architecture TEST of tb_HDMI_Encoder is

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

  component HDMI_Encoder
    PORT(
         clk : in std_logic;
         rst_n : in std_logic;
         pixel_data : in std_logic_vector(23 downto 0);
         data_ready : in std_logic;
         need_data : out std_logic;
         RO : out std_logic;
         GO : out std_logic;
         BO : out std_logic;
         TMDS_CLK : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst_n : std_logic;
  signal pixel_data : std_logic_vector(23 downto 0);
  signal data_ready : std_logic;
  signal need_data : std_logic;
  signal RO : std_logic;
  signal GO : std_logic;
  signal BO : std_logic;
  signal TMDS_CLK : std_logic;

-- signal <name> : <type>;

begin
  DUT: HDMI_Encoder port map(
                clk => clk,
                rst_n => rst_n,
                pixel_data => pixel_data,
                data_ready => data_ready,
                need_data => need_data,
                RO => RO,
                GO => GO,
                BO => BO,
                TMDS_CLK => TMDS_CLK
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

  CLKGEN:process
  variable clk_tmp: std_logic := '0';
  begin
    clk_tmp := not clk_tmp;
    CLK <= clk_tmp;
    wait for Period/2;
  end process;
---------------------------------------------------------

process

  begin

-- Insert TEST BENCH Code Here
rst_n <= '0';
wait for 100 ns;

    rst_n <= '1';

    pixel_data <= "111111111111111111111111";

    data_ready <= '1';
    wait for 100000000 ns;

  end process;
end TEST;
