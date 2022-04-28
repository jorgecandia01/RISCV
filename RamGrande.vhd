library ieee;
use ieee. std_logic_1164 .all;
use ieee. numeric_std .all;

entity RamGrande is
port(
	Addr :  in std_logic_vector(31 downto 0);
	Din  :  in  std_logic_vector(31 downto 0);
	tipo_acc : in  std_logic_vector(1 downto 0);
	l_u :  in  std_logic;
	we_ram :  in  std_logic;
	Dout :   out std_logic_vector(31 downto 0);
	clk : in std_logic);
end RamGrande;
	
architecture structural of RamGrande is

signal we_b : std_logic_vector(3 downto 0);
signal we_h : std_logic_vector(1 downto 0);
signal we_w : std_logic;
signal d_in_B3 : std_logic_vector(7 downto 0);
signal d_in_B2 : std_logic_vector(7 downto 0);
signal d_in_B1 : std_logic_vector(7 downto 0);
signal b0 : std_logic_vector(7 downto 0);
signal b1 : std_logic_vector(7 downto 0);
signal b2 : std_logic_vector(7 downto 0);
signal b3 : std_logic_vector(7 downto 0);
signal MuxByte_salida  : std_logic_vector(7 downto 0);
signal MuxMedia_salida : std_logic_vector(15 downto 0);
signal MuxByte_salida_SigExt : std_logic_vector(31 downto 0);
signal MuxMedia_salida_SigExt : std_logic_vector(31 downto 0);
signal Out_we_b : std_logic;
signal Out_we_h : std_logic;
signal Deco2a3_s : std_logic_vector(2 downto 0);
signal En : std_logic;
signal intermedia24 : std_logic_vector(23 downto 0);
signal intermedia16 : std_logic_vector(15 downto 0);
signal Deco2a3_s_int: std_logic_vector(2 downto 0);
signal we_1 : std_logic;
signal we_2 : std_logic; 
signal we_3 : std_logic; 
signal we_4 : std_logic; 

begin

with tipo_acc select
	d_in_B3<= Din(7 downto 0) when "00",
	       Din(15 downto 8) when "01",
			 Din(15 downto 8) when "10",
			 "00000000" when others;

with tipo_acc select 
	d_in_B2 <= Din(7 downto 0) when "00",
					Din(7 downto 0) when "01",
	           Din(23 downto 16) when "10",
				  "00000000" when others;

with tipo_acc select
	d_in_B1<= Din(7 downto 0) when "00",
				 Din(15 downto 8) when "01",
				 Din(31 downto 24) when "10",
				  "00000000" when others;

with Addr(1 downto 0) select
	MuxByte_salida<= b0 when "00",
						  b1 when "01",
						  b2 when "10",
						  b3 when "11",
			    "00000000" when others;

with Addr(1) select 
	MuxMedia_salida <=b1&b0 when '0',
					      b3&b2 when '1',
							"0000000000000000" when others;

intermedia24 <= (others => l_u);
intermedia16 <= (others => l_u);
MuxByte_salida_SigExt<=intermedia24&MuxByte_salida;
MuxMedia_salida_SigExt<=intermedia16&MuxMedia_salida;
				 
with tipo_acc select
	Dout <= MuxByte_salida_SigExt when "00",
			  MuxMedia_salida_SigExt when "01",
			  b3&b2&b1&b0 when "10",
			  "00000000000000000000000000000000" when others;
			  
with Addr(1 downto 0) select 
	Out_we_b <= we_b(0) when "00",
					we_b(1) when "01",
					we_b(2) when "10",
					we_b(3) when "11",
					'0' when others;

with Addr(1) select 
	Out_we_h<=we_h(0) when '0',
				 we_h(1) when '1',
				 '0' when others;

we_b(0)<= Deco2a3_s(0) when Addr(1 downto 0) ="00" else '0';
we_b(1)<= Deco2a3_s(0) when Addr(1 downto 0) ="01" else '0';
we_b(2)<= Deco2a3_s(0) when Addr(1 downto 0) ="10" else '0';
we_b(3)<= Deco2a3_s(0) when Addr(1 downto 0) ="11" else '0';

we_h(0)<=Deco2a3_s(1) when Addr(1)='0' else '0';
we_h(1)<=Deco2a3_s(1) when Addr(1)='1' else '0';

we_w<=Deco2a3_s(2);


--		with tipo_acc select 
	--		Deco2a3_s_int<= "001"  when "00",
		--					"010"  when "01",
			--				"001"  when "10",
				--			"000"  when others;
				
		with tipo_acc select 
			Deco2a3_s_int<= "001"  when "00",
							"010"  when "01",
							"100"  when "10",
							"000"  when others;

--Deco2a3_s <= Deco2a3_s_int when En='1' else (others => '0');
Deco2a3_s <= Deco2a3_s_int when we_ram='1' else (others => '0');

we_1<=we_b(0) or we_h(0) or we_w;	
we_2<=we_b(1) or we_h(0) or we_w;	
we_3<=we_b(2) or we_h(1) or we_w;
we_4<=we_b(3) or we_h(1) or we_w;


i1: entity work.Ram  -- La de arriba
port map(
	clk => clk,
	d_in=> Din(7 downto 0),
	Addr => Addr(11 downto 2), 
	we => we_1 ,
	d_out   => b0);

i2: entity work.Ram  --RAM B3
port map(
	clk => clk,
	d_in =>d_in_B3,
	Addr => Addr(11 downto 2), 
	we => we_2,-- Write enable
	d_out=> b1);

i3: entity work.Ram  --RAM B2
port map(
	clk => clk,
	d_in => d_in_B2,
	Addr => Addr(11 downto 2), 
	we =>we_3, -- Write enable
	d_out=>b2);

i4: entity work.Ram  --RAM B1
port map(
	clk => clk,
	d_in => d_in_B1,
	Addr => Addr(11 downto 2), 
	we =>we_4, -- Write enable
	d_out=>b3);



end structural;
