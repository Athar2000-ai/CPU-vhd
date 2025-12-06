library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu_IR_24 is
    Port ( 
        instruction   : in  std_logic_vector(23 downto 0);
        clk           : in  std_logic;
        load_ir       : in  std_logic;
        reset         : in  std_logic;
        function_ir   : out std_logic_vector(23 downto 21);
        alu_opcode    : out std_logic_vector(20 downto 18);
        alu_mode      : out std_logic;
        reg_index     : out std_logic;
        data_address  : out std_logic_vector(15 downto 0)
    );
end cpu_IR_24;

architecture Behavioral of cpu_IR_24 is
    signal instr : std_logic_vector(23 downto 0) := (others => '0');
begin

    process(clk, reset)
    begin
        if reset = '1' then
            instr <= (others => '0');

        elsif rising_edge(clk) then
            if load_ir = '1' then
                instr <= instruction;
            end if;
        end if;
    end process;

    -- Decode fields
    function_ir  <= instr(23 downto 21);
    alu_opcode   <= instr(20 downto 18);
    alu_mode     <= instr(17);
    reg_index    <= instr(16);
    data_address <= instr(15 downto 0);

end Behavioral;
