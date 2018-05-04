-- dataBus2Processor
-- switches databus source which is Data_In in processor according to address decoder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SCA_types.all;

entity dBus2Pcr_MUX is
  port(clk, reset: in std_logic;
       rd_Mem, rd_Switch, rd_Key, rd_Key_edge: in std_logic;
       mem_Val, switch_Val, key_Val: in word;
       proc_dbus_In: out word);
end dBus2Pcr_MUX;

architecture buffered of dBus2Pcr_MUX is
begin
  -- the mux is triggered: with a read the data bus is switched.
  process(clk, reset, rd_Mem, rd_Switch, rd_Key, rd_Key_edge, 
          mem_Val, switch_Val, key_Val)         is
   type tstateMux is (mem2Pcr, switch2Pcr, key2Pcr);
   variable state: tstateMux; 
   begin
    if reset = '1' then
     state := mem2Pcr;
    else -- no need to synchronize here with clk. The state is simply changed with a new read
     if rd_Mem = '1' then
      state := mem2Pcr; 
     elsif rd_Switch = '1' then
      state := switch2Pcr;
     elsif rd_Key = '1' or rd_Key_edge = '1' then
      state := key2Pcr;
     end if;
    end if;
    case state is
	when mem2Pcr => proc_dbus_In <= mem_Val;
	when switch2Pcr => proc_dbus_In <= switch_Val;
	when key2Pcr => proc_dbus_In <= key_Val;
    end case;
  end process;
end buffered;