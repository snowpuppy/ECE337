-- $Id: $
-- File name:   tb_sram_interface.vhd
-- Created:     12/3/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Test Bench

library ieee;
--library gold_lib;   --UNCOMMENT if you're using a GOLD model
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ECE337_IP;
--use ECE337_IP.scalable_off_chip_sram;
use ECE337_IP.all;

--use gold_lib.all;   --UNCOMMENT if you're using a GOLD model

entity tb_sram_interface is
end tb_sram_interface;

architecture TEST of tb_sram_interface is

  function UINT_TO_STDV( X: INTEGER; NumBits: INTEGER )
     return STD_LOGIC_VECTOR is
  begin
    return std_logic_vector(to_unsigned(X, NumBits));
  end;

  function STDV_TO_UINT( X: std_logic_vector)
     return integer is
  begin
    return to_integer(unsigned(x));
  end;

  component sram_interface
    PORT(
         clk : in std_logic;
         rst_n : in std_logic;
         address_in : in std_logic_vector(19 downto 0);
         data_in : in std_logic_vector(23 downto 0);
         data_ready : in std_logic;
         pixel_ready : out std_logic;
         sram_sel : in std_logic;
         pixel_done : out std_logic;
         SRAM1_address : out std_logic_vector(19 downto 0);
         SRAM2_address : out std_logic_vector(19 downto 0);
         SRAM1_data : out std_logic_vector(31 downto 0);
         SRAM2_data : out std_logic_vector(31 downto 0);
         WE_ONE : out std_logic;
         WE_TWO : out std_logic;
         write_done : out std_logic;
         need_input : in std_logic;
         data_one : in std_logic_vector(31 downto 0);
         data_two : in std_logic_vector(31 downto 0);
         data_out : out std_logic_vector(23 downto 0);
         OE_ONE : out std_logic;
         OE_TWO : out std_logic
    );
  end component;
 component scalable_off_chip_sram is
    generic (
            -- Memory Model parameters
            ADDR_SIZE_BITS  : natural  := 12;    -- Address bus size in bits/pins with addresses corresponding to 
                                                -- the starting word of the accesss
            WORD_SIZE_BYTES  : natural  := 1;      -- Word size of the memory in bytes
            DATA_SIZE_WORDS  : natural  := 1;      -- Data bus size in "words"
            READ_DELAY      : time    := 10 ns;  -- Delay/latency per read access (total time between start of supplying address and when the data read from memory appears on the r_data port)
                                                -- Keep the 10 ns delay for on-chip SRAM
            WRITE_DELAY      : time    := 10 ns    -- Delay/latency per write access (total time between start of supplying address and when the w_data value is written into memory)
                                                -- Keep the 10 ns delay for on-chip SRAM
          );
  port   (
          -- Test bench control signals
          mem_clr        : in  boolean;
          mem_init      : in  boolean;
          mem_dump      : in  boolean;
          verbose        : in  boolean;
          init_filename  : in   string;
          dump_filename  : in   string;
          start_address  : in  natural;
          last_address  : in  natural;
          
          -- Memory interface signals
          r_enable  : in    std_logic;
          w_enable  : in    std_logic;
          
          addr      : in    std_logic_vector((ADDR_SIZE_BITS-1) downto 0);
          data      : inout  std_logic_vector( ((data_size_words * word_size_bytes * 8) - 1) downto 0)


        );
  end component scalable_off_chip_sram;
-- Insert signals Declarations here
  signal clk : std_logic;
  signal rst_n : std_logic;
  signal address_in : std_logic_vector(19 downto 0);
  signal data_in : std_logic_vector(23 downto 0);
  signal data_ready : std_logic;
  signal pixel_ready : std_logic;
  signal sram_sel : std_logic;
  signal pixel_done : std_logic;
  signal SRAM1_address : std_logic_vector(19 downto 0);
  signal SRAM2_address : std_logic_vector(19 downto 0);
  signal SRAM1_data : std_logic_vector(31 downto 0);
  signal SRAM2_data : std_logic_vector(31 downto 0);
  signal WE_ONE : std_logic;
  signal WE_TWO : std_logic;
  signal write_done : std_logic;
  signal need_input : std_logic;
  signal data_one : std_logic_vector(31 downto 0);
  signal data_two : std_logic_vector(31 downto 0);
  signal data_out : std_logic_vector(23 downto 0);
  signal OE_ONE : std_logic;
  signal OE_TWO : std_logic;
  
  -- signal declarations for SRAM
     -- Test bench control signals
  
     signal tb_mem_clr: boolean;
     signal tb_mem_init: boolean;
    signal  tb_mem_dump: boolean;
  
    signal  tb_verbose: boolean; 
    signal  tb_init_filename:string(24 downto 1);
    signal  tb_dump_filename: string(24 downto 1);
    signal  tb_start_address: natural;
   signal  tb_last_address: natural;
  
   signal sr_data : std_logic_vector(31 downto 0);

