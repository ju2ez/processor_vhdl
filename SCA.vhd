-- Top level entity SCA

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SCA_types.all;
use work.convDisp7.all;

entity SCA is
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
end SCA;

architecture struct of SCA is
 component processor is
    port
    (
        CLK      : in    std_logic;                           -- clock
        RESET    : in    std_logic;                           -- reset
        DBUS_IN  : in    word;                 -- x
        DBUS_OUT : out   word;                 -- x
        ABUS     : out   address;                 -- x
        MEM_RD   : out   std_logic;                           -- x
        MEM_WR   : out   std_logic                            -- x
        -- test
     --   ;ac_out, ir_out: out word
      --  ;pc_out: out address
    );
 end component;
 component memory is
 port(clk, reset: in std_logic;
      rd, wr: in std_logic;
      addr: in address;
      dataIn: in word;
      dataOut: out word
      -- test
      ;addr2mem: out natural range 0 to memsize-1 -- memory address      
      );
 end component;
 component dBus2Pcr_MUX is
  port(clk, reset: in std_logic;
       rd_Mem, rd_Switch, rd_Key, rd_Key_edge: in std_logic;
       mem_Val, switch_Val, key_Val: in word;
       proc_dbus_In: out word);
 end component;
 component address_decoder is
 port(wr, rd: in std_logic;
      addr: in address;
      wr_RAM, rd_RAM: out std_logic;
      wr_LED: out std_logic;
      rd_Switch, rd_Key, rd_Key_edge, wr_Key_edge: out std_logic;
      wr_HEXDisp: out std_logic);
 end component;
 component LED_IO is
 port(reset, clk, wr: in std_logic;
      dIn: in word;
      dOut: out std_logic_vector(ledfieldsize-1 downto 0));
 end component;
 component HEX_IO is
 port(reset, clk, wr: in std_logic;
      dIn: in word;
      dOut0, dOut1, dOut2, dOut3: out std_logic_vector(0 to 7));
 end component;
 component Key_IO is
 port(clk, reset, rd_key, rd_key_edge, wr: in std_logic;
      dIn: in word;
      dOut: out word;
      keyPins: in std_logic_vector(keyfieldsize-1 downto 0));
 end component;
 signal dbus_In_Pcr, dBus_out_mem, dBus_out_keys, dBus_out_Switches: word;
 signal dbus_Out_Pcr: word;
 signal aBus: address;
 signal rd_Pcr, wr_Pcr, rd_keys, rd_keys_edge, wr_keys_edge,
        rd_switch, rd_mem, wr_mem, wr_LED, wr_HEX: std_logic;
begin
 prc: processor
  port map (clk, reset, dbus_In_Pcr, dbus_Out_Pcr, aBus, rd_Pcr, wr_Pcr
            );--ac_test); --ir_test, pc_test);
 mem: memory
  port map (clk, reset,
      rd_mem, wr_mem,
      aBus,
      dbus_Out_Pcr,
      dbus_Out_Mem
      -- test
      ,addr_test );
 addrDec: address_decoder
  port map(wr => wr_Pcr, rd => rd_Pcr,
      addr => aBus,
      wr_RAM => wr_mem,
      rd_RAM => rd_mem,
      wr_LED => wr_LED,
      rd_Switch => rd_Switch, 
      rd_Key => rd_Keys, 
      rd_Key_edge => rd_Keys_edge,
      wr_Key_edge => wr_keys_edge,
      wr_HEXDisp => wr_HEX);
 dBusMux: dBus2Pcr_MUX
  port map(clk, reset,
       rd_Mem, rd_Switch, rd_Keys, rd_Keys_edge,
       mem_Val => dbus_Out_Mem, 
       switch_Val => DBus_out_Switches, 
       key_Val => dBus_out_Keys, 
       proc_dbus_In => Dbus_In_Pcr);
 Leds: LED_IO
  port map(reset => reset, 
      clk => clk,
      wr => wr_LED,
      dIn => DBus_Out_Pcr,
      dOut => led_Out);
 HexDisp: HEX_IO
  port map(reset => reset, 
      clk => clk,
      wr => wr_HEX,
      dIn => DBus_Out_Pcr,
      dOut0 => hex_Out0, 
      dOut1 => hex_Out1, 
      dOut2 => hex_Out2, 
      dOut3 => hex_Out3);
 keys: key_IO
  port map(clk => clk, 
      reset => reset, 
      rd_key => rd_Keys, 
      rd_key_edge => rd_Keys_edge,
      wr => wr_keys_edge,
      dIn => DBus_Out_Pcr,
      dOut => DBus_out_keys,
      keyPins => key_In);
 DBus_out_Switches <= signed((wordwidth -1 downto switchfieldsize => '0') & switches_In);-- switches are directly connected
end struct;