-- toy_XFSA

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SCA_types.all;

entity TOY_XFSA is
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
        ;ac_out, ir_out: out word
        ;pc_out: out address
    );
end TOY_XFSA;

architecture BEHAVE of TOY_XFSA is
   signal ALUFUNC: word;
   signal S_AC, S_IR: word;
   signal opc: std_logic_vector(3 downto 0);
   signal opr: address;
begin
    ac_out <= S_AC;
    ir_out <= S_IR;
	opc <= decode_opc(S_IR);
	opr <= decode_opr(S_IR);
    ALUFUNC <= alu_func(DBus_In, S_AC, opc);
    process(RESET, CLK, DBUS_IN, ALUFUNC, OPC, OPR) is
        -- DEFINE A STATE-TYPE
        type TSTATE is(
            BOOT,            -- 
            FETCH_1,         -- 
            FETCH_2,         -- 
			Fetch_3,
            STORE_1,         -- 
            STORE_2,         -- 
            EXEC_LD_ARITH_1, -- 
            EXEC_LD_ARITH_2, -- 
            EXEC_LD_ARITH_3, -- 
            EXEC_JMPZ_1,     -- 
            EXEC_AC_OP       -- 
        );
        variable STATE : TSTATE;
        -- VARIABLES
        variable AC : word;                 -- x
        variable PC : address;               -- x
        variable IR : word;                 -- x
    begin
        if RESET='1' then
            STATE := BOOT;
            PC := to_unsigned(0, 32); -- variable assignment
            AC := to_signed(0, 32); -- variable assignment
        elsif CLK'event and CLK='1' then
            -- STATE-TRANSITION-FUNCTION
            case STATE is
                when BOOT =>
                    if(true) then
                        STATE := FETCH_1;
                    end if;
                when FETCH_1 =>
                    STATE := FETCH_2;
                when FETCH_2 =>
                    IR := DBUS_IN; -- variable assignment
                    PC := PC + 1; -- variable assignment
					state := Fetch_3;
				when Fetch_3 =>
                    if(OPC="0000") then
                        STATE := STORE_1;
                    elsif( (OPC="0001")  or  (OPC="0011")  or  (OPC="0100")  or  (OPC="0101")  or  (OPC="0110")  or  (OPC="0111") ) then
                        STATE := EXEC_LD_ARITH_1;
                    elsif( (OPC="0010")  and  (AC=0) ) then
                        STATE := EXEC_JMPZ_1;
					elsif (OPC="0010") and (AC/= 0) then
						STATE := FETCH_1;
                    elsif( (OPC="1000")  or  (OPC="1001")  or  (OPC="1010")  or  (OPC="1011") ) then
                        STATE := EXEC_AC_OP;
					else
						state := FETCH_1;
                    end if;
                when STORE_1 =>
                    if(true) then
                        STATE := STORE_2;
                    end if;
                when STORE_2 =>
                    if(true) then
                        STATE := FETCH_1;
                    end if;
                when EXEC_LD_ARITH_1 =>
                    if(true) then
                        STATE := EXEC_LD_ARITH_2;
                    end if;
                when EXEC_LD_ARITH_2 =>
                    if(true) then
                        STATE := EXEC_LD_ARITH_3;
                    end if;
                when EXEC_LD_ARITH_3 =>
                    AC := ALUFUNC; -- variable assignment
                    if(true) then
                        STATE := FETCH_1;
                    end if;
                when EXEC_JMPZ_1 =>
                    PC := OPR; -- variable assignment
                    if(true) then
                        STATE := FETCH_1;
                    end if;
                when EXEC_AC_OP =>
                    AC := ALUFUNC; -- variable assignment
                    if(true) then
                        STATE := FETCH_2;
                    end if;
                when others =>
                    STATE := BOOT;
            end case;
        end if;
        -- OUTPUT-FUNCTION
        case STATE is
                when BOOT =>
                    DBUS_OUT <= to_signed(0,32);
                    ABUS     <= to_unsigned(0,32);
                    MEM_RD   <= '0';
                    MEM_WR   <= '0';
                when FETCH_1 =>
                    DBUS_OUT <= to_signed(0,32);
                    ABUS     <= PC;
                    MEM_RD   <= '1';
                    MEM_WR   <= '0';
                when FETCH_2 =>
                    DBUS_OUT <= to_signed(0,32);
                    ABUS     <= PC;
                    MEM_RD   <= '0';
                    MEM_WR   <= '0';
				when Fetch_3 =>
                    DBUS_OUT <= to_signed(0,32);
                    ABUS     <= PC;
                    MEM_RD   <= '0';
                    MEM_WR   <= '0';			
                when STORE_1 =>
                    DBUS_OUT <= AC;
                    ABUS     <= OPR;
                    MEM_RD   <= '0';
                    MEM_WR   <= '0';
                when STORE_2 =>
                    DBUS_OUT <= AC;
                    ABUS     <= OPR;
                    MEM_RD   <= '0';
                    MEM_WR   <= '1';
                when EXEC_LD_ARITH_1 =>
                    DBUS_OUT <= to_signed(0,32);
                    ABUS     <= OPR;
                    MEM_RD   <= '1';
                    MEM_WR   <= '0';
                when EXEC_LD_ARITH_2 =>
                    DBUS_OUT <= to_signed(0,32);
                    ABUS     <= OPR;
                    MEM_RD   <= '1';
                    MEM_WR   <= '0';
                when EXEC_LD_ARITH_3 =>
                    DBUS_OUT <= to_signed(0,32);
                    ABUS     <= OPR;
                    MEM_RD   <= '0';
                    MEM_WR   <= '0';
                when EXEC_JMPZ_1 =>
                    DBUS_OUT <= to_signed(0,32);
                    ABUS     <= to_unsigned(0,32);
                    MEM_RD   <= '0';
                    MEM_WR   <= '0';
                when EXEC_AC_OP =>
                    DBUS_OUT <= to_signed(0,32);
                    ABUS     <= PC;
                    MEM_RD   <= '1';
                    MEM_WR   <= '0';
            end case;
		pc_out <= pc;
		S_AC <= AC;
		S_IR <= IR;
    end process;

end BEHAVE;
