-- $Id: $
-- File name:   frame_decoder_coord_flattener_rotator.vhd
-- Created:     11/16/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: rotator block

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.all;

entity frame_decoder_coord_flattener_rotator is
    port (
     sin     : in signed(47 downto 0);
     cos     : in signed(47 downto 0);
     point   : in signed(47 downto 0);
     resultx : out signed(15 downto 0);
     resulty : out signed(15 downto 0);
     resultz : out signed(15 downto 0)
    );
end entity frame_decoder_coord_flattener_rotator;

architecture behaviroal of frame_decoder_coord_flattener_rotator is
    signal sinx,siny,sinz,cosx,cosy,cosz : signed(7 downto 0);
    signal pointx,pointy,pointz : signed(15 downto 0);
    signal m12,m22,m31 : signed(7 downto 0);
    signal m11,m13,m21,m23,m32,m33 : signed(15 downto 0);
    signal int1,int2,int3,int4,int5 : signed(15 downto 0);
    signal inner1,inner2,inner3,inner4,inner5,inner6,inner7,inner8,inner9 : signed(23 downto 0);
begin
    --get x,y,z for sin
    sinx <= sin(47 downto 40);
    siny <= sin(31 downto 24);
    sinz <= sin(15 downto 8);
    
    --get x,y,z for cos
    cosx <= cos(47 downto 40);
    cosy <= cos(31 downto 24);
    cosz <= cos(15 downto 8);
    
    --get x,y,z for point
    pointx <= point(47 downto 32);
    pointy <= point(31 downto 16);
    pointz <= point(15 downto 0);


    int1 <= cosx * sinz;
    int2 <= sinx * siny;
    int3 <= cosx * siny;

    --determine the matrix
   
    --m11(16 bits)
    m11 <= cosy * cosz;
    
    --m12(8 bits)
    int4 <= int2(13 downto 6) * cosz;
    m12 <= -int1(13 downto 6) + int4(13 downto 6);
    
    --m13(16 bit)
    m13 <= sinx * sinz + int3(13 downto 6) * cosz;
    
    --m21(16 bits)
    m21 <= cosy * sinz;
    
    --m22(8 bits)
    int5 <= int2(13 downto 6) * sinz;
    m22 <= int1(13 downto 6) + int5(13 downto 6);
    
    --m23(16 bits)
    m23 <= -sinx * cosz + int3(13 downto 6) * sinz;
    
    --m31(8 bits)
    m31 <= -siny; 
    
    --m32(16 bits)
    m32 <= sinx * cosy;
    --m33(16 bits)
    m33 <= cosx * cosy;

    --calculation for matrix 
    inner1 <= m11(13 downto 6) * pointx;
    inner2 <= m13(13 downto 6) * pointz;
    inner3 <= m21(13 downto 6) * pointx;
    inner4 <= m23(13 downto 6) * pointz;
    inner5 <= m32(13 downto 6) * pointy;
    inner6 <= m33(13 downto 6) * pointz;
    inner7 <= m12 * pointy; 
    inner8 <= m22 * pointy;
    inner9 <= m31 * pointx;
    resultx <=  inner1(17 downto 2) + inner7(17 downto 2) + inner2(17 downto 2); 
    resulty <=  inner3(17 downto 2) + inner8(17 downto 2) + inner4(17 downto 2); 
    resultz <=  inner9(17 downto 2) + inner5(17 downto 2) + inner6(17 downto 2); 

end  behaviroal;
