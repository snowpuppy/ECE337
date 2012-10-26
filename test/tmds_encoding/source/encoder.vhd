-- $Id: $
-- File name:   encoder.vhd
-- Created:     10/26/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: hdmi decoder


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity encoder is
  
  port (
    D      : in  std_logic_vector(7 downto 0);  -- The encoder input data set D
                                                -- is 8-bit pixel data
    cnt    : in  std_logic_vector(2 downto 0);
    out_me : out std_logic);

end encoder;
