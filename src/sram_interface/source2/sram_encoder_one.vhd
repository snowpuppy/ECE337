
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

Entity sram_encoder_one IS   -- may be need reset
Port
(
  clk: in std_logic;
  encode_en: in std_logic;
  rst_n: in std_logic;
  d: in std_logic_vector(7 downto 0);
  q_o: out std_logic_vector(9 downto 0)
);
End sram_encoder_one;

Architecture encode_struct of sram_encoder_one IS
  signal num1d: std_logic_vector(3 downto 0);
  signal num0d: std_logic_vector(3 downto 0);
  signal num0q_m: std_logic_vector(3 downto 0);
  signal num1q_m: std_logic_vector(3 downto 0);
  signal q_m: std_logic_vector(9 downto 0);
  signal cnt: std_logic_vector(1 downto 0);
  signal q_out: std_logic_vector(9 downto 0);

 
begin
  process(clk,rst_n,encode_en,d)

    begin
      if(rst_n = '0') then
      q_out <= "0000000000";
      cnt <= "00";
      q_m <= "0000000000";
      q_o <= "0000000000";
      cnt <= "00";
    elsif(rising_edge(clk)) then
      q_m <= "0000000000";
      num1d <= "0000";
      num0d <= "0000";
      num1q_m <= "0000";
      num0q_m <= "0000";
      if(encode_en = '1') then
      --------------------------------------------------------decode logic
      for i in 0 to 7 loop
        if(d(i) = '1') then
        num1d <= num1d + '1';
        num0d <= num0d;
      else
        num0d <= num0d +  '1';
        num1d <= num1d;
      end if;
      end loop;
       
      if(num1d > "0100" or (num1d = "0100" and d(0) = '0')) then
        q_m(0) <= d(0);
        q_m(1) <= q_m(0) xnor d(1);
        q_m(2) <= q_m(1) xnor d(2);
        q_m(3) <= q_m(2) xnor d(3);
        q_m(4) <= q_m(3) xnor d(4);
        q_m(5) <= q_m(4) xnor d(5);
        q_m(6) <= q_m(5) xnor d(6);
        q_m(7) <= q_m(6) xnor d(7);
        q_m(8) <= '1';
      else
        q_m(0) <= d(0);
        q_m(1) <= q_m(0) xor d(1);
        q_m(2) <= q_m(1) xor d(2);
        q_m(3) <= q_m(2) xor d(3);
        q_m(4) <= q_m(3) xor d(4);
        q_m(5) <= q_m(4) xor d(5);
        q_m(6) <= q_m(5) xor d(6);
        q_m(7) <= q_m(6) xor d(7);
        q_m(8) <= '1';        
      end if;
      

      for k in 0 to 7 loop
        if(q_m(k) = '1') then
        num1q_m <= num1q_m + '1';
      else
        num0q_m <= num0q_m + '1';
      end if;
      end loop;
      
      if (cnt = "00" or num1q_m = num0q_m) then
        q_out(9) <= not q_m(8);
        q_out(8) <= q_m(8);
        if(q_m(8) = '1') then
          q_out(7 downto 0) <= q_m(7 downto 0);
        else
          q_out(7 downto 0) <= not q_m(7 downto 0);
        end if;    
        cnt <= "00";
    else
        if(cnt = "10" and (num1q_m > num0q_m)) or (cnt = "01" and (num0q_m > num1q_m)) then
          q_out(9) <= '1';
          q_out(8) <= q_m(8);
          q_out(7 downto 0) <= not q_m(7 downto 0);
          
        else
          q_out(9) <= '0';
          q_out(8) <= q_m(8);
          q_out(7 downto 0) <= q_m(7 downto 0);        
        end if;
        
        if num1q_m > num0q_m then
          cnt <= "10";
        else
          cnt <= "01";
        end if;
        
    end if;
    
      else
        q_out <= "0000000000";
      end if;
    q_o <= q_out;  
    end if;
    end process;
    
    
    
    
    
 
  end encode_struct;
        
        
        
        
        
      
        
        
      
      
      
      
      
      