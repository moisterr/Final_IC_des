library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    port ( 
    clk, rst: in STD_logic;
	en: in std_logic;
	d: in std_logic_vector(23 downto 0);
	q: out std_logic_vector(23 downto 0) );
end reg;

architecture rtl of reg is
begin
	process(rst,clk)
	begin
		if (rst = '1') then
			q <= (others => '0');
		elsif (clk'event and clk = '1') then
			if(en = '1') then
				q <= d;
			end if; 	
		end if;
	end process;
end rtl;