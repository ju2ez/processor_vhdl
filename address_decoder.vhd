library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SCA_types.all;

entity address_decoder is
 port(wr, rd: in std_logic;
      addr: in address;
      wr_RAM, rd_RAM: out std_logic;
      wr_LED: out std_logic;
      rd_Switch, rd_Key, rd_Key_edge, wr_Key_edge: out std_logic;
      wr_HEXDisp: out std_logic);
end address_decoder;

architecture table of address_decoder is
 constant MemLowAddr: address:= (others => '0');
 constant MemHighAddr: address := to_unsigned(2**memwidth-1, addrwidth);
 constant LED_Addr: address := to_unsigned(16#10000#, addrwidth);
 constant HEX_Addr: address := to_unsigned(16#10010#, addrwidth);
 constant SWT_Addr: address := to_unsigned(16#10020#, addrwidth);
 constant Key_Addr: address := to_unsigned(16#10030#, addrwidth);
 constant Key_Edge_Addr: address := to_unsigned(16#10031#, addrwidth);
begin
 wr_RAM <= '1' when MemLowAddr <= addr and addr <= MemHighAddr and wr = '1' else '0';
 rd_RAM <= '1' when MemLowAddr <= addr and addr <= MemHighAddr and rd = '1' else '0';
 wr_LED <= '1' when addr = LED_Addr and wr = '1' else '0';
 wr_HEXDisp <= '1' when addr = HEX_Addr and wr = '1' else '0';
 rd_Switch <= '1' when addr = SWT_Addr and rd = '1' else '0';
 rd_key <= '1' when addr = Key_Addr and rd = '1' else '0';
 rd_Key_edge <= '1' when addr = Key_Edge_Addr and rd = '1' else '0';
 wr_Key_edge <= '1' when addr = Key_Edge_Addr and wr = '1' else '0';
end table;