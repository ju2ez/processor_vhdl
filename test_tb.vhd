LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.SCA_types.all;

ENTITY test_tb IS 
END test_tb;

ARCHITECTURE behavior OF test_tb IS

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
end component SCA;




   signal clk : std_logic := '0';
	signal reset : std_logic := '0';
   signal key_In: std_logic_vector(keyfieldsize-1 downto 0) := (others =>'0');
   signal switches_In: std_logic_vector(switchfieldsize-1 downto 0) := (others =>'0');
   constant clk_period : time := 10 ns;

BEGIN

   pm_sca: SCA PORT MAP (clk => clk, reset=>reset, key_In=>key_In, switches_In=>switches_In);       

   -- Clock process definitions( clock with 50% duty cycle is generated here.
   clk_process :process
   begin
	while (1=1) loop
        clk <= not clk;
		  wait for clk_period/2;
		  end loop;
		  
		  wait;
		  
   end process;

END;