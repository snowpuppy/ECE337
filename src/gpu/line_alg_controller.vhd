-- $Id: $
-- File name:   line_alg_controller.vhd
-- Created:     11/30/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This is the controlling block for the line algorithm. It controls the pre-calculations
-- and communicates with upper blocks to tell the sram when to read an address.


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity line_alg_controller is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        small_slope         : in    std_logic;
        positive_slope      : in    std_logic;
        next_line           : in    std_logic;
        next_pixel          : in    std_logic;
        status              : in    std_logic_vector(7 downto 0); -- each block has two status bits which come here (4 blocks).
        load                : out    std_logic;
        strobe              : out    std_logic;
        read_data           : out    std_logic;
        line_drawn          : out   std_logic;
        pixel_ready         : out   std_logic;
        enable              : out    std_logic_vector(3 downto 0)
    );
end entity line_alg_controller;

architecture line_alg_controller_arch of line_alg_controller is
    signal pos_small_pixel_rdy, pos_large_pixel_rdy, neg_small_pixel_rdy, neg_large_pixel_rdy : std_logic;
    signal pos_small_line_done, pos_large_line_done, neg_small_line_done, neg_large_line_done : std_logic;
    type stateType is (IDLE,IDLE2,READ,READ2,BRANCH,NEL,NLP,NLW,NES,NSP,NSW,POL,PLP,PLW,POS,PSP,PSW);
    signal state, nextstate : stateType;
begin

  -- state register. Keeps track of the state.
  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
      state <= IDLE;
    elsif rising_edge(clk) then  -- check clock edge
      state <= nextstate;
    end if;
  end process reg;

  nextStateLogic: process(state, next_line, positive_slope, small_slope, next_pixel, pos_small_pixel_rdy, pos_small_line_done, pos_large_pixel_rdy, pos_large_line_done, neg_small_pixel_rdy, neg_small_line_done, neg_large_pixel_rdy, neg_large_line_done )
  begin
    -- Set default next values.
    nextstate <= state;
    case state is
        when IDLE =>
            if (next_line = '1') then
                nextstate <= IDLE2;
            end if;
        when IDLE2 =>
            nextstate <= READ;
        when READ =>
            nextstate <= READ2;
        when READ2 =>
            nextstate <= BRANCH;
        when BRANCH =>
            if (positive_slope = '1') then
                if small_slope = '1' then
                    nextstate <= POS;
                else
                    nextstate <= POL;
                end if;
            else
                if small_slope = '1' then
                    nextstate <= NES;
                else
                    nextstate <= NEL;
                end if;
            end if;
        -----------------------------
        -- positive slope small slope
        -----------------------------
        when POS =>
            if pos_small_line_done = '1' then
                nextstate <= IDLE;
            elsif next_pixel = '1' then
                nextstate <= PSP;
            end if;
        when PSP =>
            if pos_small_pixel_rdy = '1' then
                nextstate <= PSW;
            end if;
        when PSW =>
            nextstate <= POS;
        -----------------------------
        -- positive slope large slope
        -----------------------------
        when POL =>
            if pos_large_line_done = '1' then
                nextstate <= IDLE;
            elsif next_pixel = '1' then
                nextstate <= PLP;
            end if;
        when PLP =>
            if pos_large_pixel_rdy = '1' then
                nextstate <= PLW;
            end if;
        when PLW =>
            nextstate <= POL;
        -----------------------------
        -- negative slope small slope
        -----------------------------
        when NES =>
            if neg_small_line_done = '1' then
                nextstate <= IDLE;
            elsif next_pixel = '1' then
                nextstate <= NSP;
            end if;
        when NSP =>
            if neg_small_pixel_rdy = '1' then
                nextstate <= NSW;
            end if;
        when NSW =>
            nextstate <= NES;
        -----------------------------
        -- negative slope large slope
        -----------------------------
        when NEL =>
            if neg_large_line_done = '1' then
                nextstate <= IDLE;
            elsif next_pixel = '1' then
                nextstate <= NLP;
            end if;
        when NLP =>
            if neg_large_pixel_rdy = '1' then
                nextstate <= NLW;
            end if;
        when NLW =>
            nextstate <= NEL;
    end case;
  end process nextStateLogic;

  output: process( state )
  begin
        -- default value of any output signal.
        line_drawn <= '0';
        pixel_ready <= '0';
        load <= '0';
        strobe <= '0';
        enable <= "0000";
        read_data <= '0';

        case state is
            when IDLE =>
                line_drawn <= '1';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '0';
                enable <= "0000";
                read_data <= '0';
            when IDLE2 =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '0';
                enable <= "0000";
                read_data <= '0';
            when READ =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '0';
                enable <= "0000";
                read_data <= '1';
            when READ2 =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '0';
                enable <= "0000";
                read_data <= '1';
            when BRANCH =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '1';
                strobe <= '0';
                enable <= "0000";
                read_data <= '0';
            when POS =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '0';
                enable <= "0001";
                read_data <= '0';
            when PSP =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '1';
                enable <= "0001";
                read_data <= '0';
            when PSW =>
                line_drawn <= '0';
                pixel_ready <= '1';
                load <= '0';
                strobe <= '0';
                enable <= "0001";
                read_data <= '0';
            when POL =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '0';
                enable <= "0010";
                read_data <= '0';
            when PLP =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '1';
                enable <= "0010";
                read_data <= '0';
            when PLW =>
                line_drawn <= '0';
                pixel_ready <= '1';
                load <= '0';
                strobe <= '0';
                enable <= "0010";
                read_data <= '0';
            when NES =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '0';
                enable <= "0100";
                read_data <= '0';
            when NSP =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '1';
                enable <= "0100";
                read_data <= '0';
            when NSW =>
                line_drawn <= '0';
                pixel_ready <= '1';
                load <= '0';
                strobe <= '0';
                enable <= "0100";
                read_data <= '0';
            when NEL =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '0';
                enable <= "1000";
                read_data <= '0';
            when NLP =>
                line_drawn <= '0';
                pixel_ready <= '0';
                load <= '0';
                strobe <= '1';
                enable <= "1000";
                read_data <= '0';
            when NLW =>
                line_drawn <= '0';
                pixel_ready <= '1';
                load <= '0';
                strobe <= '0';
                enable <= "1000";
                read_data <= '0';
        end case;
  end process output;

    -- status signal renamings. (for clarity)
    pos_small_pixel_rdy <= status(0);
    pos_small_line_done <= status(1);
    pos_large_pixel_rdy <= status(2);
    pos_large_line_done <= status(3);
    neg_small_pixel_rdy <= status(4);
    neg_small_line_done <= status(5);
    neg_large_pixel_rdy <= status(6);
    neg_large_line_done <= status(7);
end architecture line_alg_controller_arch;
