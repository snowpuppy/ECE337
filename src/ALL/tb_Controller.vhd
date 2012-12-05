-- $Id: $
-- File name:   tb_Controller.vhd
-- Created:     11/22/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_Controller is
end tb_Controller;

architecture TEST of tb_Controller is

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

  component Controller
    PORT(
         data_ready : in std_logic;
         clk : in std_logic;
         rst_n : in std_logic;
         encode_en : out std_logic;
         Timer_done : in std_logic;
         need_data : out std_logic;
         tx_shift : out std_logic;
         tx_load : out std_logic;
         data_sel : out std_logic;
         ctrl : in std_logic
    );
  end component;

-- Insert signals Declarations here
  signal data_ready : std_logic;
  signal clk : std_logic;
  signal rst_n : std_logic;
  signal encode_en : std_logic;
  signal Timer_done : std_logic;
  signal need_data : std_logic;
  signal tx_shift : std_logic;
  signal tx_load : std_logic;
  signal data_sel : std_logic;
  signal ctrl : std_logic;

-- signal <name> : <type>;

begin

CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 5 ns ;
end process;




  
  DUT: Controller port map(
                data_ready => data_ready,
                clk => clk,
                rst_n => rst_n,
                encode_en => encode_en,
                Timer_done => Timer_done,
                need_data => need_data,
                tx_shift => tx_shift,
                tx_load => tx_load,
                data_sel => data_sel,
                ctrl => ctrl
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here

    data_ready <= '0';
    --clk <= '0';
    rst_n <= '0';
    Timer_done <='0'; 
    ctrl <= '0';

    wait for 5 ns;

    rst_n <= '1';
    wait for 10 ns;

    data_ready <= '1';

    wait for 20 ns;

    data_ready <= '0';

    wait for 50 ns;

    data_ready <= '1';

    wait for 50 ns;

    data_ready <= '0';

    timer_done <= '1';

    wait for 50 ns;

    timer_done <='1';
    data_ready <= '1';

    wait for 300 ns;
    
    

    

  end process;
end TEST;
