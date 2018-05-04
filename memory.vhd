-- memory wrapper
-- changed to synthesizable memory megafunction

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SCA_types.all;

entity memory is
 port(clk, reset: in std_logic;
      rd, wr: in std_logic;
      addr: in address;
      dataIn: in word;
      dataOut: out word
      -- test
      ;addr2mem: out natural range 0 to memsize-1 -- memory address      
      );
end memory;
architecture behv of memory is
-- component single_port_ram_with_init is
--  
--  port 
--  (
--    clk   : in std_logic;
--    addr  : in natural range 0 to MEMSIZE - 1;
--    data  : in std_logic_vector((WORDWIDTH-1) downto 0);
--    we    : in std_logic := '1';
--    q   : out std_logic_vector((WORDWIDTH -1) downto 0)
--  );
 component single_port_ram_mega_function is
-- GENERIC (LPM_FILE: string);
 PORT
	(
		address		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
 end component;  
 signal s_addr: std_LOGIC_VECTOR(memwidth-1 downto 0);
 signal s_dataIn, s_dataOut: std_logic_vector(wordwidth-1 downto 0);
begin

 -- the memory as defined by Altera
 sprwi: single_port_ram_mega_function
 --GENERIC MAP (LPM_FILE=>"SCAMIF.mif")
 
  port map(s_addr, clk, s_dataIn, wr, s_dataOut);
 -- the address register
-- process(reset, clk, rd) is -- latch for read address
-- begin
--  if reset = '1' then
--   s_addr <= 0;
--  elsif rising_edge(clk) then
--   if rd = '1' then
--    s_addr <= to_integer(addr);
--   end if;
--  end if;
-- end process;
 -- address is latched in memory module of Altera. Here only avoid that address is too big
 s_addr <= std_LOGIC_VECTOR(addr(memwidth-1 downto 0)); 
 s_dataIn <= std_logic_vector(dataIn);
 dataOut <= signed(s_dataOut);
 addr2mem <= to_integer(unsigned(s_addr));
end behv;