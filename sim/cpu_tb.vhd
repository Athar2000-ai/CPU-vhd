library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu_tb is
end entity;

architecture behavior of cpu_tb is
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal enable  : std_logic := '0';
    signal weIM    : std_logic := '0';

    signal InputInstruction : std_logic_vector(23 downto 0) := (others => '0');
    signal InputAddress     : std_logic_vector(3 downto 0) := (others => '0');

    signal Cout     : std_logic;
    signal CPUout   : std_logic_vector(15 downto 0);
    signal DMout    : std_logic_vector(15 downto 0);

begin
    -- Linking the entity
    UUT : entity work.cpu
    port map(
        clk => clk,
        reset => reset,
        enable => enable,
        weIM => weIM,
        InputInstruction => InputInstruction,
        InputAddress     => InputAddress,   
        Cout => Cout,
        CPUout => CPUout,
        DMout => DMout
    );

    clk_process : process
    begin
        clk <= '0'; wait for 10 ns;
        clk <= '1'; wait for 10 ns;
    end process;
    
    -- Inserting Stimulus
    stimulus : process
    begin
        -- Reset
        reset <= '1'; enable <= '0'; weIM <= '0';
        wait for 40 ns;
        reset <= '0';
        wait for 40 ns;

        --  Loading  
        weIM <= '1'; enable <= '0';

        --  Load A, 0003
        InputAddress <= "0000";
        InputInstruction <= "000" & "000" & "0" & "0" & x"0003";
        wait for 20 ns;

        -- Load B, 0006
        InputAddress <= "0001";
        InputInstruction <= "000" & "000" & "0" & "1" & x"0006";
        wait for 20 ns;

        -- ADD A + B
        InputAddress <= "0010";
        InputInstruction <= "010" & "000" & "0" & "0" & x"0000";
        wait for 20 ns;

        -- Store C 
        InputAddress <= "0011";
        InputInstruction <= "001" & "000" & "0" & "0" & x"0001";
        wait for 20 ns;

        -- RdMem 
        InputAddress <= "0100";
        InputInstruction <= "011" & "000" & "0" & "0" & x"0001";
        wait for 20 ns;

        -- SUB A - B
        InputAddress <= "0101";
        InputInstruction <= "010" & "001" & "0" & "0" & x"0000";
        wait for 20 ns;

        -- Store C 
        InputAddress <= "0110";
        InputInstruction <= "001" & "000" & "0" & "0" & x"0002";
        wait for 20 ns;

        -- RdMem 2
        InputAddress <= "0111";
        InputInstruction <= "011" & "000" & "0" & "0" & x"0002";
        wait for 20 ns;

        -- MULT A * B  (opcode 010, alu_opcode=010)
        InputAddress <= "1000";
        InputInstruction <= "010" & "010" & "0" & "0" & x"0000";
        wait for 20 ns;

        -- Store C 
        InputAddress <= "1001";
        InputInstruction <= "001" & "000" & "0" & "0" & x"0003";
        wait for 20 ns;

        --  RdMem 3
        InputAddress <= "1010";
        InputInstruction <= "011" & "000" & "0" & "0" & x"0003";
        wait for 20 ns;

        -- Exit
        InputAddress <= "1011";
        InputInstruction <= "111" & "000" & "0" & "0" & x"0000";
        wait for 20 ns;

        
        weIM <= '0';
        InputAddress <= (others => '0');

        -- Execute
        enable <= '1';
        wait for 2000 ns;

        wait;
    end process;

end architecture;