-- signal for sram 2
   signal tb_mem_clr_two: boolean;
     signal tb_mem_init_two: boolean;
    signal  tb_mem_dump_two: boolean;
    signal sr_data_2 : std_logic_vector(31 downto 0);

  


  -- constant for all sram

  
    constant     TB_ADDR_SIZE_BITS : natural  := 21;			
     constant   TB_WORD_SIZE_BYTES	 : natural  := 2; 	
    constant    TB_DATA_SIZE_WORDS	: natural  := 2; 	
    constant    TB_CLK_PERIOD  : time    := 10 ns;
     
   constant   TB_MAX_ADDRESS : natural :=1036800;          
      

 
  
-- signal <name> : <type>;
begin
  CLKGEN: process
  variable clk_tmp: std_logic := '0';
begin
  clk_tmp := not clk_tmp;
  clk <= clk_tmp;
  wait for 5 ns ;
end process;
  DUT: sram_interface port map(
                clk => clk,
                rst_n => rst_n,
                address_in => address_in,
                data_in => data_in,
                data_ready => data_ready,
                pixel_ready => pixel_ready,
                sram_sel => sram_sel,
                pixel_done => pixel_done,
                SRAM1_address => SRAM1_address,
                SRAM2_address => SRAM2_address,
                SRAM1_data => SRAM1_data,
                SRAM2_data => SRAM2_data,
                WE_ONE => WE_ONE,
                WE_TWO => WE_TWO,
                write_done => write_done,
                need_input => need_input,
                data_one => data_one,
                data_two => data_two,
                data_out => data_out,
                OE_ONE => OE_ONE,
                OE_TWO => OE_TWO
                );

  -- An example of how to map an instance of the on-chip scalable sram model (Taken from my test bench)


--#####################################################################################################################
--#####################################################################################################################
--#####################################################################################################################
--#####################          SRAM 1                    ##################################
--#####################################################################################################################
--#####################################################################################################################
  
  Memory: scalable_off_chip_sram
   generic map (
                  -- Memory interface parameters
                  ADDR_SIZE_BITS  => TB_ADDR_SIZE_BITS,				-- Set the address length in bits
                  WORD_SIZE_BYTES  => TB_WORD_SIZE_BYTES,			-- Set the word size in Bytes
                  DATA_SIZE_WORDS  => TB_DATA_SIZE_WORDS,			-- Set the data access size in words (how many words do you want to access each time)
                  READ_DELAY      => (TB_CLK_PERIOD - 2 ns),  -- CLK is 2 ns longer than access delay for conservative padding for flipflop setup times and propagation delays from the external SRAM chip to the internal flipflops
                  WRITE_DELAY      => (TB_CLK_PERIOD - 2 ns)  -- CLK is 2 ns longer than access delay for conservative padding for Real SRAM hold times and propagation delays from the internal flipflops to the external SRAM chip
                )

    
    port map  (
                -- Test bench control signals
                mem_clr        => tb_mem_clr,
                mem_init      => tb_mem_init,
                mem_dump      => tb_mem_dump,
                verbose        => tb_verbose,
                init_filename  => tb_init_filename,
                dump_filename  => tb_dump_filename,
                start_address  => tb_start_address,
                last_address  => tb_last_address,
                
                -- Memory interface signals
                r_enable  => OE_ONE,
                w_enable  => WE_ONE,
                addr(20 downto 1)      => SRAM1_address,
                addr(0)   => '0',
                data      => sr_data
              );

