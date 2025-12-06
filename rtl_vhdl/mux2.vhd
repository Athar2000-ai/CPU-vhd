library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2 is
    generic ( width : integer := 4 );  -- size of each input
    port (
        input_address : in  STD_LOGIC_VECTOR(width-1 downto 0);
        prog_counter  : in  STD_LOGIC_VECTOR(width-1 downto 0);
        S             : in  STD_LOGIC; 
        Y             : out STD_LOGIC_VECTOR(width-1 downto 0)
    );
end mux2;

architecture Behavioral of mux2 is
begin
    process(input_address, prog_counter, S)
    begin
        if S = '0' then
            Y <= input_address;     -- IM load phase
        elsif S = '1' then
            Y <= prog_counter;      -- normal execution (PC fetch)
        else
            Y <= (others => '0');   -- safety
        end if;
    end process;
end Behavioral;
