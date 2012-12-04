-- HDMI Encoder
-- Component:   Pixel

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

Entity pixel IS   -- may be need reset

Port
(
  rst_n: in std_logic;
  TMDS_CLK: in std_logic;
  pixel_loc: out std_logic_vector(9 downto 0);  -- need to change the #bits on the blkdiagram
  one_row: out std_logic	

);
End pixel;

Architecture pixel_struct of pixel is
  signal pixel_cnt: std_logic_vector(9 downto 0);
  signal one_row_r: std_logic;
begin  
  
  process(TMDS_CLK,rst_n)
    begin
      if(rst_n = '0') then
      pixel_loc  <= "0000000000";
      pixel_cnt <= "0000000000";
      one_row_r <= '0';
      one_row <= '0';
    elsif(TMDS_CLK'event and TMDS_CLK = '1' and rst_n = '1') then
     
     ------------------------------------------------------------------------------------------------------
       if to_integer(unsigned(pixel_cnt)) = 857 then --on blk dia, it says 1 to 858, here I use 0 to 857
         pixel_cnt <= "0000000000";
	 one_row_r <= '1';
       else
         pixel_cnt <= pixel_cnt + '1';
	 one_row_r <= '0';
       end if;
      ---------------------------------------------------------------------------------------------------
      -- reset pixel after 858 pixels are counted
      
     pixel_loc <= pixel_cnt;
     one_row <= one_row_r;
    end if;
  end process;
  
end pixel_struct;

--- Comment: Tested with testbench: Pass
----------- Checked with Leda: doesn't have any error
--------Date: 2012-Nov.-10  

      
  
  

