LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

Entity encoder Is
  port(
    clock_me: in std_logic;
    encode_en: in std_logic;
    rst_n: in std_logic;
    pixel_data: in std_logic_vector(23 downto 0);
    R: out std_logic_vector(9 downto 0);
    G: out std_logic_vector (9 downto 0);
    B: out std_logic_vector (9 downto 0)
  ); end encoder;

Architecture encoder_struct of encoder Is
  
  component encoder_one
    port(
       clk: in std_logic;
       encode_en: in std_logic;
       rst_n: in std_logic;
       d: in std_logic_vector(7 downto 0);
       q_out: out std_logic_vector(9 downto 0)
        ); end component;
        
begin
  
  UR: encoder_one
  port map(
    clk => clock_me,
    encode_en => encode_en,
    rst_n => rst_n,
    d => pixel_data(7 downto 0),
    q_out => R);
    
  UG: encoder_one
  port map(
    clk => clock_me,
    encode_en => encode_en,
    rst_n => rst_n,
    d => pixel_data(15 downto 8),
    q_out => G);
    
  UB: encoder_one
  port map(
    clk => clock_me,
    encode_en => encode_en,
    rst_n => rst_n,
    d => pixel_data(23 downto 16),
    q_out => B);
    
  end encoder_struct;
    
