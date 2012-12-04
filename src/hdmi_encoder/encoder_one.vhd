
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

Entity encoder_one IS   -- may be need reset
Port
(
  clk: in std_logic;
  encode_en: in std_logic;
  rst_n: in std_logic;
  d: in std_logic_vector(7 downto 0);
  q_out: out std_logic_vector(9 downto 0)
);
End encoder_one;

Architecture encoder_one_struct of encoder_one IS
  signal num1d: std_logic_vector(3 downto 0);
  signal num0d: std_logic_vector(3 downto 0);
  signal num0q_m: std_logic_vector(3 downto 0);
  signal num1q_m: std_logic_vector(3 downto 0);
  signal q_m: std_logic_vector(8 downto 0);
  signal cnt: std_logic_vector(1 downto 0);


 
 
 component numbercnt
   port(
     data_cnt: in std_logic_vector(7 downto 0);
     num0: out std_logic_vector(3 downto 0);
     num1: out std_logic_vector(3 downto 0));
   end component;
 
begin
  
  cnt_d: numbercnt
  port map(data_cnt => d(7 downto 0),num0 => num0d,num1 => num1d);
    
  cnt_q: numbercnt
  port map(data_cnt => q_m(7 downto 0),num0 =>num0q_m,num1 => num1q_m);
    
    
  process(clk,rst_n)
  begin
    if(rst_n = '0') then 
    q_out <= "0000000000";
    cnt <= "00";
    q_m <= "000000000";
  elsif(rising_edge(clk)) then
    if encode_en = '1' then
      if (num1d > "0100" or (num1d = "0100" and d(0) = '0')) then
        q_m(0) <= d(0);
        q_m(1) <= q_m(0) xnor d(1);
        q_m(2) <= q_m(1) xnor d(2);
        q_m(3) <= q_m(2) xnor d(3);
        q_m(4) <= q_m(3) xnor d(4);
        q_m(5) <= q_m(4) xnor d(5);
        q_m(6) <= q_m(5) xnor d(6);
        q_m(7) <= q_m(6) xnor d(7);
        q_m(8) <= '0';
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
      
      if (cnt = "00" or num0q_m = num1q_m) then
        if(q_m(8) = '1') then
          q_out(9) <= '0';
          q_out(8) <= q_m(8);
          q_out(7 downto 0) <= q_m(7 downto 0);
        else
          q_out(9) <= '1';
          q_out(8) <= q_m(8);
          q_out(7 downto 0) <= not q_m(7 downto 0);
        end if;

      else
        if((cnt = "10" and num1q_m > num0q_m) or (cnt = "01" and num0q_m > num1q_m)) then
          q_out(9) <= '1';
          q_out(8) <= q_m(8);
          q_out(7 downto 0) <= not q_m(7 downto 0);
        else
          q_out(9) <= '0';
          q_out(8) <= q_m(8);
          q_out(7 downto 0) <= q_m(7 downto 0);
        end if;
      end if;
      
      if(num1q_m > num0q_m) then
        cnt <= "10";
      elsif(num1q_m < num0q_m) then
        cnt <= "01";
      else
        cnt <= "00";
      end if;
      
      
    end if;
  end if;
  end process;
end encoder_one_struct;
  
        
        
        
        
