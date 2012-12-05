-- $Id: $
-- File name:   gpu_controller.vhd
-- Created:     12/2/2012
-- Author:      Thor Smith
-- Lab Section: 337-02
-- Version:     1.0  Initial Design Entry
-- Description: This piece of work controlls what data goes where in the gpu and what
-- mode to use! It also works to verify that coordinates are valid before sending them
-- to the SRAM interface!


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity gpu_controller is
    port (
        clk                 : in    std_logic;
        rst                 : in    std_logic;
        read_frame          : in    std_logic;
        control             : in    std_logic_vector(2 downto 0);
        pixel_ready         : in    std_logic;
        data_read           : in    std_logic;
        valid               : in    std_logic;
        done1               : in    std_logic;
        done2               : in    std_logic;
        start               : out   std_logic;
        data_ready          : out   std_logic;
        computation_done    : out   std_logic;
        next_pixel          : out   std_logic;
        strobe_fill         : out   std_logic;
        read_input          : out   std_logic;
        new_data            : out   std_logic;
        mode                : out   std_logic
        );
end entity gpu_controller;

architecture gpu_controller_arch of gpu_controller is
    type stateType is (IDLE,READ,BRANCH,DRLN,CHKERRL,TR,WAI1,PIXELFILL,STROBE,WAITERR,CHKERR,WAI2,MWAI2);
    signal state, nextstate : stateType;
begin

  reg: process (clk, rst)
  begin
    if rst = '1' then -- active reset
        state <= IDLE;
    elsif rising_edge(clk) then  -- check clock edge
        state <= nextstate;
    end if;
  end process reg;

  nextStateLogic: process(state, read_frame, control, pixel_ready, data_read, valid, done1, done2)
  begin
    -- Set default next values.
    nextstate <= state;
    case state is
        when IDLE =>
            if (read_frame = '1') then
                nextstate <= READ;
            end if;
        when READ =>
            nextstate <= BRANCH;
        when BRANCH =>
            if control = "001" then
                nextstate <= DRLN;
            elsif control = "100" then
                nextstate <= STROBE;
            else
                nextstate <= PIXELFILL;
            end if;
        when DRLN =>
            if pixel_ready = '1' then
                nextstate <= CHKERRL;
            end if;
        when CHKERRL =>
            if valid = '1' then
                nextstate <= TR;
            else
                nextstate <= DRLN;
            end if;
        when TR =>
            if data_read = '1' then
                nextstate <= WAI1;
            end if;
        when WAI1 =>
            if done1 = '1' then
                nextstate <= IDLE;
            else
                nextstate <= DRLN;
            end if;
        when PIXELFILL =>
            nextstate <= STROBE;
        when STROBE =>
            nextstate <= WAITERR;
        when WAITERR =>
            nextstate <= CHKERR;
        when CHKERR =>
            if valid = '1' then
                nextstate <= WAI2;
            else
                nextstate <= STROBE;
            end if;
        when WAI2 =>
            if data_read = '1' then
                nextstate <= MWAI2;
            end if;
        when MWAI2 =>
            if done2 = '1' or control = "011" or control = "100" then
                nextstate <= IDLE;
            else
                nextstate <= STROBE;
            end if;
    end case;
  end process nextStateLogic;

  output: process( state )
  begin
        -- default value of any output signal.
        start <= '0';
        data_ready <= '0';
        computation_done <= '0';
        next_pixel <= '0';
        strobe_fill <= '0';
        read_input <= '0';
        new_data <= '0';
        mode <= '0';

        case state is
            when IDLE =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '1';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '0';
            when READ =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '1';
                new_data <= '0';
                mode <= '0';
            when BRANCH =>
                start <= '1';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '0';
            when DRLN =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '1';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '0';
            when CHKERRL =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '0';
            when TR =>
                start <= '0';
                data_ready <= '1';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '0';
            when WAI1 =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '0';
            when PIXELFILL =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '1';
                mode <= '1';
            when STROBE =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '1';
                read_input <= '0';
                new_data <= '0';
                mode <= '1';
            when WAITERR =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '1';
            when CHKERR =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '1';
            when WAI2 =>
                start <= '0';
                data_ready <= '1';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '1';
            when MWAI2 =>
                start <= '0';
                data_ready <= '0';
                computation_done <= '0';
                next_pixel <= '0';
                strobe_fill <= '0';
                read_input <= '0';
                new_data <= '0';
                mode <= '1';
        end case;
  end process output;

end architecture gpu_controller_arch;
