library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc is
    port(
        clk     : in std_logic;
        reset   : in std_logic;
        load_pc : in std_logic;
        pc_addr_out : out std_logic_vector(3 downto 0)
    );
end entity pc;

architecture Behavioral of pc is
    signal pc_reg : unsigned(3 downto 0) := (others => '0');
begin

    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');       -- synchronous reset is okay, but async is safer

        elsif rising_edge(clk) then
            if load_pc = '1' then
                pc_reg <= pc_reg + 1;        -- increment PC
            end if;
        end if;
    end process;

    pc_addr_out <= std_logic_vector(pc_reg);

end Behavioral;
