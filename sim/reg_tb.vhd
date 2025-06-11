library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.lib.ALL;

entity reg_tb is
end reg_tb;

architecture behavior of reg_tb is

    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal en_tb  : std_logic := '0';
    signal d_tb   : std_logic_vector(31 downto 0) := (others => '0');
    signal q_tb   : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: reg port map (
        clk => clk_tb,
        rst => rst_tb,
        en  => en_tb,
        d   => d_tb,
        q   => q_tb
    );

    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period/2;
            clk_tb <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    stim_proc: process
    begin
        rst_tb <= '1';
        wait for clk_period;
        rst_tb <= '0';
        wait for clk_period;

        en_tb <= '1';
        d_tb <= x"00000001";
        wait for clk_period;

        en_tb <= '0';
        d_tb <= x"000000FF";
        wait for clk_period;

        en_tb <= '1';
        d_tb <= x"00000006";
        wait for clk_period;

        rst_tb <= '1';
        wait for clk_period;
        rst_tb <= '0';
        wait;
    end process;

end behavior;

