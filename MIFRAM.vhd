-- Quartus II VHDL Template
-- Single-port RAM with single read/write address and initial contents  
-- adapted to toy by G. Hartung 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;

library work;
use work.SCA_types.all;

entity MIFRAM is

  port 
  (
    clk   : in std_logic;
    addr  : in natural range 0 to MEMSIZE - 1;
    data  : in std_logic_vector((WORDWIDTH-1) downto 0);
    we    : in std_logic := '1';
    q   : out std_logic_vector((WORDWIDTH -1) downto 0)
  );

end MIFRAM;

architecture rtl of MIFRAM is

  -- Build a 2-D array type for the RAM
  type memory_t is array(MEMSIZE-1 downto 0) of std_logic_vector(WORDWIDTH-1 downto 0);

	signal ram: memory_t;
	attribute ram_init_file: string;
	attribute ram_init_file of ram: signal is "SCAMIF.mif";
  
  
   


  
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

