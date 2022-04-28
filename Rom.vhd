-- ROM file for the ICAI-RISC-V processor.
-- Generated from the hex file:  ROM.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
  port(
    clk: in std_logic;                         -- Synchronous ROM
    en_pc: in std_logic;                       -- Whith enable
    addr: in  std_logic_vector(31 downto 0);   -- Address bus
    data: out std_logic_vector(31 downto 0) ); -- Data out
end ROM;

architecture Behavioural of ROM is
  -- The internal address is word address, no byte address
  signal internal_addr : std_logic_vector(29 downto 0);

  -- ROM declaration
 type mem_t is array (0 to 16 ) of std_logic_vector(31 downto 0);
  signal memory : mem_t:= (
     0  => X"00200293",
     1  => X"00200313",
     2  => X"007302b3",
     3  => X"00400313",
     4  => X"00531063",
     5  => X"00602023",
     6  => X"00002383",
     7  => X"00539063",
     8  => X"00300e13",
     9  => X"01c00eb3",
     10  => X"00c000ef",
     11  => X"1ca1bf37",
     12  => X"0000006f",
     13  => X"00200293",
     14  => X"00008067",
     others => X"00000000");
begin

  internal_addr <= addr(31 downto 2);

  mem_rom: process(clk)
  begin
    if clk'event and clk = '1' then
      if en_pc = '1' then
        data <= memory(to_integer(unsigned(internal_addr)));
      end if;
    end if;
  end process mem_rom;
end architecture Behavioural;