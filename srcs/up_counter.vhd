library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity up_counter is
    generic( start: std_logic_vector(8 downto 0));
        
    port ( clk, rst   : in std_logic;
    inc   : in std_logic;
    z     : out std_logic;
    count : out std_logic_vector(8 downto 0);
    stop: in std_logic_vector(8 downto 0));
    
end up_counter;

architecture behavioral of up_counter is
    signal temp_counter: std_logic_vector(8 downto 0):= start;
    signal one: std_logic_vector(8 downto 0):= (0 => '1', others => '0');
begin
    process
    begin
        wait until (clk'event and clk = '1');
        if rst = '1' then
            temp_counter <= start;
        ELSIF inc = '1' THEN
            temp_counter <= temp_counter + one;
        end if;
    end process;

    -- z = 1 when temp_counter reach stop
    z <= '1' when temp_counter = stop else '0';
    count <= temp_counter;

end behavioral;