--#####################################################################################################################
--#####################################################################################################################
--#####################################################################################################################
--#####################          SRAM 1    END                ##################################
--#####################################################################################################################
--#####################################################################################################################





  
--#####################################################################################################################
--#####################################################################################################################
--#####################################################################################################################
--#####################          SRAM 2                    ##################################
--#####################################################################################################################
--#####################################################################################################################
  
  Memory2: scalable_off_chip_sram
   generic map (
                  -- Memory interface parameters
                  ADDR_SIZE_BITS  => TB_ADDR_SIZE_BITS,				-- Set the address length in bits
                  WORD_SIZE_BYTES  => TB_WORD_SIZE_BYTES,			-- Set the word size in Bytes
                  DATA_SIZE_WORDS  => TB_DATA_SIZE_WORDS,			-- Set the data access size in words (how many words do you want to access each time)
                  READ_DELAY      => (TB_CLK_PERIOD - 2 ns),  -- CLK is 2 ns longer than access delay for conservative padding for flipflop setup times and propagation delays from the external SRAM chip to the internal flipflops
                  WRITE_DELAY      => (TB_CLK_PERIOD - 2 ns)  -- CLK is 2 ns longer than access delay for conservative padding for Real SRAM hold times and propagation delays from the internal flipflops to the external SRAM chip
                )

    
    port map  (
                -- Test bench control signals
                mem_clr        => tb_mem_clr_two,
                mem_init      => tb_mem_init_two,
                mem_dump      => tb_mem_dump_two,
                verbose        => tb_verbose,
                init_filename  => tb_init_filename,
                dump_filename  => tb_dump_filename,
                start_address  => tb_start_address,
                last_address  => tb_last_address,
                
                -- Memory interface signals
                r_enable  => OE_TWO,
                w_enable  => WE_TWO,
                addr(20 downto 1)      => SRAM2_address,
                addr(0)   => '0',
                data      => sr_data_2
              );

--#####################################################################################################################
--#####################################################################################################################
--#####################################################################################################################
--#####################          SRAM 2    END                ##################################
--#####################################################################################################################
--#####################################################################################################################
  

  
--   GOLD: <GOLD_NAME> port map(<put mappings here>);

--#####################################################################################################################
--#####################          SRAM 1    process                ##################################
--#####################################################################################################################
  
  IO_DATA: process (OE_ONE, WE_ONE, sr_data, SRAM1_data)
  begin
    if (OE_ONE = '1') then
      -- Read mode -> the data pins should connect to the r_data bus & the other bus should float
      data_one  <= sr_data;
      sr_data        <= (others=>'Z');
    elsif(WE_ONE = '1') then
      -- Write mode -> the data pins should connect to the w_data bus & the other bus should float
      data_one  <= (others=>'Z');
      sr_data  <= SRAM1_data;
    else
      -- Disconnect both busses
      data_one  <= (others=>'Z');
      sr_data        <= (others=>'Z');
    end if;
  end process IO_DATA;
--#####################################################################################################################
--#####################          SRAM 2    process                ##################################
--#####################################################################################################################
  
  IO_DATA_2: process (OE_TWO, WE_TWO, sr_data_2, SRAM2_data)
  begin
    if (OE_TWO = '1') then
      -- Read mode -> the data pins should connect to the r_data bus & the other bus should float
      data_two  <= sr_data_2;
      sr_data_2        <= (others=>'Z');
    elsif(WE_TWO = '1') then
      -- Write mode -> the data pins should connect to the w_data bus & the other bus should float
      data_two  <= (others=>'Z');
      sr_data_2  <= SRAM2_data;
    else
      -- Disconnect both busses
      data_two  <= (others=>'Z');
      sr_data_2        <= (others=>'Z');
    end if;
  end process IO_DATA_2;





  
process
  begin

-- Insert TEST BENCH Code Here

  
--####################### CASE ONE   1ST ################################
--  goal: for rst

-- sram control rst control
--tb_verbose <= false;
 
    rst_n <= '0';
--                12345678901234567890
    address_in <="00000000000000000000";
    
    --         123456789012345678901234
    data_in <="111111111111111111111111"; 

    data_ready <='1'; 

    sram_sel <='0'; 

    need_input <= '0';

    wait for 10 ns;
--##########################################################################

-- ##################### CASE one    2ST ##################################
-- goal: for write address "1" to "1111......11111"
   
  rst_n <= '1';
  wait for 100 ns;  


-- ##########################################################################

