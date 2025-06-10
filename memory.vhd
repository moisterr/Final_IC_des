library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory IS
    port (
        clk    : IN std_logic;
        we_in  : IN std_logic;
        re_in  : IN std_logic;
        addr   : IN std_logic_vector(17 downto 0);  -- 9 for input + 16 for output
        d_in   : IN std_logic_vector(23 downto 0);
        d_out  : OUT std_logic_vector(23 downto 0)
    );
end memory;

architecture behavior of memory is
    type memory_data is array(0 to 262143) of std_logic_vector(23 downto 0);
    signal memory_array : memory_data := (
    -- Input image 5x5: values 1 to 25
    0  => std_logic_vector(to_unsigned(17, 24)),
    1  => std_logic_vector(to_unsigned(24, 24)),
    2  => std_logic_vector(to_unsigned(1, 24)),
    3  => std_logic_vector(to_unsigned(8, 24)),
    4  => std_logic_vector(to_unsigned(15, 24)),
    5  => std_logic_vector(to_unsigned(23, 24)),
    6  => std_logic_vector(to_unsigned(5, 24)),
    7  => std_logic_vector(to_unsigned(7, 24)),
    8  => std_logic_vector(to_unsigned(14, 24)),
    9  => std_logic_vector(to_unsigned(16, 24)),
    10  => std_logic_vector(to_unsigned(4, 24)),
    11  => std_logic_vector(to_unsigned(6, 24)),
    12  => std_logic_vector(to_unsigned(13, 24)),
    13  => std_logic_vector(to_unsigned(20, 24)),
    14  => std_logic_vector(to_unsigned(22, 24)),
    15  => std_logic_vector(to_unsigned(10, 24)),
    16  => std_logic_vector(to_unsigned(12, 24)),
    17  => std_logic_vector(to_unsigned(19, 24)),
    18  => std_logic_vector(to_unsigned(21, 24)),
    19  => std_logic_vector(to_unsigned(3, 24)),
    20  => std_logic_vector(to_unsigned(11, 24)),
    21  => std_logic_vector(to_unsigned(18, 24)),
    22  => std_logic_vector(to_unsigned(25, 24)),
    23  => std_logic_vector(to_unsigned(2, 24)),
    24  => std_logic_vector(to_unsigned(9, 24)),

    others => (others => '0')
);
begin
    process(clk)
    begin
        if rising_edge(clk) then
	    assert (addr >= 0 and addr <= 262143)
	    report "Address check failed: out of 0 to 262143 range." severity failure;
            if we_in = '1' then
                memory_array(conv_integer(addr)) <= d_in;
            end if;
            if re_in = '1' then
                d_out <= memory_array(conv_integer(addr));
            else
                d_out <= (others => '0');
            end if;
        end if;
    end process;
end behavior;
