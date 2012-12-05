-- $Id: $
-- File name:   frame_decoder_48to756_block_body_parsed.vhd
-- Created:     11/23/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: combinational logic for body parsed


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity frame_decoder_48to756_block_body_parsed is
  port (
    data_done        : in std_logic;
    color_done       : in std_logic;
    body_parsed      : out std_logic
  );

end frame_decoder_48to756_block_body_parsed;

architecture behavioral of frame_decoder_48to756_block_body_parsed is
begin
  body_parsed <= '1' when (data_done = '1') and (color_done = '1') else '0';
end behavioral;
