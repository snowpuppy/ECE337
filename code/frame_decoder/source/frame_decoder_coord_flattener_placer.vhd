-- $Id: $
-- File name:   frame_decoder_coord_flattener_placer.vhd
-- Created:     11/16/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: placer block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.all;

entity frame_decoder_coord_flattener_placer is
  port (
   rotator_result_x : in signed(15 downto 0);
   rotator_result_y : in signed(15 downto 0);
   rotator_result_z : in signed(15 downto 0);
   offset           : in signed(47 downto 0);
   placer_x         : out std_logic_vector(15 downto 0);
   placer_y         : out std_logic_vector(15 downto 0);
   placer_z         : out std_logic_vector(15 downto 0)
  );
end entity frame_decoder_coord_flattener_placer;

architecture behavioral of frame_decoder_coord_flattener_placer is
    signal offsetx,offsety,offsetz,addx,addy,addz : signed(15 downto 0);
begin
   --get x,y,z for offset
    offsetx <= offset(47 downto 32);
    offsety <= offset(31 downto 16);
    offsetz <= offset(15 downto 0);
   
   --calculation
   addx <= offsetx + rotator_result_x;
   addy <= offsety + rotator_result_y;
   addz <= offsetz + rotator_result_z;
 
   -- conversion from signed to std_logic_vector
   placer_x <= std_logic_vector(addx);
   placer_y <= std_logic_vector(addy);
   placer_z <= std_logic_vector(addz);

end architecture behavioral;   
