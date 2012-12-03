LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

Entity HDMI_Encoder Is
port(
  clk: in std_logic;
  rst_n: in std_logic;
  pixel_data: in std_logic_vector(23 downto 0);
  data_ready: in std_logic;
  need_data: out std_logic;
  RO: out std_logic;
  GO: out std_logic;
  BO: out std_logic;
  TMDS_CLK: out std_logic
);
End HDMI_Encoder;

Architecture HDMI_encoder_struct of HDMI_Encoder Is
signal encode_en: std_logic;  --internal signals for Encoder
signal R,G,B: std_logic_vector(9 downto 0);
signal Timer_done,tx_shift,tx_load,data_sel,ctrl: std_logic; --internal signals for Controller
signal row_num,pixel_loc,H_VSYNC,CTL0_1,CTL2_3: std_logic_vector(9 downto 0); --internal signals for ID_CONTR
signal one_row: std_logic;
signal clock_me: std_logic; -- internal signals for TMDS_clk
signal clk_tmds: std_logic;


component encoder
  port(
    clock_me       : in std_logic;
    encode_en : in std_logic;
    rst_n     : in std_logic;
    pixel_data: in std_logic_vector(23 downto 0);
    R         :out std_logic_vector(9 downto 0);
    G         :out std_logic_vector(9 downto 0);
    B         :out std_logic_vector(9 downto 0)
  ); End Component;
      
component controller IS
  port(
    clk: in std_logic;
    rst_n: in std_logic;
    data_ready: in std_logic;
    timer_done: in std_logic;
    ctrl: in std_logic;
    pixel_loc: in std_logic_vector(9 downto 0);
    row_num:  in std_logic_vector(9 downto 0);
    encode_en: out std_logic;
    data_sel: out std_logic;
    tx_shift: out std_logic; -- optional
    tx_load: out std_logic;
    need_data: out std_logic
  ); End Component;
    
component ID_CONTR
  port(
    row_num:    in std_logic_vector(9 downto 0);
    pixel_loc:  in std_logic_vector(9 downto 0);  
    H_VSYNC:    out std_logic_vector(9 downto 0);
    CTL0_1:     out std_logic_vector(9 downto 0);
    CTL2_3:     out std_logic_vector(9 downto 0);
    ctrl:       out std_logic
  ); End Component;
    
component pixel
  port(
    rst_n:      in std_logic;
    TMDS_CLK:   in std_logic;
    pixel_loc:  out std_logic_vector(9 downto 0); 
    one_row:    out std_logic
  ); End Component;

component row
  port(
    TMDS_CLK : in  std_logic;
    one_row  : in  std_logic;
    rst_n    : in  std_logic;
    row_num  : out std_logic_vector(9 downto 0)
  ); End Component;
  
component TMDSCLK
  port(
    clock_me : in  std_logic;
    rst_n    : in  std_logic;
    tx_load  : in  std_logic;
    TMDS_CLK : out std_logic
    ); End Component;
    
component TX_SR
  port(
    clock_me : in std_logic;
    rst_n : in std_logic;
    tx_shift : in std_logic;
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
  ); End Component;
      
component Clock_divider
  port(
    clk      : in  std_logic;
    rst_n    : in  std_logic;
    clock_me : out std_logic
  ); End Component;
    
component Timer
  port(
    tx_load    : in std_logic;
    clock_me   : in std_logic;
    Timer_done : out std_logic;
    rst_n      : in std_logic
  ); End Component;
  
Begin
    
    
  U0: encoder
    port map(
      clock_me => clock_me,
      encode_en => encode_en,
      rst_n => rst_n,
      pixel_data => pixel_data,
      R => R,
      G => G,
      B => B
    );
    
  U1: Controller
    port map(
      data_ready => data_ready,
      clk => clk,
      rst_n => rst_n,
      encode_en => encode_en,
      Timer_done => Timer_done,
      need_data => need_data,
      tx_shift => tx_shift,
      tx_load => tx_load,
      data_sel => data_sel,
      ctrl => ctrl,
      row_num => row_num,
      pixel_loc => pixel_loc
    );
    
  U2: ID_CONTR
    port map(
      row_num => row_num,
      pixel_loc => pixel_loc,
      H_VSYNC => H_VSYNC,
      CTL0_1 => CTL0_1,
      CTL2_3 => CTL2_3,
      ctrl => ctrl
    );
    
  U3: pixel
    port map(
      rst_n => rst_n,
      TMDS_CLK => clk_tmds,
      pixel_loc => pixel_loc,
      one_row => one_row
    );
    
  U4: row
    port map(
      TMDS_CLK => clk_tmds,
      one_row => one_row,
      rst_n => rst_n,
      row_num => row_num
    );
    
  U5: TMDSCLK
    port map(
      clock_me => clock_me,
      rst_n => rst_n,
      tx_load => tx_load,
      TMDS_CLK => clk_tmds
    );
    
  U6: TX_SR
    port map(
      clock_me => clock_me,
      rst_n => rst_n,
      tx_shift => tx_shift,
      data_sel => data_sel,
      tx_load => tx_load,
      R => R,
      G => G,
      B => B,
      H_VSYNC => H_VSYNC,
      CTL0_1 => CTL0_1,
      CTL2_3 => CTL2_3,
      RO => RO,
      GO => GO,
      BO => BO
    );
    
  U7: Clock_divider
    port map(
      clk => clk,
      rst_n => rst_n,
      clock_me => clock_me
    );
    
  U8: Timer
    port map(
      tx_load => tx_load,
      clock_me => clock_me,
      Timer_done => Timer_done,
      rst_n => rst_n
    );
    
    TMDS_CLK <= clk_tmds;
End HDMI_encoder_struct;
  
    
    
    
    
    
     
    
    
    
    
    
      
    
    
    
    
    
    
    
    
    
    
    
  
  
  
  
