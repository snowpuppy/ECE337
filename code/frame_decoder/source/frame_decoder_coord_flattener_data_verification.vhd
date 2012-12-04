-- $Id: $
-- File name:   frame_decoder_coord_flattener_data_verification.vhd
-- Created:     11/30/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: data verification data block


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_coord_flattener_data_verification is
  port (
    xstart : in std_logic;
    ystart : in std_logic;
    zstart : in std_logic;
    enable : in std_logic_vector(3 downto 0);
    data_in : in std_logic_vector(7 downto 0);
    data_wrong : out std_logic
    );
end frame_decoder_coord_flattener_data_verification;

architecture struct of frame_decoder_coord_flattener_data_verification is
  signal data : std_logic;
begin
  adjust: process(data_in, data, xstart, ystart, zstart, enable)
    begin
      if (data_in(7 downto 3) = "00000") or (data_in(7 downto 3) = "11111") then
        data <= '1';
      else
        data <= '0';
      end if;
 
      if (enable = "0001") and (xstart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0001") and (xstart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0001") and (ystart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0001") and (ystart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0001") and (zstart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0001") and (zstart = '1') and (data = '0') then
       data_wrong <= '1';
      elsif (enable = "0010") and (xstart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0010") and (xstart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0010") and (ystart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0010") and (ystart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0010") and (zstart = '1') and (data = '0') then
        data_wrong <= '1';
      elsif (enable = "0010") and (zstart = '1') and (data = '0') then
        data_wrong <= '1';
      else
        data_wrong <= '0';
      end if;
   end process adjust;
end struct;
