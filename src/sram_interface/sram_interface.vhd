LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

Entity Sram_Interface Is
port(
  clk: in std_logic;
  rst_n: in std_logic;
  address_in: in std_logic_vector(19 downto 0);
  data_in: in std_logic_vector(23 downto 0);
  data_ready: in std_logic;
  pixel_ready: out std_logic;
  sram_sel: in std_logic;
  pixel_done: out std_logic;
  SRAM1_address: out std_logic_vector(19 downto 0);
  SRAM2_address: out std_logic_vector(19 downto 0);
  SRAM1_data: out std_logic_vector(31 downto 0);
  SRAM2_data: out std_logic_vector(31 downto 0);
  WE_ONE: out std_logic;
  WE_TWO: out std_logic;
  write_done: out std_logic;
  need_input: in std_logic;
  data_one: in std_logic_vector(31 downto 0);
  data_two: in std_logic_vector(31 downto 0);
  data_out: out std_logic_vector(23 downto 0);
  OE_ONE: out std_logic;
  OE_TWO: out std_logic

);
End Sram_Interface;

LIBRARY ECE337_IP;
USE ECE337_IP.all;


Architecture struct of Sram_Interface Is
signal data: std_logic_vector(31 downto 0);
signal address,address_input: std_logic_vector(19 downto 0);
signal ad_load,done,update: std_logic;
signal ad_sel_w,data_load,data_sel_w: std_logic;
signal out_en: std_logic;
signal sram_sel_out: std_logic;


component address_buffer
  port (
    address_in : in  std_logic_vector(19 downto 0);
    address        : out std_logic_vector(19 downto 0);
    rst_n         : in std_logic;
    clk           : in std_logic;
    ad_load        : in  std_logic);

end component;

component Address_generator
  port (
    update        : in  std_logic;
    rst_n           : in  std_logic;    
    clk           : in  std_logic;
    done          : out  std_logic;
    address_input : out std_logic_vector(19 downto 0));
end component;

component address_select
  port (
    address       : in std_logic_vector(19 downto 0);
    ad_r          : in std_logic_vector(19 downto 0);
    ad_sel_w      : in std_logic;
    clk           : in std_logic;
    rst_n         : in std_logic;
    SRAM1_address : out std_logic_vector(19 downto 0);
    SRAM2_address : out std_logic_vector(19 downto 0));
end component;

component controller_input
  port (
    clk        : in  std_logic;
    rst_n      : in  std_logic;
    data_ready : in  std_logic;
    sram_sel   : in  std_logic;
    pixel_done : out std_logic;
    data_load  : out std_logic;
    ad_load    : out std_logic;
    ad_sel_w   : out std_logic;
    data_sel_w : out std_logic;
    WE_TWO     : out std_logic;
    WE_ONE     : out std_logic);
end component;

component CONTROLLER_OUT
 port (
   rst_n      : in  std_logic;
   clk        : in  std_logic;
   ad_sel_w   : in  std_logic;
   need_input : in  std_logic;
   done       : in  std_logic;
   sram_sel_out : out std_logic;
   out_en     : out std_logic;
   write_done : out std_logic;
   pixel_ready : out std_logic;
   OE_ONE     : out std_logic;
   OE_TWO     : out std_logic;
   update    : out std_logic);
end component;

component data_buffer
 port(
    rst_n     : in  std_logic;
    clk       : in  std_logic;
    data_in   : in  std_logic_vector(23 downto 0);
    data_load : in  std_logic;
    data      : out std_logic_vector(31 downto 0));
end component;

component data_select
  port (
    data       : in  std_logic_vector(31 downto 0);
    data_sel_w : in  std_logic;
    clk        : in  std_logic;
    rst_n      : in  std_logic;
    SRAM1_data : out std_logic_vector(31 downto 0);
    SRAM2_data : out std_logic_vector(31 downto 0));
end component;

component input_buffer
   port (
    data_one     : in  std_logic_vector(31 downto 0);
	data_two: in std_logic_vector(31 downto 0);
    data_out : out std_logic_vector(23 downto 0);
    rst_n    : in  std_logic;
    clk      : in   std_logic;
    sram_sel_out : in  std_logic;
    out_en   : in  std_logic);
end component;


begin
U0: address_buffer
port map (
	address_in => address_in, 
	address => address,
	rst_n => rst_n,
	clk => clk,
	ad_load => ad_load);

U1: Address_generator
port map(
	update => update,
	rst_n => rst_n,
	clk => clk,
	done => done,
	address_input => address_input);

U2: address_select
port map(
	address => address,
	ad_r => address_input,
	ad_sel_w => ad_sel_w,
	clk => clk,
	rst_n => rst_n,
	SRAM1_address => SRAM1_address,
	SRAM2_address => SRAM2_address);

U3: controller_input
port map(
	clk => clk,
	rst_n => rst_n,
	data_ready => data_ready,
	sram_sel => sram_sel,
	pixel_done => pixel_done,
	data_load => data_load,
	ad_load => ad_load,
	ad_sel_w => ad_sel_w,
	data_sel_w => data_sel_w,
	WE_TWO => WE_TWO,
	WE_ONE => WE_ONE);

U4: CONTROLLER_OUT
port map(
	rst_n => rst_n,
	clk => clk,
	ad_sel_w => ad_sel_w,
	need_input => need_input,
	done => done,
	sram_sel_out => sram_sel_out,
	out_en => out_en,
	write_done => write_done,
	pixel_ready => pixel_ready,
	OE_ONE => OE_ONE,
	OE_TWO => OE_TWO,
	update => update);

U5: data_buffer
port map(
	rst_n => rst_n,
	clk => clk,
	data_in => data_in,
	data_load => data_load,
	data => data);

U6: data_select
port map(
	data => data,
	data_sel_w => data_sel_w,
	clk => clk,
	rst_n => rst_n,
	SRAM1_data => SRAM1_data,
	SRAM2_data => SRAM2_data);

U7: input_buffer
port map(
	data_one => data_one,
	data_two => data_two,
	data_out => data_out,
	rst_n => rst_n,
	clk => clk,
	sram_sel_out => sram_sel_out,
	out_en => out_en);



End struct;




	

	


	











  
  
