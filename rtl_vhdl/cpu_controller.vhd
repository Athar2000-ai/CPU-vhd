    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    
    entity cpu_controller is
      port (
        clk, reset, enable      : in  std_logic;
        opcode_func             : in  std_logic_vector(2 downto 0); -- bits 23-21
        alu_opcode_in           : in  std_logic_vector(2 downto 0); -- bits 20-18
        alu_mode_in             : in  std_logic;                    -- bit 17
        reg_index_in            : in  std_logic;                    -- bit 16
    
        LoadA, LoadB, LoadC     : out std_logic;
        LoadIR, LoadPC          : out std_logic;
        WeDM, ReDM, Sel         : out std_logic;
        ALUMode                 : out std_logic;
        ALUOpcode               : out std_logic_vector(2 downto 0);
        ex                      : out std_logic
      );
    end entity;
    
    architecture fsm of cpu_controller is
    
      type state_type is (IDLE, FETCH, DECODE, EXECUTE, INCREMENT_PC, HALT);
      signal state, next_state : state_type;
    
    begin
    
  -- Synchornous execution
      process(clk, reset)
      begin
        if reset = '1' then
          state <= IDLE;
        elsif rising_edge(clk) then
          state <= next_state;
        end if;
      end process;
    
  -- Implementing FSM 
      process(state, enable, opcode_func, alu_opcode_in, alu_mode_in, reg_index_in)
      begin
    
        -- Initializing values
        LoadA    <= '0';
        LoadB    <= '0';
        LoadC    <= '0';
        LoadIR   <= '0';
        LoadPC   <= '0';
        WeDM     <= '0';
        ReDM     <= '0';
        Sel      <= enable;   
        ALUMode  <= '0';
        ALUOpcode <= (others => '0');
        ex       <= '0';
    
        next_state <= state;
    
        case state is
    
          when IDLE =>
            Sel <= '0';       
            if enable = '1' then
              next_state <= FETCH;
            end if;
    
          when FETCH =>
            LoadIR <= '1';
            next_state <= DECODE;
    
          when DECODE =>
            case opcode_func is
              when "000" => next_state <= EXECUTE; -- Load A/B
              when "001" => next_state <= EXECUTE; -- Store C
              when "010" => next_state <= EXECUTE; -- ALU
              when "011" => next_state <= EXECUTE; -- RdMem
              when "111" => next_state <= HALT;    -- Exit
              when others => next_state <= FETCH;
            end case;
    
          when EXECUTE =>
            case opcode_func is
              when "000" =>    -- Load A or B
                if reg_index_in = '0' then
                  LoadA <= '1';
                else
                  LoadB <= '1';
                end if;
    
              when "001" =>    -- Store C
                WeDM <= '1';
    
              when "010" =>    -- ALU Op
                ALUMode   <= alu_mode_in;
                ALUOpcode <= alu_opcode_in;
                LoadC     <= '1';
    
              when "011" =>    -- RdMem
                ReDM <= '1';
    
              when others => null;
            end case;
    
            -- Exit
            if opcode_func = "111" then
              next_state <= HALT;
            else
              next_state <= INCREMENT_PC;
            end if;
    
          when INCREMENT_PC =>
            LoadPC <= '1';
            next_state <= FETCH;
    
          when HALT =>
            ex <= '1';
            LoadIR <= '0';
            LoadPC <= '0';
            WeDM   <= '0';
            ReDM   <= '0';
            next_state <= HALT;
    
        end case;
    
      end process;
    
    end architecture;
