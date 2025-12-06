library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu is
  port (
    clk, reset, enable, weIM : in std_logic;
    InputInstruction         : in std_logic_vector(23 downto 0);
    InputAddress             : in std_logic_vector(3 downto 0);  
    Cout                     : out std_logic;
    CPUout, DMout            : out std_logic_vector(15 downto 0)
  );
end entity;

architecture Structural of cpu is

  -- signal input_address    : std_logic_vector(3 downto 0) := (others => '0'); 
  signal pc_addr_out      : std_logic_vector(3 downto 0);
  signal address_out      : std_logic_vector(3 downto 0);

  signal out_instruction  : std_logic_vector(23 downto 0);

  -- IR fields
  signal function_ir      : std_logic_vector(23 downto 21);
  signal alu_opcode_ir    : std_logic_vector(2 downto 0);
  signal alu_mode_ir      : std_logic;
  signal reg_index        : std_logic;
  signal data_address     : std_logic_vector(15 downto 0);

  -- Controller outputs TO ALU
  signal alu_opcode_ctrl  : std_logic_vector(2 downto 0);
  signal alu_mode_ctrl    : std_logic;

  -- Registers A, B, C
  signal A, B, C          : std_logic_vector(15 downto 0);

  -- Controller signals
  signal LoadA, LoadB, LoadC : std_logic;
  signal LoadIR, LoadPC      : std_logic;
  signal WeDM, ReDM          : std_logic;
  signal Sel                 : std_logic;

  -- ALU
  signal ALUout        : std_logic_vector(15 downto 0);
  signal Cout_int      : std_logic;

  -- Data Memory
  signal DMdataOut     : std_logic_vector(16 downto 0);

begin

  -- MUX (InputAddress vs PC)
  MUX : entity work.mux2
    port map(
      input_address => InputAddress,   -- <-- drive from TOP PORT
      prog_counter  => pc_addr_out,
      S             => Sel,
      Y             => address_out
    );

  
  IM: entity work.instr_mem
    port map(
      clk               => clk,
      weIM              => weIM,
      input_instruction => InputInstruction,
      address           => address_out,
      instruction       => out_instruction
    );

  IR: entity work.cpu_IR_24
    port map(
      clk          => clk,
      load_ir      => LoadIR,
      reset        => reset,
      instruction  => out_instruction,
      function_ir  => function_ir,
      alu_opcode   => alu_opcode_ir,
      alu_mode     => alu_mode_ir,
      reg_index    => reg_index,
      data_address => data_address
    );

  RegA: entity work.cpu_reg_16
    port map(
      clk     => clk,
      reset   => reset,
      load    => LoadA,
      reg_in  => data_address,
      reg_out => A
    );

  RegB: entity work.cpu_reg_16
    port map(
      clk     => clk,
      reset   => reset,
      load    => LoadB,
      reg_in  => data_address,
      reg_out => B
    );

  RegC: entity work.cpu_reg_16
    port map(
      clk     => clk,
      reset   => reset,
      load    => LoadC,
      reg_in  => ALUout,
      reg_out => C
    );

  ALU: entity work.cpu_alu_16
    port map(
      a       => A,
      b       => B,
      opcode  => alu_opcode_ctrl,
      mode    => alu_mode_ctrl,
      clk     => clk,
      result  => ALUout,
      cout    => Cout_int
    );

  DM: entity work.data_mem
    port map(
      clk     => clk,
      weDM    => WeDM,
      reDM    => ReDM,
      address => data_address(3 downto 0),
      dm_in   => Cout_int & C,
      dm_out  => DMdataOut
    );

  PC: entity work.pc
    port map(
      clk         => clk,
      reset       => reset,
      load_pc     => LoadPC,
      pc_addr_out => pc_addr_out
    );

  CTRL: entity work.cpu_controller
    port map(
      clk           => clk,
      reset         => reset,
      enable        => enable,
      opcode_func   => function_ir,
      alu_opcode_in => alu_opcode_ir,
      alu_mode_in   => alu_mode_ir,
      reg_index_in  => reg_index,
      LoadA         => LoadA,
      LoadB         => LoadB,
      LoadC         => LoadC,
      LoadIR        => LoadIR,
      LoadPC        => LoadPC,
      WeDM          => WeDM,
      ReDM          => ReDM,
      Sel           => Sel,
      ALUMode       => alu_mode_ctrl,
      ALUOpcode     => alu_opcode_ctrl,
      ex            => open
    );

  Cout   <= Cout_int;
  CPUout <= C;
  DMout  <= DMdataOut(15 downto 0);

end architecture;
