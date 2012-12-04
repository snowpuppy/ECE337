-- $Id: $
-- File name:   frame_decoder_coord_flattener_final_result.vhd
-- Created:     11/23/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: final result for frame decoder coord flattener part


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.all;


entity frame_decoder_coord_flattener_final_result is
  port (
    quotient_xz : in std_logic_vector(15 downto 0); --results for x/z
    quotient_yz : in std_logic_vector(15 downto 0); --results for y/z
    connection  : in std_logic_vector(15 downto 0);
    done        : in std_logic;
    result      : out std_logic_vector(47 downto 0)
  );

end frame_decoder_coord_flattener_final_result;

architecture behavioral of frame_decoder_coord_flattener_final_result is
  signal interx,intery : std_logic_vector(15 downto 0);
begin
  outputlogic: process (done,quotient_xz,quotient_yz,connection,interx,intery)
   begin 
      if (done = '1') then
       interx <= quotient_xz + "0000000101101000"; --add 360
       intery <= quotient_yz + "0000000011110000"; --add 240
       result <= interx & intery & connection;
      else
       result <= (others => '0');
       interx <= (others => '0');
       intery <= (others => '0');
     end if;
   end process outputlogic;
end behavioral;


