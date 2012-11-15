-- $Id: $
-- File name:   seq_divider.vhd
-- Created:     11/10/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This is a sequential divider based on subtract and shift logic.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

entity seq_divider is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        start       : in std_logic;
        divisor     : in std_logic_vector(15 downto 0);
        div         : in std_logic_vector(15 downto 0);
        done        : out std_logic;
        quotient1   : out std_logic_vector(15 downto 0)
    );
end entity seq_divider;

architecture seq_divarch of seq_divider is
signal count, nextCount : std_logic_vector(4 downto 0);
signal temp, nextTemp : std_logic_vector(15 downto 0);
signal tmpsig : std_logic_vector(15 downto 0);
signal res, nextRes : std_logic_vector(15 downto 0);
signal divid1, nextDivid1 : std_logic_vector(15 downto 0);
signal quoti1, nextQuoti1 : std_logic_vector(15 downto 0);
signal done_c : std_logic;

begin

  -- state register. Keeps track of the state.
  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
      count <= ( others => '0' );
      divid1 <= (others => '0');
      quoti1 <= (others => '0');
      temp <= (others => '0');
      res <= (others => '0');
    elsif rising_edge(clk) then  -- check clock edge
      count <= nextCount;
      divid1 <= nextDivid1;
      quoti1 <= nextQuoti1;
      temp <= nextTemp;
      res <= nextRes;
    end if;
  end process reg;


  nextState: process (tmpsig, nextCount, nextTemp, nextDivid1, nextQuoti1, done_c, divid1, quoti1, count, temp, res, divisor, div, start)
  begin
    -- set default values.
    nextCount <= count;
    nextTemp <= temp;
    nextDivid1 <= divid1;
    nextQuoti1 <= quoti1;
    nextRes <= res;
    tmpsig <= (others => '0');

    if ( done_c = '0' ) then -- add three more cycles to get all values.
        -- increment the count
        nextCount <= count + 1;
        -- perform addition
        -- perform subtraction
        tmpsig <= temp(14 downto 0) & divid1(15);
        nextRes <= tmpsig - divisor;
        -- shift in a one or a zero
        if ( nextRes(15) = '1' ) then
            nextQuoti1 <= quoti1(14 downto 0) & '0';
            nextTemp <= tmpsig;
        else
            nextQuoti1 <= quoti1(14 downto 0) & '1';
            nextTemp <= nextRes;
        end if;
         --extract values.
        nextDivid1 <= divid1(14 downto 0) & '0';
    end if;

      -- reset logic
    if (start = '1') then
        nextCount <= ( others => '0');
        nextTemp <= ( others => '0');
        nextDivid1 <= div;
        nextQuoti1 <= ( others => '0');
        nextRes <= ( others => '0');
    end if;

  end process nextState;

    quotient1 <= quoti1;
    done_c <= '1' when count = "10000" else '0';
    done <= done_c;

end architecture seq_divarch;


--  nextState: process (count, temp, res)
--  begin
--      if ( not (count = "10010") ) then -- add three more cycles to get all values.
--        -- increment the count
--        nextCount <= count + 1;
--        -- perform addition
--        nextTemp <= temp + divid1(15);
--        -- perform subtraction
--        nextRes <= temp - divisor;
--        -- extract values.
--        nextDivid1 <= divid1;
--        nextQuoti1 <= quoti1;
--        nextRes <= res;
--      else -- retain state
--        nextCount <= count;
--        nextTemp <= temp;
--        nextDivid1 <= divid1;
--        nextQuoti1 <= quoti1;
--        nextRes <= res;
--      end if;
--  end process nextState;
