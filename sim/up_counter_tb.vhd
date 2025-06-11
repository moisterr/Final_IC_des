library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.lib.ALL;

entity up_counter_tb is
end up_counter_tb;

architecture behavior of up_counter_tb is

    signal clk_tb   : std_logic := '0';
    signal rst_tb   : std_logic := '0';
    signal inc_tb   : std_logic := '0';
    signal z_tb     : std_logic;
    signal count_tb : std_logic_vector(8 downto 0);
    signal stop_tb  : std_logic_vector(8 downto 0) := "000001010"; -- 10

    constant clk_period : time := 10 ns;

begin

    uut: up_counter
        generic map(start => "000000000")
        port map (
            clk   => clk_tb,
            rst   => rst_tb,
            inc   => inc_tb,
            z     => z_tb,
            count => count_tb,
            stop  => stop_tb
        );

    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stim_proc: process
    begin
        rst_tb <= '1';
        wait for clk_period;
        rst_tb <= '0';
        inc_tb <= '1';
        wait for clk_period * 12;
        inc_tb <= '0';
        wait;
    end process;

end behavior;

