-- Quartus II VHDL Template
-- Single-port RAM with single read/write address and initial contents  
-- adapted to toy by G. Hartung 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

library work;
use work.SCA_types.all;

entity single_port_ram_with_init is

  port 
  (
    clk   : in std_logic;
    addr  : in natural range 0 to MEMSIZE - 1;
    data  : in std_logic_vector((WORDWIDTH-1) downto 0);
    we    : in std_logic := '1';
    q   : out std_logic_vector((WORDWIDTH -1) downto 0)
  );

end single_port_ram_with_init;

architecture rtl of single_port_ram_with_init is

  -- Build a 2-D array type for the RAM
  type memory_t is array(MEMSIZE-1 downto 0) of std_logic_vector(WORDWIDTH-1 downto 0);

  function init_ram
    return memory_t is 
    variable tmp : memory_t := (others => (others => '0'));
      variable l1: line;
		  variable Bv: bit_vector(wordwidth-1 downto 0);
      variable adr: integer := 0;
      FILE PROG: text open read_mode is "prog.txt"; -- Program in File "prog.txt"  
  begin
    for addr_pos in 0 to MEMSIZE - 1 loop 
      if (not endfile(PROG)) then
        readline(PROG, l1);         -- read a line
        read(l1,Bv);
				tmp(addr_pos) := to_stdlogicvector(BV);          -- and convert to std_logic_vector
      else
        -- Initialize each address with the address itself
        tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, WORDWIDTH));
      end if;
    end loop;
    return tmp;
  end init_ram;  

  -- Declare the RAM signal and specify a default value.  Quartus II
  -- will create a memory initialization file (.mif) based on the 
  -- default value.
  signal ram : memory_t := init_ram;
  -- Register to hold the address 
  signal addr_reg : natural range 0 to MEMSIZE-1;

begin

  process(clk)
  begin
  if(rising_edge(clk)) then
    if(we = '1') then
      ram(addr) <= data;
    end if;

    -- Register the address for reading
    addr_reg <= addr;
  end if;
  end process;

  q <= ram(addr_reg);

end rtl;

