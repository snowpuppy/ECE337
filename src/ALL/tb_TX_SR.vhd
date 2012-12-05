-- $Id: $
-- File name:   tb_TX_SR.vhd
-- Created:     11/20/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_TX_SR is
end tb_TX_SR;

architecture TEST of tb_TX_SR is

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

  component TX_SR
    PORT(
         clock_me : in std_logic;
         rst_n : in std_logic;
         tx_shift : in std_logic;
         data_sel : in std_logic;
         tx_load : in std_logic;
         R : in std_logic_vector(9 downto 0);
         G : in std_logic_vector(9 downto 0);
         B : in STD_LOGIC_VECTOR(9 downto 0);
         H_VSYNC : in STD_LOGIC_VECTOR(9 downto 0);
         CTL0_1 : in STD_LOGIC_VECTOR(9 downto 0);
         CTL2_3 : in STD_LOGIC_VECTOR(9 downto 0);
         RO : out std_logic;
         GO : out std_logic;
         BO : out STD_LOGIC
    );
  end component;

-- Insert signals Declarations here
  signal clock_me : std_logic;
  signal rst_n : std_logic;
  signal tx_shift : std_logic;
  signal data_sel : std_logic;
  signal tx_load : std_logic;
  signal R : std_logic_vector(9 downto 0);
  signal G : std_logic_vector(9 downto 0);
  signal B : STD_LOGIC_VECTOR(9 downto 0);
  signal H_VSYNC : STD_LOGIC_VECTOR(9 downto 0);
  signal CTL0_1 : STD_LOGIC_VECTOR(9 downto 0);
  signal CTL2_3 : STD_LOGIC_VECTOR(9 downto 0);
  signal RO : std_logic;
  signal GO : std_logic;
  signal BO : STD_LOGIC;

-- signal <name> : <type>;




  begin
CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clock_me <= clk_tmp;
  wait for 5 ns ;
end process;






  
  DUT: TX_SR port map(
                clock_me => clock_me,
                rst_n => rst_n,
                tx_shift => tx_shift,
                data_sel => data_sel,
                tx_load => tx_load,
                R => R,
                G => G,
                B => B,
                H_VSYNC => H_VSYNC,
                CTL0_1 => CTL0_1,
                CTL2_3 => CTL2_3,
                RO => RO,
                GO => GO,
                BO => BO
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here
    
            -- 0123456789 
   H_VSYNC <= "1100110001";
   CTL0_1  <= "1100110001";
   CTL2_3  <= "1100110001";
   
    --  0123456789 
   R <="1010101010";
   G <="1010101010";
   B <="1010101010";

   tx_shift <= '0';
   data_sel <= '0';
   tx_load <= '0';
   
    
   --RST

   rst_n <= '0';
   wait for 10 ns;
   rst_n <= '1';
   wait for 10 ns;

   tx_load <= '1';                       -- load the control signal
   data_sel <= '0';
                   
   wait for 10 ns;
   tx_load <= '0';
   for I  in 0 to 9 loop                -- shift 10 bit out
  
     tx_shift <= '1';
     wait for 10 ns;
     --tx_shift <= '0';
     --wait for 2.5 ns;
     
   end loop;  -- I

   wait for 10 ns;

   -- load pixel data;

   tx_load <= '1';
   data_sel <= '1';

   wait for 10 ns;
   tx_load <= '0';
    for I  in 0 to 9 loop                -- shift 10 bit out
 
     tx_shift <= '1';
     wait for 10 ns;
     --tx_shift <= '0';
     --wait for 5 ns;
     
   end loop;  -- I

   wait for 30 ns;
   
   

   
  end process;
end TEST;
