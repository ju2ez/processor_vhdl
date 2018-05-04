library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SCA_types.all;


entity top_SCA_DE0 is
  -- names of DE0 inputs/outputs
    Port ( CLOCK_50 : in std_logic;			-- the system clock of DE2
           BUTTON : in std_logic_vector(2 downto 0);
           SW : in std_logic_vector(9 downto 0);
           HEX3_D, HEX2_D, HEX1_D, HEX0_D : out std_logic_vector(0 to 7);
           LEDG: out std_logic_vector(9 downto 0)
           );
end top_SCA_DE0;

architecture struct of top_SCA_DE0 is
 component SCA is
 port(clk, reset: in std_logic;
      led_Out: out std_logic_vector(ledfieldsize-1 downto 0);
      hex_Out0, hex_Out1, hex_Out2, hex_Out3: out std_logic_vector(0 to 7);
      key_In: in std_logic_vector(keyfieldsize-1 downto 0);
      switches_In: in std_logic_vector(switchfieldsize-1 downto 0)
      -- test
      ; ac_test, ir_test: out word
      ; addr_test: out natural range 0 to memsize-1
      ; pc_test: out address
      -- test end
      );    
 end component;
 signal ac_test, ir_test: word;
 signal addr_test: natural range 0 to memsize-1;
 signal pc_test: address;
 signal reset: std_logic;
 signal clock: std_logic;
 signal ledSCA: std_logic_vector(ledfieldsize-1 downto 0);
begin
 reset <= not button(0);
 -- clock generation
 process(CLOCK_50, reset, SW(9)) is
  constant delay: natural := 5000000; -- delay leads to 50 MHz/5000000 = 10 Hz
  variable cnt: natural range 0 to delay := 0;
 begin
  if reset = '1' then
   cnt := delay/2;
  elsif rising_edge(CLOCK_50) and SW(9) = '1' then
   if cnt < delay-1 then
    cnt := cnt + 1;
   else cnt := 0;
   end if;
  end if;
  if SW(9) = '1' then 
   if cnt = 0 then
    clock <= '1';
   else
    clock <= '0';
   end if;
  else
   clock <= CLOCK_50;
  end if;  
 end process;
 
 -- mux to change LEDs
 LEDG <= ledSCA when SW(8) = '0' and SW(7) = '0' else
         std_logic_vector(pc_test(ledfieldsize-1 downto 0)) when SW(8) = '1' and SW(7) = '0' else
         std_logic_vector(to_unsigned(addr_test, ledfieldsize)) when SW(8) = '0' and SW(7) = '1' else
         std_logic_vector(ir_test(wordwidth-1 downto wordwidth-4)&ir_test(ledfieldsize-5 downto 0));
 mySCA: sca 
  port map(
   CLOCK, reset,
   LEDSCA, 
   HEX0_D, HEX1_D, HEX2_D, HEX3_D,
   BUTTON,
   SW,
   ac_test, ir_test,
   addr_test,
   pc_test);
end struct;
            
 
 
 
 
 
 
 
 
 
 