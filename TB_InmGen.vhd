library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_InmGen is 
end TB_InmGen;

architecture structural of TB_InmGen is

signal ir_out          :  std_logic_vector(31 downto 0);
signal tipo_inst       :  std_logic_vector(2 downto 0); 
signal mask_b0         :  std_logic;
signal inmediato       :  std_logic_vector(31 downto 0);

subtype tipo_inst_t is std_logic_vector (2 downto 0);
constant TYPE_I : tipo_inst_t := "000";
constant TYPE_S : tipo_inst_t := "001";
constant TYPE_B : tipo_inst_t := "010";
constant TYPE_U : tipo_inst_t := "011";
constant TYPE_J : tipo_inst_t := "100";

begin


 
i1 : entity work.InmGen
port map(
	ir_out    => ir_out,
	tipo_inst => tipo_inst,
	mask_b0   => mask_b0,
	inmediato => inmediato);

always :process 

begin 
---
mask_b0<='0';

tipo_inst <= TYPE_I ;
wait for 100 ns;

ir_out<="00000000110100000000000000000000";
--inmediato<="000000000000000000001101"
wait for 100 ns;

assert inmediato="00000000000000000000000000001101" --NO ENTENDEMOS POR QUÉ NO VA
	report "Fallo en la simulación"
		severity failure;

---
tipo_inst <= TYPE_J ;
mask_b0<='1';
wait for 100 ns;

ir_out <="00000000110000000000000000000000";
wait for 100 ns;

assert inmediato="00000000000000000000000000001100"
	report "Fallo en la simulación"
		severity failure;
		
---

tipo_inst<=TYPE_S;
mask_b0<='0';
wait for 100 ns;
ir_out<="00000000000000000000011010000000";
wait for 100 ns;

assert inmediato="00000000000000000000000000001101"
	report "Fallo en la simulación"
		severity failure;
---
tipo_inst<=TYPE_B;
wait for 100 ns;
ir_out<="00000000000000000000011000000000";
wait for 100 ns;

assert inmediato="00000000000000000000000000001100"
	report "Fallo en la simulación"
		severity failure;
---

tipo_inst<=TYPE_U;
wait for 100 ns;
ir_out<="00000000000000000000000000000000";
wait for 100 ns;

assert inmediato="00000000000000000000000000000000"
	report "Fallo en la simulación"
		severity failure;
--
wait for 100 ns;

assert false
report "Fin"
severity Failure;

end process always;
end structural ;