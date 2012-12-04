-- $Id: $
-- File name:   tb_ID_CONTR.vhd
-- Created:     11/20/2012
-- Author:      Xiao Zuguang
-- Lab Section: 337-02
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_ID_CONTR is
end tb_ID_CONTR;

architecture TEST of tb_ID_CONTR is

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
  
  
  component ID_CONTR
    PORT(
         row_num : in std_logic_vector(9 downto 0);
         pixel_loc : in std_logic_vector(9 downto 0);
         H_VSYNC : out std_logic_vector(9 downto 0);
         CTL0_1 : out std_logic_vector(9 downto 0);
         CTL2_3 : out std_logic_vector(9 downto 0);
         ctrl : out std_logic
    );
  end component;

-- Insert signals Declarations here
  signal row_num : std_logic_vector(9 downto 0);
  signal pixel_loc : std_logic_vector(9 downto 0);
  signal H_VSYNC : std_logic_vector(9 downto 0);
  signal CTL0_1 : std_logic_vector(9 downto 0);
  signal CTL2_3 : std_logic_vector(9 downto 0);
  signal ctrl : std_logic;

-- signal <name> : <type>;

begin
  DUT: ID_CONTR port map(
                row_num => row_num,
                pixel_loc => pixel_loc,
                H_VSYNC => H_VSYNC,
                CTL0_1 => CTL0_1,
                CTL2_3 => CTL2_3,
                ctrl => ctrl
                );

--   GOLD: <GOLD_NAME> port map(<put mappings here>);

process

  begin

-- Insert TEST BENCH Code Here
for I in 0 to 524 loop
  for K in 0 to 857 loop
    row_num <= UINT_TO_STDV(I,10);
    pixel_loc <= UINT_TO_STDV(K,10);
    wait for 20 ns;
  end loop;
end loop;
    
    

  end process;
end TEST;