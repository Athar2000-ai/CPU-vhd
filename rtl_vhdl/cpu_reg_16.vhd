library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_reg_16 is
    generic (width : integer := 16);
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        load    : in  std_logic;
        reg_in  : in  std_logic_vector(width-1 downto 0);
        reg_out : out std_logic_vector(width-1 downto 0)
    );
end cpu_reg_16;

architecture Behavioral of cpu_reg_16 is
    signal q_reg : std_logic_vector(width-1 downto 0);
begin

    process(clk, reset)
    begin
        if reset = '1' then
            q_reg <= (others => '0');

        elsif rising_edge(clk) then
            if load = '1' then
                q_reg <= reg_in;
            end if;
        end if;
    end process;

    reg_out <= q_reg;

end Behavioral;
