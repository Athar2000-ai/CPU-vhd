library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_mem is
    port (
        clk               : in  std_logic;
        weIM              : in  std_logic;  
        input_instruction : in  std_logic_vector(23 downto 0);
        address           : in  std_logic_vector(3 downto 0);
        instruction       : out std_logic_vector(23 downto 0)
    );
end instr_mem;

architecture Behavioral of instr_mem is
    type memory_array is array (0 to 15) of std_logic_vector(23 downto 0);
    signal mem : memory_array := (others => (others => '0'));
begin

    process(clk)
    begin
      -- writing memory  
        if rising_edge(clk) then
            if weIM = '1' then
                mem(to_integer(unsigned(address))) <= input_instruction;
            end if;
        end if;
    end process;

    -- Reading memory
    instruction <= mem(to_integer(unsigned(address)));

end Behavioral;
