LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity TX_SR is
  
 
  port (
    clk:      in std_logic;
    rst_n : in std_logic;
    data_sel : in std_logic;
    tx_load : in std_logic;
    R : in std_logic_vector(9 downto 0);
    G : in std_logic_vector(9 downto 0);
    B : in STD_LOGIC_VECTOR(9 downto 0);
    
    H_VSYNC : in STD_LOGIC_VECTOR(9 downto 0);
    CTL0_1 : in STD_LOGIC_VECTOR(9 downto 0);
    CTL2_3 : in STD_LOGIC_VECTOR(9 downto 0);
    
    RO : out std_logic;
    GO : out std_logic;
    BO : out STD_LOGIC
    );

end TX_SR;

architecture struct_tx of TX_SR is
  signal rRO,rGO,rBO: std_logic_vector(9 downto 0);
begin
  
  RO <= rRO(0);
  GO <= rGO(0);
  BO <= rBO(0);
  
  process(clk,rst_n,data_sel,tx_load)
    begin
    if rst_n = '1' then
      rRO <= "0000000000";
      rGO <= "0000000000";
      rGO <= "0000000000";
    elsif(rising_edge(clk)) then
      if(tx_load = '1') then
        
        if (data_sel = '0') then
          rRO <= H_VSYNC;
          rGO <= CTL0_1;
          rBO <= CTL2_3;
        else
          rRO <= R;
          rGO <= G;
          rBO <= B;
        end if;
     else
        
        rRO <= '0' & rRO(9 downto 1);
        rGO <= '0' & rGO(9 downto 1);
        rBO <= '0' & rBO(9 downto 1);
      end if;
    end if;
  end process;
        
end struct_tx;    
        
    
