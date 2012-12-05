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

entity tb_uart_to_hdmi_adapter is
generic (Period : Time := 4 ns);
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

process

  begin

-- Insert TEST BENCH Code Here

    rst <= '1';
    micro_data_in <= '0';
    data1_in <= (others => '0');
    data2_in <= (others => '0');
    wait for Period/2;
    rst <= '0';

  end process;
end TEST;
