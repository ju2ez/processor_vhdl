library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SCA_types.all;

entity Key_IO is
 port(clk, reset, rd_key, rd_key_edge, wr: in std_logic;
      dIn: in word;
      dOut: out word;
      keyPins: in std_logic_vector(keyfieldsize-1 downto 0));
end Key_IO;

architecture reg of key_IO is
 signal keys, key_edge_reg: std_logic_vector(keyfieldsize-1 downto 0);
begin
 -- key edge register is set with pressed key and resetted with writing an '1'
 -- key press gives a '0' on key pin
 
 -- register key_edge_reg
 process(clk, reset, keyPins, dIn) is
  type keyState_t is (released,    -- key not pressed
                      newPressed,  -- key pressed, not keyEdge resetted
                      oldPressed); -- key pressed, keyEdge resetted
  type keyStates_t is array (keyfieldsize-1 downto 0) of keyState_t;
  variable keyState: keyStates_t;
 begin
  if reset = '1' then
   for i in 0 to keyfieldsize-1 loop
    keyState(i) := released;
   end loop;
  elsif rising_edge(clk) then
   if wr = '1' then -- clear flag if dIn(i) = '1'
    for i in 0 to keyfieldsize-1 loop
     if dIn(i) = '1' and (keyState(i) = newPressed) then
      keyState(i) := oldPressed;
     end if;
    end loop;
   else -- update keystate
    for i in 0 to keyfieldsize-1 loop
     if keyPins(i) = '1' and keyState(i) = oldPressed then
       keyState(i) := released;
     elsif keyPins(i) = '0' and keyState(i) = released then
      keyState(i) := newPressed;
     end if;
    end loop;
   end if;
  end if;
  -- set key_edge register according to key state
  for i in 0 to keyfieldsize -1 loop
   if keyState(i) = newPressed then
    key_edge_reg(i) <= '1'; 
   else
    key_edge_reg(i) <= '0';
   end if;
  end loop;
 end process;
 -- databus output latch
 process(reset, rd_key, rd_key_edge) is
 begin
  if reset = '1' then
   dOut(keyfieldsize-1 downto 0) <= signed(keyPins);
  elsif rd_key = '1' then
   dOut(keyfieldsize-1 downto 0) <= signed(keyPins);
  elsif rd_key_edge = '1' then
   dOut(keyfieldsize-1 downto 0) <= signed(key_edge_reg);
  end if;
 end process;
 dOut(wordwidth-1 downto keyfieldsize) <= (others => '0');
end reg;
