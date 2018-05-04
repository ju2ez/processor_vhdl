library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SCA_types.all;

entity LED_IO is
 port(reset, clk, wr: in std_logic;
      dIn: in word;
      dOut: out std_logic_vector(LEDfieldsize-1 downto 0));
end LED_IO;

architecture reg of LED_IO is
begin
 process(wr, dIn, clk, reset) is
 begin
  if reset = '1' then
   dOut <= std_logic_vector(to_unsigned(0, LEDfieldsize));
  elsif rising_edge(clk) and (wr = '1') then
   dOut <= std_logic_vector(dIn(LEDfieldsize-1 downto 0));
  end if;
 end process;
end reg;