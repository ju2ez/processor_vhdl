library ieee;
use ieee.std_logic_1164.all;

package convdisp7	is
subtype std_logic_vector8 is std_logic_vector(0 to 7);
function bcd2segm7(d: std_logic_vector(3 downto 0)) return std_logic_vector8;
end package convdisp7;

package body convdisp7 is
	function bcd2segm7(d: std_logic_vector(3 downto 0)) return std_logic_vector8 is
		variable q:std_logic_vector (0 to 7);
	begin
		case d is
		when "0000" => q := "00000011";
		when "0001"	=> q := "10011111";
		when "0010"	=> q := "00100101";
		when "0011"	=> q := "00001101";
		when "0100"	=> q := "10011001";
		when "0101"	=> q := "01001001";
		when "0110"	=> q := "01000001";
		when "0111"	=> q := "00011111";
		when "1000"	=> q := "00000001";
		when "1001"	=> q := "00011001";
		when "1010"	=> q := "00010001";
		when "1011"	=> q := "11000001";
		when "1100"	=> q := "01100011";
		when "1101"	=> q := "10000101";
		when "1110"	=> q := "01100001";
		when "1111"	=> q := "01110001";
		when others => q := "11111111";
		end case;
		return q;
	end function;
end package body convdisp7;