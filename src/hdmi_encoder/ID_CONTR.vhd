-- HDMI Encoder
-- Component:   Pixel

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

Entity ID_CONTR IS   -- may be need reset
Port
(
  row_num: in std_logic_vector(9 downto 0);
  pixel_loc: in std_logic_vector(9 downto 0);  
  H_VSYNC: out std_logic_vector(9 downto 0);
  CTL0_1: out std_logic_vector(9 downto 0);
  CTL2_3: out std_logic_vector(9 downto 0);
  ctrl: out std_logic
);
End ID_CONTR;

Architecture struct_id of ID_CONTR is
  signal CTL0,CTL1,CTL2,CTL3,HSYNC,VSYNC,guard: std_logic;
  signal d0,d1,d2: std_logic_vector(1 downto 0);
  
begin

process(row_num, pixel_loc)
  begin
    CTL0 <= '0';
    CTL1 <= '0';
    CTL2 <= '0';
    CTL3 <= '0';
    HSYNC <= '0';
    VSYNC <= '0';
    guard <= '0';
    ctrl <= '0';
    ------------------------------------------------------------------------------------------------------------------------------------
    if (to_integer(unsigned(row_num)) >= 0 and to_integer(unsigned(row_num)) <= 5) or (to_integer(unsigned(row_num)) >= 12 and to_integer(unsigned(row_num)) <= 41) or (to_integer(unsigned(row_num)) >= 522 and to_integer(unsigned(row_num)) <= 524)  then --row 1 to 6;13-42;523-525: Idle
      if to_integer(unsigned(pixel_loc)) >= 16 and to_integer(unsigned(pixel_loc))<= 77 then --pixel_loc 17-78: HSYNC;
        CTL0 <= '0';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '1';
        VSYNC <= '0';
        guard  <= '0';
      else
        CTL0 <= '0';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '0';
        VSYNC <= '0';
        guard  <= '0';
      end if;
      
      ctrl <= '1';
 ------------------------------------------------------------------------------------------------------------------------------------
      
   elsif (to_integer(unsigned(row_num)) >= 6 and to_integer(unsigned(row_num)) <= 11) then --row 7 to 12: Idle & VSYNC
     if to_integer(unsigned(pixel_loc)) >= 16 and to_integer(unsigned(pixel_loc))<= 77 then --pixel_loc 17-78: HSYNC;
        CTL0 <= '0';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '1';
        VSYNC <= '1';
        guard  <= '0';
      else
        CTL0 <= '0';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '0';
        VSYNC <= '1';
        guard  <= '0'; 
      end if;
      ctrl <= '1'; 
  ------------------------------------------------------------------------------------------------------------------------------------   
    else -- Video period
    
      if to_integer(unsigned(pixel_loc)) >= 0 and to_integer(unsigned(pixel_loc))<= 15 then --pixel_loc 1 -16: Idle
        CTL0 <= '0';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '0';
        VSYNC <= '0';
        ctrl <= '1';
        guard  <= '0';
    
      elsif to_integer(unsigned(pixel_loc)) >= 16 and to_integer(unsigned(pixel_loc))<= 77 then --pixel_loc 17-78: HSYNC;
        CTL0 <= '0';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '1';
        VSYNC <= '0';
        ctrl <= '1';
        guard  <= '0';

      
      elsif to_integer(unsigned(pixel_loc)) >= 78 and to_integer(unsigned(pixel_loc))<= 127 then --pixel_loc 79-128: Idle;   
        CTL0 <= '0';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '0';
        VSYNC <= '0';
        ctrl <= '1'; 
        guard  <= '0';   

      
      elsif to_integer(unsigned(pixel_loc)) >= 128 and to_integer(unsigned(pixel_loc))<= 135 then --pixel_loc 129-136: preamble
        CTL0 <= '1';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '0';
        VSYNC <= '0';
        ctrl <= '1';
        guard  <= '0';    
  
       
      elsif to_integer(unsigned(pixel_loc)) >= 136 and to_integer(unsigned(pixel_loc))<= 137 then --pixel_loc 137-138: guard band
        CTL0 <= '0';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '0';
        VSYNC <= '0';
        ctrl <= '1'; 
        guard  <= '1';

        
      elsif to_integer(unsigned(pixel_loc)) >= 138 and to_integer(unsigned(pixel_loc))<= 857 then --pixel_loc 139-858: video 
        CTL0 <= '0';
        CTL1 <= '0';
        CTL2 <= '0';
        CTL3 <= '0';
        HSYNC <= '0';
        VSYNC <= '0';
        ctrl <= '0'; 
        guard  <= '0';
      end if;
    end if;
  end process;
  
  process(guard,d0,d1,d2,CTL0,CTL1,CTL2,CTL3,VSYNC,HSYNC)
  begin
    d0 <= VSYNC&HSYNC;
    d1 <= CTL1 & CTL0;
    d2 <= CTL3 & CTL2;

    if guard = '1' then
      H_VSYNC <= "1011001100";
      CTL0_1 <= "0100110011";
      CTL2_3 <= "1011001100";
    else
     case d0 is
      when "00" =>  H_VSYNC  <= "1101010100";
      when "01" =>  H_VSYNC  <= "0010101011";
      when "10" =>  H_VSYNC  <= "0101010100";
      when "11" =>  H_VSYNC  <= "1010101011";
    when others =>  H_VSYNC  <= "0000000000";
     end case;   
  
     case d1 is
      when "00" =>  CTL0_1  <= "1101010100";
      when "01" =>  CTL0_1  <= "0010101011";
      when "10" =>  CTL0_1  <= "0101010100";
      when "11" =>  CTL0_1  <= "1010101011";
    when others =>  CTL0_1  <= "0000000000";
     end case;     
     
     case d2 is
      when "00" =>  CTL2_3  <= "1101010100";
      when "01" =>  CTL2_3  <= "0010101011";
      when "10" =>  CTL2_3  <= "0101010100";
      when "11" =>  CTL2_3  <= "1010101011";
    when others =>  CTL2_3  <= "0000000000";
     end case;
     
   end if;

    
  end process;
end struct_id;
                 
      
      
      
      
        

         
      
        
      
      
        
          
