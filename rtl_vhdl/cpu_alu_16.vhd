library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu_alu_16 is
    generic (width : integer := 16);
    port (
        a, b   : in  std_logic_vector(width-1 downto 0);
        opcode : in  std_logic_vector(2 downto 0);
        mode   : in  std_logic;
        clk    : in  std_logic;
        result : out std_logic_vector(width-1 downto 0);
        cout   : out std_logic
    );
end cpu_alu_16;

architecture Behavioral of cpu_alu_16 is
    signal result_reg : std_logic_vector(width-1 downto 0);
    signal cout_reg   : std_logic;
begin

    process(clk)
        variable tmp_result : unsigned(width downto 0);
        variable a_u, b_u   : unsigned(width-1 downto 0);
    begin
        if rising_edge(clk) then

            a_u := unsigned(a);
            b_u := unsigned(b);

            if mode = '0' then       -- Arithmetic operations
                case opcode is

                    when "000" =>     -- ADD
                        tmp_result := ('0' & a_u) + ('0' & b_u);
                        result_reg <= std_logic_vector(tmp_result(width-1 downto 0));
                        cout_reg   <= tmp_result(width);

                    when "001" =>     -- SUB
                        tmp_result := ('0' & a_u) - ('0' & b_u);
                        result_reg <= std_logic_vector(tmp_result(width-1 downto 0));
                        cout_reg   <= tmp_result(width);

                    when "010" =>     -- MULT (8×8)
                        tmp_result :=
                            resize(unsigned(a(7 downto 0)) * unsigned(b(7 downto 0)), width+1);
                        result_reg <= std_logic_vector(tmp_result(width-1 downto 0));
                        cout_reg   <= tmp_result(width);

                    when "011" =>     -- DIV
                        if b = std_logic_vector(to_unsigned(0, width)) then
                            result_reg <= (others => '0');
                            cout_reg   <= '1';
                        else
                            tmp_result := resize(
                                to_unsigned(
                                    to_integer(a_u) / to_integer(b_u),
                                    width),
                                width+1
                            );
                            result_reg <= std_logic_vector(tmp_result(width-1 downto 0));
                            cout_reg   <= '0';
                        end if;

                    when "100" =>   -- INC A
                        tmp_result := ('0' & a_u) + 1;
                        result_reg <= std_logic_vector(tmp_result(width-1 downto 0));
                        cout_reg   <= tmp_result(width);

                    when "101" =>   -- INC B
                        tmp_result := ('0' & b_u) + 1;
                        result_reg <= std_logic_vector(tmp_result(width-1 downto 0));
                        cout_reg   <= tmp_result(width);

                    when "110" =>   -- DEC A
                        tmp_result := ('0' & a_u) - 1;
                        result_reg <= std_logic_vector(tmp_result(width-1 downto 0));
                        cout_reg   <= tmp_result(width);

                    when "111" =>   -- ADD + carry = 1
                        tmp_result := ('0' & a_u) + ('0' & b_u) + 1;
                        result_reg <= std_logic_vector(tmp_result(width-1 downto 0));
                        cout_reg   <= tmp_result(width);

                    when others =>
                        result_reg <= (others => '0');
                        cout_reg   <= '0';

                end case;

            else                    -- Logical operations
                case opcode is
                    when "000" => result_reg <= a and b;
                    when "001" => result_reg <= a or b;
                    when "010" => result_reg <= a xor b;
                    when "011" => result_reg <= not a;
                    when "100" => result_reg <= not (a and b);
                    when "101" => result_reg <= not (a or b);
                    when "110" => result_reg <= not (a xor b);
                    when "111" => result_reg <= a and (not b);
                    when others => result_reg <= (others => '0');
                end case;

                cout_reg <= '0';
            end if;
        end if;
    end process;

    result <= result_reg;
    cout   <= cout_reg;

end Behavioral;
