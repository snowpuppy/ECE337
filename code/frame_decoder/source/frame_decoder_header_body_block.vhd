-- $Id: $
-- File name:   frame_decoder_header_body_block.vhd
-- Created:     11/20/2012
-- Author:      Chun Ta Huang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: header combinational body block.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.all;

entity frame_decoder_header_body_block is
  port (
    clk             : in std_logic;
    rst             : in std_logic;
    control_clk_in  : in std_logic;
    num_byte_clk_in : in std_logic;
    data_in         : in std_logic_vector(7 downto 0);
    control_correct : out std_logic;
    num_correct     : out std_logic;
    switch_buffer   : out std_logic;
    control         : out std_logic_vector(2 downto 0);
    num_byte        : out std_logic_vector(7 downto 0);
    num_vertices    : out std_logic_vector(7 downto 0)
  );
end frame_decoder_header_body_block;

architecture behavioral of frame_decoder_header_body_block is
-----------------------------------------------------------------------------------------------
  signal control_buffer,control_output  : std_logic_vector(7 downto 0);
  signal num_byte_buffer,num_byte_output : std_logic_vector(7 downto 0);
  signal subtract, num_vertices_next,num_vertices_next_reg: std_logic_vector(7 downto 0);
  signal num_correct_next, num_correct_next_reg, control_correct_next, control_correct_next_reg, switch_buffer_next, switch_buffer_next_reg : std_logic;
-----------------------------------------------------------------------------------------------
begin
  regist: process (clk,rst)
 begin
    if (rst = '1') then
      control_buffer <= (others => '0');
      num_byte_buffer <= (others => '0');

    elsif (rising_edge(clk)) then
      control_buffer <= control_output;
      num_byte_buffer <= num_byte_output;

      control_correct_next_reg <= control_correct_next;
      num_correct_next_reg <= num_correct_next;
      switch_buffer_next_reg <= switch_buffer_next;
      num_vertices_next_reg <= num_vertices_next; 

    end if;
  end process regist;
-----------------------------------------------------------------------------------------------  
  -- 000 buffer switch
  -- 001 3D
  -- 010 2D1
  -- 011 2D2
  -- 100 2D3
  nextstatelogic: process (control_buffer, num_byte_buffer, subtract,control_clk_in,num_byte_clk_in,data_in, num_byte_output, control_output)
    begin

      if (control_clk_in = '1') then
        control_output <= data_in;
      else
        control_output <= control_buffer;
      end if;
      if (num_byte_clk_in = '1') then
        num_byte_output <= data_in;
      else 
        num_byte_output <= num_byte_buffer;
      end if;

     if ( control_output = "00000000") or (control_output ="00100000") or (control_output = "01000000") or (control_output ="01100000") or (control_output ="10000000") then
      control_correct_next <= '1';
    else 
      control_correct_next <= '0';
    end if;
----------------------------------------------------------------------------------------------- 
    if (control_output(7 downto 5) = "001") then   
      subtract <= num_byte_output - x"15"; 
      num_vertices_next <= "000" & subtract(7 downto 3);
    else
      subtract <= "00000000";
      num_vertices_next <= "00000000";
    end if;
  -- 10010010 = 148 = 18 + 16 * 8 
    if ( control_output(7 downto 5) = "001") and (num_byte_output > "00000000") and (num_byte_output <= "10010101") and (subtract(2 downto 0) = "000")then
      num_correct_next <= '1';
    elsif ( control_output(7 downto 5) = "010") and  (num_byte_output = "00001011") then   --11 bytes
      num_correct_next <= '1';
    elsif ( control_output(7 downto 5) = "011") and  (num_byte_output = "00001011") then
      num_correct_next <= '1';  
    elsif ( control_output(7 downto 5) = "100") and  (num_byte_output = "00000011") then  -- 3 bytes
      num_correct_next <= '1';
    elsif ( control_output(7 downto 5) = "000") and  (num_byte_output = "00000000") then
      num_correct_next <= '1';
    else
      num_correct_next <= '0';
    end if;
----------------------------------------------------------------------------------------------- 
    if (control_output(7 downto 5) = "000") then
      switch_buffer_next <= '1';
    else
      switch_buffer_next <= '0';
    end if;
----------------------------------------------------------------------------------------------- 
  end process nextstatelogic;
----------------------------------------------------------------------------------------------- 
  num_correct <= num_correct_next_reg;
  control_correct <= control_correct_next_reg;
  switch_buffer <= switch_buffer_next_reg;
  control <= control_buffer(7 downto 5);
  num_byte <= num_byte_buffer;
  num_vertices <= num_vertices_next_reg;

end behavioral;
