library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InmGen is
port(
	ir_out      :  in std_logic_vector(31 downto 0);
	tipo_inst   :   in std_logic_vector(2 downto 0); 
	mask_b0     :   in std_logic;
	inmediato   : out std_logic_vector(31 downto 0));
end InmGen;
	
architecture behavioural of InmGen is
	signal inm_sin_mask : std_logic;
	subtype tipo_inst_t is std_logic_vector (2 downto 0);
	constant TYPE_I : tipo_inst_t := "000";
	constant TYPE_S : tipo_inst_t := "001";
	constant TYPE_B : tipo_inst_t := "010";
	constant TYPE_U : tipo_inst_t := "011";
	constant TYPE_J : tipo_inst_t := "100";

begin
	inm_sin_mask <= ir_out (20) when tipo_inst = TYPE_I else
						 ir_out (7) when tipo_inst = TYPE_S else
						'0';
	
	inmediato (0) <= inm_sin_mask and not(mask_b0);

	inmediato (4 downto 1) <= ir_out (24 downto 21) when tipo_inst = TYPE_I or tipo_inst = TYPE_J else
								  ir_out (11 downto 8) when tipo_inst = TYPE_S or tipo_inst = TYPE_B else
								  "0000";
								  
	inmediato(10 downto 5)  <= ir_out(30 downto 25) when tipo_inst = TYPE_I or tipo_inst = TYPE_S or tipo_inst = TYPE_B or tipo_inst = TYPE_J else  
	                         "000000";
   inmediato(11)  <= ir_out(7) when tipo_inst =  TYPE_B else
	                  ir_out(20) when tipo_inst =  TYPE_J else
							'0';
	inmediato(19 downto 12) <= ir_out(19 downto 12)  when tipo_inst = TYPE_J or tipo_inst = TYPE_U else
	                          (others => ir_out(31));
									  
	inmediato(30 downto 20) <= ir_out(30 downto 20) when tipo_inst =  TYPE_U else
										 (others => ir_out(31));

	inmediato(31) <= ir_out(31);
										 
end behavioural;