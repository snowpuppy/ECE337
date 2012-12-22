-- $Id: $
-- File name:   sram_tb_hangs_sram.vhd
-- Created:     12/3/2012
-- Author:      Xie Hang
-- Lab Section: 07
-- Version:     1.0  Initial Design Entry
-- Description: .


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
library ECE337_IP;
USE ECE337_IP.ALL;

entity sram_tb_hangs_sram is
  
  generic (
    Period : time := 15 ns);

end sram_tb_hangs_sram;


architecture hehe of sram_tb_hangs_sram is

begin  -- hehe

  





-- The declaration for the on-chip scalable sram model
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
          addr      : in    std_logic_vector((addr_size_bits - 1) downto 0);
          data      : inout  std_logic_vector(((data_size_words * word_size_bytes * 8) - 1) downto 0)
        );
  end component scalable_off_chip_sram;

-- An example of how to map an instance of the on-chip scalable sram model (Taken from my test bench)
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
                r_enable  => tb_read_enable,
                w_enable  => tb_write_enable,
                addr      => tb_address,
                data      => tb_data
              );
-- Example of how to connect up to the bidirectional data bus
  IO_DATA: process (tb_write_enable, tb_read_enable, tb_data, tb_write_data)
  begin
    if (tb_read_enable = '1') then
      -- Read mode -> the data pins should connect to the r_data bus & the other bus should float
      tb_read_data  <= tb_data;
      tb_data        <= (others=>'Z');
    elsif(tb_write_enable = '1') then
      -- Write mode -> the data pins should connect to the w_data bus & the other bus should float
      tb_read_data  <= (others=>'Z');
      tb_data  <= tb_write_data;
    else
      -- Disconnect both busses
      tb_read_data  <= (others=>'Z');
      tb_data        <= (others=>'Z');
    end if;
  end process IO_DATA;
  
-- Example of how to do a write
  tb_read_enable  <= '0';
  tb_write_enable  <= '1';
  tb_address  <= std_logic_vector(to_unsigned(<address as a positive integer number>, TB_ADDR_SIZE_BITS));
  tb_write_data    <= std_logic_vector(to_unsigned(<data value as a postitive integer number>, TB_ACC_SIZE_BITS)); -- use "to_signed" instead of "to_unsigned" for negative numbers
  wait for TB_CLK_PERIOD;

-- Example of how to do a read
  tb_read_enable  <= '1';
  tb_write_enable  <= '0';
  tb_address  <= std_logic_vector(to_unsigned(<address as a positive integer number>, TB_ADDR_SIZE_BITS));
  wait for TB_CLK_PERIOD;

-- Example of how to init the memory contents from a file
  tb_mem_init        <= TRUE;
  tb_init_filename  <= "source/test_mem_init.txt";
  wait for 1 ns;  -- Can be as long or as short as you like, as long as it is longer than 1 simulation time-step
  tb_mem_init        <= FALSE;

-- Example of how to dump the memory contents to a file
  tb_mem_dump        <= TRUE;
  tb_dump_filename  <=  "source/test_mem_dump.txt";
  tb_start_address  <= 0; -- Can be any address 
  tb_last_address    <= TB_MAX_ADDRESS; -- Can be any address larger than the start_address
  wait for 1 ns; -- Can be as long or as short as you like, as long as it is longer than 1 simulation time-step
  tb_mem_dump        <= FALSE;

-- Example of how to clear the memory conents
  tb_read_enable    <= '0';
  tb_write_enable    <= '0';
  tb_mem_clr        <= TRUE;
  wait for 1 ns; -- Can be as long or as short as you like, as long as it is longer than 1 simulation time-step
  tb_mem_clr        <= FALSE;

-- The verbose port is used to control allow or silence the assert statements that I embedded into the model to help with debuging your usage of it




  end hehe;
