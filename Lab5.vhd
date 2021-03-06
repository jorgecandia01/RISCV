library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Lab5 is
port(	
	clk       : in std_logic;     
	reset_n   : in std_logic);
end Lab5;

architecture structural of Lab5 is
signal m_pc        :  std_logic_vector(1 downto 0);
signal	en_ir     :  std_logic;
signal	tipo_inst :  std_logic_vector(2 downto 0);
signal	mask_b0   :  std_logic;
signal	en_banco  :  std_logic;
signal	m_banco   :  std_logic_vector(1 downto 0);
signal	m_alu_b   :  std_logic_vector(1 downto 0);
signal	m_alu_a   :  std_logic_vector(1 downto 0);
signal	m_shamt   :  std_logic;
signal	tipo_acc  :  std_logic_vector(1 downto 0);
signal	l_u       :  std_logic;
signal	we_ram    :  std_logic;
signal	m_ram     :  std_logic;
signal   wr_pc_cond  :  std_logic;
signal   wr_pc  :  std_logic;
signal	alu_op    :  std_logic_vector(3 downto 0);
signal en_pc 	 : std_logic;
signal pc_in 	 : std_logic_vector(31 downto 0);
signal pc_out	 : std_logic_vector(31 downto 0);
signal ir_in 	 : std_logic_vector(31 downto 0);
signal ir_out	 : std_logic_vector(31 downto 0);
signal pc_ir 	 : std_logic_vector(31 downto 0);
signal alu_out : std_logic_vector(31 downto 0);
signal alur_out : std_logic_vector(31 downto 0);
signal salidaMul1 : std_logic;
signal inm : std_logic_vector(31 downto 0);
signal D_in : std_logic_vector(31 downto 0);
signal d_ram_alu : std_logic_vector(31 downto 0);
signal reg_a : std_logic_vector(31 downto 0);
signal reg_b : std_logic_vector(31 downto 0);
signal a : std_logic_vector(31 downto 0);
signal b : std_logic_vector(31 downto 0);
signal Dout : std_logic_vector(31 downto 0);
signal shamt : std_logic_vector(4 downto 0);
signal z : std_logic;
signal lt : std_logic;
signal ge : std_logic;
signal int : std_logic;
signal s0 : std_logic;
signal s1 : std_logic;
signal s2 : std_logic;
signal s3 : std_logic;
signal s4 : std_logic_vector(31 downto 0);
signal s5 : std_logic_vector(31 downto 0);
signal s6 : std_logic_vector(31 downto 0);
signal ir : std_logic_vector(1 downto 0);
--signal opcode : std_logic_vector(4 downto 0);

begin

i1:entity work.Registro ---registro PC
port map(
	clk => clk,
	reset_n => reset_n,
	en => en_pc, -- Habilitaci??n carga
	e => pc_in, -- datos
	s =>  pc_out);

i2:entity work.Registro ---registro IR
port map(
	clk => clk,
	reset_n => reset_n,
	en => en_ir, -- Habilitaci??n carga
	e => ir_in,-- datos
	s =>  ir_out);
	
i3:entity work.Registro ---registro PC_IR
port map(
	clk => clk,
	reset_n => reset_n,
	en => en_ir, -- Habilitaci??n carga
	e => pc_out, -- datos
	s =>  pc_ir);

i3bis:entity work.Registro ---registro AluR
port map(
	clk => clk,
	reset_n => reset_n,
	en => '1', -- Habilitaci??n carga
	e => alu_out, -- datos
	s => alur_out);

	
ir<=(ir_out(14))&(ir_out(12));
i4:entity work.Mul1
port map(
	z  => z,
	lt => lt,
	ge  => ge,
	ir_out => ir,
	salida => s0);

i5: entity work.Mul2
port map(
	e1	=> alu_out,
	e2 => alur_out,
	e3	=>(others =>'0'),
	sel => m_pc,
	s   => pc_in); 

i6:entity work.Mul3
port map(
	e1	=> d_ram_alu,
	e2	=> pc_out,
	e3	=> inm, 
	sel => m_banco,
	s => D_in); --s2
	
i7:entity work.Mul4
port map(
	e1	=> reg_b,
	e2	=> std_logic_vector(to_unsigned(4,32)), 
	e3	=> inm,
	sel => m_alu_b,
	s   => s6);

i8:entity work.Mul5
port map(
	s	=> d_ram_alu,
	e1	=> alu_out,
	e2	=> s4,
	sel => m_ram);

i9:entity work.Mul6
port map(
	s	=> s5,
	e1	=> reg_a,
	e2	=> pc_out,
	e3	=> pc_ir,
	sel => m_alu_a	);

i10:entity work.Mul7
port map(
   s	=> shamt,
	e1	=> reg_b(4 downto 0),
	e2	=> ir_out(24 downto 20),
	sel => m_shamt);
	
i11: entity work.BancoReg
port map(
	clk     => clk,
	reset_n => reset_n,
	AddrA   => ir_out(19 downto 15),
	AddrB   => ir_out(24 downto 20),
	AddrW   => ir_out(11 downto 7),
	D_in    => D_in,
	En      => en_banco,
   RegA    => reg_a,
	RegB    => reg_b);

i12: entity work.Lab4 --ALU
port map(
	a       => s5,--reg_a
	b       => s6,--reg_b
	shamt   => shamt,
	alu_op  => alu_op,
	alu_out => alu_out,
	z       => z,
	lt      => lt,
	ge      => ge);

i13: entity work.InmGen
port map(
	ir_out    => ir_out,
	tipo_inst => tipo_inst,
	mask_b0   => mask_b0,
	inmediato => inm);
	
i14 : entity work.RamGrande
port map(
	Addr => alur_out,
	Din  => reg_b,
	tipo_acc => tipo_acc,
	l_u => l_u,
	we_ram => we_ram,
	Dout => s4,
	clk => clk);
	
i15 : entity work.Rom
port map(
	clk => clk,
   en_pc => en_pc,  --CUIDADO
   addr => pc_in,
   data => ir_in);
	
i16: entity work.MaquinaEstados
port map(
	m_pc=> m_pc,		
	wr_pc =>	wr_pc,	
	m_alu_a =>m_alu_a,	
	m_alu_b	=> m_alu_b,
	alu_op	=>alu_op,
	en_ir		=> en_ir,
	tipo_inst => tipo_inst,
	m_banco	=> m_banco,
	en_banco	=> en_banco,
	wr_pc_cond	=> wr_pc_cond,
	m_shamt => m_shamt,
	m_ram	 => m_ram,	
	we_ram => we_ram,	
	tipo_acc	=> tipo_acc,
	l_u	=>l_u,	
	clk  => clk,
	reset_n	=> reset_n,
	opcode => ir_out(6 downto 2),	
	ir_out => ir_out,	
	mask_b0 => mask_b0 );	

s1 <= s0 and wr_pc_cond;
en_pc <= s1 or wr_pc;
	
	
	
end structural;