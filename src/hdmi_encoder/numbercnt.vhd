LIBRARY IEEE;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

Entity numbercnt IS   -- may be need reset

Port
(
data_cnt: in std_logic_vector(7 downto 0);
num0: out std_logic_vector(3 downto 0);
num1: out std_logic_vector(3 downto 0)
);
End numbercnt;



Architecture numbercnt_struct of numbercnt is
begin
    

  num0 <= "0000" + data_cnt(0) +  data_cnt(1) +  data_cnt(2)+ data_cnt(3)+  data_cnt(4)+ data_cnt(5)+ data_cnt(6)+ data_cnt(7);
  num1 <= "1000" - data_cnt(0)-data_cnt(1)-data_cnt(2)- data_cnt(3)-  data_cnt(4)-data_cnt(5)-data_cnt(6)-data_cnt(7);

end numbercnt_struct;
