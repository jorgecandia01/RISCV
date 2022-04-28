library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MaquinaEstados is
port(
	m_pc		: out std_logic_vector(1 downto 0);
	wr_pc		: out std_logic;
	m_alu_a	: out std_logic_vector(1 downto 0);
	m_alu_b	: out std_logic_vector(1 downto 0);
	alu_op		: out std_logic_vector(3 downto 0);
	en_ir		: out std_logic;
	tipo_inst	: out std_logic_vector(2 downto 0);
	m_banco	: out std_logic_vector(1 downto 0);
	en_banco	: out std_logic;
	wr_pc_cond	: out std_logic;
	m_shamt	: out std_logic;
	m_ram		: out std_logic;
	we_ram	: out std_logic;
	tipo_acc	: out std_logic_vector(1 downto 0);
	l_u		: out std_logic;
	clk		: in std_logic;
	reset_n	: in std_logic;
	opcode	: in std_logic_vector(4 downto 0);
	ir_out	: in std_logic_vector(31 downto 0);
	mask_b0  : out std_logic);

end MaquinaEstados;

architecture behavioural of MaquinaEstados is

	type t_estados is (Reset, Fetch, Decod, Jal, Jalr, Lui3, Lwsw3, Auipc3, Arit3, SalCond, Ariti3, Lw4, Sw4, Arit4, Ariti4, Lw5); 
	signal estado_act, estado_sig : t_estados;

begin
	VarEstado : process(clk, reset_n)
	begin
	if reset_n = '0' then
		estado_act <= Reset;
	else
		if rising_edge(clk) then
			estado_act <= estado_sig;
		end if;
		end if; 
	end process;


Salidas : process(estado_act)
begin
	--poner todo a cero de default
case estado_act is
	when Reset =>
		m_pc <= "10";
		wr_pc <= '1';
		en_ir <= '0';
		we_ram <= '0';
		en_banco<= '0';

	when Fetch =>
		m_alu_a <= "01";
		m_alu_b <= "01";
		alu_op <= "0000";
		m_pc <= "00";
		wr_pc <= '1';
		en_ir <= '1';
		we_ram <= '0';
		en_banco<= '0';
		wr_pc_cond<= '0';

	when Decod =>
		tipo_inst <= "010";
		m_alu_a <= "10";
		m_alu_b <= "10";
		alu_op <= "0000";
		wr_pc <= '0';
		en_ir <= '0';
		we_ram <= '0';
		en_ir <= '0';
		we_ram <= '0';
		en_banco<= '0';
		
	when Jal =>
		m_banco <= "01";
		wr_pc <= '1';
		en_banco <= '1';
		tipo_inst <= "100";
		m_alu_a <= "10";
		m_alu_b <= "10";
		alu_op <= "0000";
		m_pc <= "00";
		en_ir <= '0';
		we_ram <= '0';

	when Jalr =>
		m_banco <= "01";
		mask_b0 <= '1';
		tipo_inst <= "000";
		m_alu_a <= "00";
		m_alu_b <= "10";
		alu_op <= "0000";
		en_banco<='1';
		wr_pc<= '1';
		en_ir <= '0';
		we_ram <= '0';

	when Lui3 =>
		tipo_inst <= "011";
		m_banco <= "10";
		en_banco <= '1';
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';


	when Lwsw3 =>
		if opcode = "0010011" then 
			tipo_inst <= "000";
		else
			tipo_inst <="001"; 
		end if;
		alu_op <= "0000";
		m_alu_a <= "00";
		m_alu_b <= "10";
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';
		wr_pc_cond<= '0';
		en_banco<= '0';

	when Auipc3 =>
		tipo_inst <= "011";
		alu_op <= "0000";
		m_alu_a <= "10";
		m_alu_b <= "10";
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';
		en_banco<= '0';

	when Arit3 =>
		alu_op <= ir_out(30)&ir_out(14)&ir_out(13)&ir_out(12); --
		m_alu_a <= "00";
		m_alu_b <= "00";
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';
		en_banco<= '0';

	when SalCond =>
		wr_pc_cond <= '1';
		m_pc <= "01";
		m_alu_a <= "00";
		m_alu_b <= "00";
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';
		en_banco<= '0';
		if ir_out(13)='1' then
			alu_op <= "0011";
		else 
			alu_op <= "0010";
		end if;
			

	when Ariti3 =>
		alu_op <= ir_out(30)&ir_out(14)&ir_out(13)&ir_out(12); --
		m_shamt <= '1';
		m_alu_a <= "00";
		m_alu_b <= "10";
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';
		en_banco<= '0';

	when Lw4 =>
		tipo_acc <= ir_out(13)&ir_out(12);
		l_u <= ir_out(14);
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';

	when Sw4 =>
		tipo_acc <=  ir_out(13)&ir_out(12);
		we_ram <= '1';
		en_banco<= '0';

	when Arit4 =>
		m_ram <= '0';
		m_banco <= "00";
		en_banco <= '1';
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';

	when Ariti4 =>
		m_ram <= '0';
		m_banco <= "00";
		en_banco <= '1';
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';


	when Lw5 =>
		l_u <=ir_out(14);
		m_ram <= '1';
		m_banco <= "00";
		en_banco <= '1';
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';

	when others =>
		m_banco <= "00";
		en_banco<= '0';
		en_ir <= '0';
		we_ram <= '0';
		wr_pc<= '0';

end case;
end process;



TransicionEstados : process(estado_act,opcode) 
begin
estado_sig <= estado_act; 

case estado_act is
when Reset =>
	estado_sig <= Fetch;
when Fetch =>
	estado_sig <= Decod;

when Decod =>
	case opcode is
		when "11011" =>
			estado_sig <= Jal;

		when "11001" =>
			estado_sig <= Jalr;

		when "01101" =>
			estado_sig <= Lui3;

		when "0-000" => --mirar esto bien
			estado_sig <= Lwsw3;

		when "00101" =>
			estado_sig <= Auipc3;

		when "01100" =>
			estado_sig <= Arit3;

		when "11000" =>
			estado_sig <= SalCond;

		when "00100" =>
			estado_sig <= Ariti3;

		when "00000" =>
			estado_sig <= lwsw3;
		
		when "01000" =>
			estado_sig <= lwsw3;
			
		when others =>
			estado_sig <= Reset;
		

		

		--when "00101" => --Arit4 no necesita ningun opcode
		--	estado_sig <= Arit4;

		--when "01100" =>
		--	estado_sig <= Arit4;

		--when "00100" =>
		--	estado_sig <= Ariti4;
	
	end case;

when lwsw3 => 
 case opcode  is
	when "00000" => 
		estado_sig<=lw4;
	when "01000" =>
		estado_sig<=sw4;
	when others =>
		estado_sig<=Reset;
	end case;	

when lw4=>
	estado_sig<=lw5;

when auipc3 =>
	estado_sig<=Arit4;
	

when arit3 =>
	estado_sig<=Arit4;	
	
when Ariti3 =>
	estado_sig<=Ariti4;
	
when Jal =>
	estado_sig<=Fetch;
	
when Jalr =>
	estado_sig<=Fetch;
	
when Lui3 =>
	estado_sig<=Fetch;	
	
when SalCond =>
	estado_sig<=Fetch;	
	
when Sw4 =>
	estado_sig<=Fetch;	
	
when Arit4 =>
	estado_sig<=Fetch;	
	
when Ariti4 =>
	estado_sig<=Fetch;	
	
when Lw5 =>
	estado_sig<=Fetch;	

	
	
when others =>
	estado_sig <= Reset;
end case;
end process;

end behavioural;