-- ##################### CASE one   3ST ##################################
--                12345678901234567890
    address_in <="00000000000000000001";
    
    --         123456789012345678901234
    data_in <="000000000000000000000001"; 

    data_ready <='1'; 

    sram_sel <='0'; 

    need_input <= '0';

    wait for 10 ns;

  wait for 100 ns;
-- ##########################################################################

-- ##################### CASE one    4ST ##################################
--                12345678901234567890
    address_in <="00000000000000000010";
    
    --         123456789012345678901234
    data_in <="000000000000000000000010"; 

    data_ready <='1'; 

    sram_sel <='0'; 

    need_input <= '0';

    wait for 10 ns;

  wait for 100 ns;

-- ##################### CASE one    4ST ##################################
--                12345678901234567890
    address_in <="00000000000000000011";
    
    --         123456789012345678901234
    data_in <="000000000000000000000011"; 

    data_ready <='1'; 

    sram_sel <='0'; 

    need_input <= '0';

    wait for 10 ns;

  wait for 100 ns;
    

    
-- ##########################################################################
    
-- ##################### CASE one   4ST ##################################
-- Example of how to dump the memory contents to a file
  tb_mem_dump        <= TRUE;
  --                     123456789012345678901234   
  tb_dump_filename  <=  "source/test_mem_dum2.txt";
  tb_start_address  <= 0; -- Can be any address 
  tb_last_address    <= TB_MAX_ADDRESS; -- Can be any address larger than the start_address
  wait for 1 ns; -- Can be as long or as short as you like, as long as it is longer than 1 simulation time-step
  tb_mem_dump        <= FALSE;
  wait for 100 ns;

-- ##########################################################################
    



-- ##################### CASE one   5ST ##################################
-- goal: read from address "1" to "1111......11111"
  --rst_n <= '1';
 sram_sel <='1'; 
    need_input <= '1';
 wait for 10 ns;
   sram_sel <= '0';
   need_input <= '0';
 
 for i in 0 to 10 loop
     need_input <= '1';
     wait for 10 ns;
     need_input <= '0';
     wait for 10 ns;
 end loop;


--  wait for 100 ns;  


-- ##########################################################################
-- ##########################################################################
-- #################### TO SRAM 2 ##############################
-- ##########################################################################



    
--  ##########################   CASE 6 WRITE  #######################################


    
    address_in <="00000000000000000000";
    
    --         123456789012345678901234
    data_in <="101010101010101010101010"; 

    data_ready <='1'; 

  
    wait for 100 ns;


-- ##########################################################################    

 --  ##########################   CASE 7 WRITE  #######################################


    
    address_in <="00000000000000000011";
    
    --         123456789012345678901234
    data_in <="000000000000000000000111"; 

    data_ready <='1'; 

  
    wait for 100 ns;


-- ##########################################################################    

 --  ##########################   CASE 8 WRITE  #######################################


    
    address_in <="00000000000000000100";
    
    --         123456789012345678901234
    data_in <="000000000000001000101100"; 

    data_ready <='1'; 

  
    wait for 100 ns;


-- ##########################################################################    

--  ##########################   CASE 8 read from 2, chang sel_w to 0  #######################################
--  
      sram_sel <='1';                   -- switch the sram 
      wait for 10 ns;
      sram_sel <= '0';
     
 for i in 0 to 10 loop
     need_input <= '1';
     wait for 10 ns;
     need_input <= '0';
     wait for 10 ns;
 end loop;
-- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE

    

  rst_n <= '0';
    wait for 10 ns;
    rst_n <= '1';
    
-- case one write in every address in sram 1
    sram_sel <= '1';
    wait for 10 ns;
    sram_sel <= '0';

    for i_2 in 0 to 345599 loop

     while (pixel_done = '0') loop
        wait for 1 ns;
     end loop;

      address_in <=UINT_TO_STDV( i_2 , 20 );
      data_in <=UINT_TO_STDV( i_2 , 24 );
      data_ready <= '1';
      wait for 40 ns;
      
    end loop;  -- i_2
    
-- case two : switch the sram, and read the file
    sram_sel <= '1';
    wait for 10 ns;
    sram_sel <= '0';

    for i_3 in 0 to 99999 loop
     need_input <= '1';
     wait for 10 ns;
     need_input <= '0';
     wait for 10 ns;
    end loop;  -- i_3

    

 







-- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE
    -- FOR COVERAGE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CASE







     
   wait;

  end process;
end TEST;
