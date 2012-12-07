-- $Id: $
-- File name:   sequencer.vhd
-- Created:     12/1/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This block takes a connection word and tells the line
-- drawing algorithm which pixels to draw lines between.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity sequencer is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        start               : in    std_logic;
        continue            : in    std_logic;
        line_drawn          : in    std_logic;
        num_vertices        : in    std_logic_vector(7 downto 0);
        connection          : in    std_logic_vector(15 downto 0);
        next_line           : out    std_logic;
        sequence_drawn      : out    std_logic;
        addr                : out   std_logic_vector(3 downto 0)
        );
end entity sequencer;

architecture sequencer_arch of sequencer is
    type stateType is (IDLE, FIND, FINDDONE, NLINE, DRAW, DONE);
    signal state, nextstate : stateType;
    signal count_reg, count_nxt : std_logic_vector(4 downto 0);
    signal count_enable : std_logic;
    signal match_found : std_logic;
    signal mask_reg, mask_nxt : std_logic_vector(15 downto 0);
    --signal addr_reg, addr_nxt : std_logic_vector(3 downto 0);
begin

  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
        count_reg <= (others => '0');
        --addr_reg <= (others => '0');
        state <= IDLE;
        mask_reg <= (others => '0');
    elsif rising_edge(clk) then  -- check clock edge
        count_reg <= count_nxt;
        --addr_reg <= addr_nxt;
        state <= nextstate;
        mask_reg <= mask_nxt;
    end if;
  end process reg;

  -- Counting Process used for counting
  -- the number of vertices.
  count: process(count_reg, count_enable, start, continue)
  begin
    count_nxt <= count_reg;
    if start = '1' or continue = '1' then
        count_nxt <= (others => '0');
    elsif count_enable = '1' then
        count_nxt <= count_reg + 1;
    end if;
  end process count;

  -- Shift mask process for comparing
  -- with the connection word.
  shift: process(mask_reg, start, continue, count_enable)
  begin
    mask_nxt <= mask_reg;
    if start = '1' or continue = '1' then
        mask_nxt <= x"0001";
    elsif count_enable = '1' then
        mask_nxt <= mask_reg(14 downto 0) & '0';
    end if;
  end process shift;

  --addrNext: process(addr_reg, match_found)
  --begin
  --  addr_nxt <= count_reg;
  --  if match_found = '1' then
  --      addr_nxt <= count_reg;
  --  end if;
  --end process addrNext;

  nextStateLogic: process(state, count_reg, start, line_drawn, num_vertices, match_found, continue )
  begin
    -- Set default next values.
    nextstate <= state;
    case state is
        when IDLE =>
            if start = '1' or continue = '1' then
                nextstate <= FIND;
            end if;
        when FIND =>
            if count_reg = num_vertices(4 downto 0) then
                nextstate <= DONE;
            elsif match_found = '1' then
                nextstate <= NLINE;
            else
                nextstate <= FINDDONE;
            end if;
        when FINDDONE =>
            nextstate <= FIND;
        when NLINE =>
            nextstate <= DRAW;
        when DRAW =>
            if line_drawn = '1' then
                nextstate <= FINDDONE;
            end if;
        when DONE =>
            nextstate <= IDLE;
    end case;
  end process nextStateLogic;

  output: process( state )
  begin
        -- default value of any output signal.
        next_line <= '0';
        sequence_drawn <= '0';
        count_enable <= '0';
        case state is
            when IDLE =>
                next_line <= '0';
                sequence_drawn <= '0';
                count_enable <= '0';
            when FIND =>
                next_line <= '0';
                sequence_drawn <= '0';
                count_enable <= '0';
            when FINDDONE =>
                next_line <= '0';
                sequence_drawn <= '0';
                count_enable <= '1';
            when NLINE =>
                next_line <= '1';
                sequence_drawn <= '0';
                count_enable <= '0';
            when DRAW =>
                next_line <= '0';
                sequence_drawn <= '0';
                count_enable <= '0';
            when DONE =>
                next_line <= '0';
                sequence_drawn <= '1';
                count_enable <= '0';
        end case;
  end process output;

  addr <= count_reg(3 downto 0);
  match_found <= (connection(1) and mask_reg(1)) or (connection(2) and mask_reg(2)) or (connection(3) and mask_reg(3)) or (connection(4) and mask_reg(4)) or (connection(5) and mask_reg(5)) or (connection(6) and mask_reg(6)) or (connection(7) and mask_reg(7)) or (connection(0) and mask_reg(0));

end architecture sequencer_arch;
