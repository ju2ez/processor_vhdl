library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.convdisp7.all;
use work.SCA_types.all;

entity HEX_IO is
 port(reset, clk, wr: in std_logic;
      dIn: in word;
      dOut0, dOut1, dOut2, dOut3: out std_logic_vector(0 to 7));
end HEX_IO;




architecture registered of HEX_IO is

signal hexTest : std_logic_vector(3 downto 0);

begin
 process(reset, clk, wr, dIn) is
  variable reg: std_logic_vector(15 downto 0);
 begin
  if reset = '1' then
   reg := (others => '0');
  elsif rising_edge(clk) and wr = '1' then
   reg := std_logic_vector(dIn(15 downto 0));
  end if;
  dOut0 <= bcd2segm7(reg(3 downto 0));
  dOut1 <= bcd2segm7(reg(7 downto 4));
  dOut2 <= bcd2segm7(reg(11 downto 8));
  dOut3 <= bcd2segm7(reg(15 downto 12));


 
 
 end process;
end registered;
    
