library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_mem is
    port (
        clk      : in  std_logic;
        weDM     : in  std_logic;
        reDM     : in  std_logic;
        address  : in  std_logic_vector(3 downto 0);
        dm_in    : in  std_logic_vector(16 downto 0);
        dm_out   : out std_logic_vector(16 downto 0)
    );
end data_mem;

architecture Behavioral of data_mem is
    type memory_array is array (0 to 15) of std_logic_vector(16 downto 0);
    signal mem : memory_array := (others => (others => '0'));
    signal read_data : std_logic_vector(16 downto 0);
begin

    -- Writing memory on rise clk
    process(clk)
    begin
        if rising_edge(clk) then
            if weDM = '1' then
                mem(to_integer(unsigned(address))) <= dm_in;
            end if;
        end if;
    end process;

    -- Reading memory (not dependent on clk)
    process(mem, address, reDM)
    begin
        if reDM = '1' then
            read_data <= mem(to_integer(unsigned(address)));
        else
            read_data <= (others => '0');
        end if;
    end process;

    dm_out <= read_data;

end Behavioral;
