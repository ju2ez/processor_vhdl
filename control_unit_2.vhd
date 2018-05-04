library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--use work.types.all;
use work.SCA_types.all;


  
entity control_unit_2 is

 Port(
	-- inputs -- 
	 clk: in std_ulogic; 		-- system clock
    instruction_in : in std_logic_vector(4 downto 0);		-- 5 Bit instruction
	 spx_pcx_in : in std_logic_vector (1 downto 0);			-- 2 Bit pcX / spX / rb0 / rb1
	 absolute_in : in word ;		-- see for example ISA : store command		
--	 arith_in : in std_logic_vector (12 downto 0 );			-- see for example ISA : ADDA command
	 alu_in1 : in std_logic_vector (3 downto 0);			
	 alu_in2 : in std_logic_vector (3 downto 0);
	 alu_out : in std_logic_vector (3 downto 0 );

	 
	 
	 RESET              : in    std_logic;                           -- reset
	
	-- outputs --
		
		register_ctrl : out std_logic;			-- read / write ; eine 1 fuer write 		
		mux_alu_in_ctrl0 : out std_logic_vector (3 downto 0 ); -- hier muss alu_in1 draufgelegt werden
		mux_alu_in_ctrl1 : out std_logic_vector (3 downto 0 );	-- hier muss alu_in2 draufgelegt werden		
		demux_alu_out_ctrl: out std_logic_vector (3 downto 0);	-- hier muss alu_out draufgelegt werden		
		mux_address_ctrl: out std_logic_vector (1 downto 0 );	-- hier musss spx_pcx_in draufgelegt werden		
		alu_ctrl: out std_logic_vector (4 downto 0);				-- hier muss instruction_in draufgelegt werden		
		absolute_register : out word; -- hier koennen absolute Werte uebergeben werden		
		instruction_register_ctrl: out std_logic;
		spx_reset: out std_logic;
		spx_decrement: out std_logic;
		pcx_reset : out std_logic;
		pcx_increment : out std_logic;	
		readMemory : out std_logic;                   -- processor wants to read on memory		
		writeMemory : out std_logic;               -- processor wants to write on memory
		spX_ctrl: out std_logic;		
		pcX_ctrl: out std_logic;
		rb0X_ctrl: out std_logic;
		rb1X_ctrl: out std_logic;
		absolute_register_ctrl: out std_logic
    );

end entity control_unit_2;

architecture behavior of control_unit_2 is
		

    -- define state-type
    type TSTATE is
    (
		  RSTATE, -- ein reset zustand
		  INIT, -- Initialisieren der komponenten
	     FETCH_1,  -- Einlesen der Siganale
		  FETCH_2,
		  FETCH_3,
		  FETCH_4,
		  FETCH_5,
		  FETCH_6,
		  FETCH_7,
		  FETCH_8,
        STOREA, -- StoreA
        TYP_1,  -- LOAD, MOV
        TYP_2,  -- ADDR, ADDR, SUBR, MULR, DIVR, OR, AND
        TYP_3,  -- ADDA, SUBA, MULA, DIVA
        JUMP,   -- JUPMP
        JUMPZ,  -- JUMPZ
        HALT,   -- HALT
		  EXECUTE,	-- fuehre aus
		
		WAIT_1SEC, -- Wartet noch eine Sequenz
		WAIT_2SEC, -- Wartet noch 2 Sequenzen
		WAIT_3SEC, -- Wartet noch 3 Sequenzen
		WAIT_4SEC, -- Wartet noch 4 Sequenzen
		WAIT_5SEC -- Wartet noch 5 Sequenzen
    );
    signal CURRENT_STATE, NEXT_STATE : TSTATE;
    constant RESET_STATE : TSTATE := RSTATE;
	 
	
	

begin


    NEXT_STATE <=
		  INIT   when CURRENT_STATE = RESET_STATE else  
        STOREA when CURRENT_STATE = FETCH_8  and (instruction_in="00000") else
        TYP_1  when CURRENT_STATE = FETCH_8  and (instruction_in="00001" or instruction_in="00010") else
        TYP_2  when CURRENT_STATE = FETCH_8  and (instruction_in="00011" or instruction_in="00101" or instruction_in="00111" or instruction_in="01001" or instruction_in="01011" or instruction_in="01100" ) else
        TYP_3  when CURRENT_STATE = FETCH_8  and (instruction_in="00100" or instruction_in="00110" or instruction_in="01000" or instruction_in="01010") else
        JUMP   when CURRENT_STATE = FETCH_8  and (instruction_in="01101") else
        JUMPZ  when CURRENT_STATE = FETCH_8  and (instruction_in="01110") else
        HALT   when CURRENT_STATE = FETCH_8  and (instruction_in="01111") else
		  
		  EXECUTE when CURRENT_STATE= WAIT_1SEC else
		  FETCH_1 when CURRENT_STATE= EXECUTE or CURRENT_STATE= INIT  else
		  FETCH_2 when CURRENT_STATE= FETCH_1 else
		  FETCH_3 when CURRENT_STATE= FETCH_2 else
		  FETCH_4 when CURRENT_STATE= FETCH_3 else
		  FETCH_5 when CURRENT_STATE= FETCH_4 else
		  FETCH_6 when CURRENT_STATE= FETCH_5 else
		  FETCH_7 when CURRENT_STATE= FETCH_6 else
		  FETCH_8 when CURRENT_STATE= FETCH_7 else
		  
		  
		  WAIT_5SEC when CURRENT_STATE=STOREA or CURRENT_STATE=TYP_1 or CURRENT_STATE=Typ_2 or CurRENT_STATE = Typ_3 or CURRENT_STATE=JUMP OR CURRENT_STATE=JUMPZ else 
		
			WAIT_1SEC when CURRENT_STATE = WAIT_2SEC else
			WAIT_2SEC when CURRENT_STATE = WAIT_3SEC else
			WAIT_3SEC when CURRENT_STATE = WAIT_4SEC else
			WAIT_4SEC when CURRENT_STATE = WAIT_5SEC else
			  CURRENT_STATE;

    process(clk, RESET, NEXT_STATE) is
    begin
        if RESET='1' then
            CURRENT_STATE <= RESET_STATE;
        elsif clk'event and clk='1' then
            CURRENT_STATE <= NEXT_STATE;
        end if;
    

    --Definition des Verhaltens hinsichtlich
    --der Ausgabe
    CASE CURRENT_STATE IS
	 WHEN INIT =>
		spX_reset<='1';
		pcX_reset<='1';
	 
	 WHEN FETCH_1 | FETCH_2 =>
		writeMemory <='0';
		readMemory <='1';
		mux_address_ctrl <= "01";	
		instruction_register_ctrl <='1'; 
		spx_reset<='0';
		pcx_reset <='0';
		pcx_increment <='0';
		spx_decrement <='0';
		register_ctrl <='0';
		pcX_ctrl <='0';
		spX_ctrl <='0';
		rb0X_ctrl<='0';
		rb1X_ctrl<='0';
		
		
	WHEN  FETCH_3 | FETCH_4 | FETCH_5 | FETCH_6 | FETCH_7 =>
	
		writeMemory <='0';
		readMemory <='1';
		mux_address_ctrl <= "01";	-- use always pcX
		instruction_register_ctrl <='1'; 
		spx_reset<='0';
		pcx_reset <='0';
		pcx_increment <='0';
		spx_decrement <='0';
		register_ctrl <='0';
		pcX_ctrl <='0';
		spX_ctrl <='0';
		rb0X_ctrl<='0';
		rb1X_ctrl<='0';
		demux_alu_out_ctrl<="0111";
		
	WHEN FETCH_8 =>
		mux_address_ctrl <=spx_pcx_in;
		
	 
	WHEN STOREA => 
		if(alu_out = "1111") then  -- fals auf den Speicher geschrieben werden soll, wird writeMemory auf 1 gestellt
			writeMemory <= '1';
			readMemory <= '0';
			spX_decrement <='1';
			rb0X_ctrl <='0';
			rb1X_ctrl <='0';
			instruction_register_ctrl<='0';
			
		else
			writeMemory <= '0';
			readMemory <= '0';
			rb0X_ctrl<='1';
			rb1X_ctrl <='1';
		end if;
		
		pcX_increment<='0';
		register_ctrl <= '0';  -- write in Register
		mux_alu_in_ctrl0 <= alu_in1;
		instruction_register_ctrl <= '0';
		demux_alu_out_ctrl <= alu_out;
      mux_address_ctrl <= spx_pcx_in;
		alu_ctrl <= instruction_in;
		absolute_register <= absolute_in;
		pcX_ctrl <='0';
		absolute_register_ctrl<='1';

		
	
	WHEN TYP_1 =>
		
		pcX_increment<='0';
		register_ctrl <= '1';
		mux_alu_in_ctrl0 <= alu_in1;
		demux_alu_out_ctrl <= alu_out;
      mux_address_ctrl <= spx_pcx_in;
		alu_ctrl <= instruction_in;
	instruction_register_ctrl <='0';
		if(alu_out= "1111") then  -- fals auf den Speicher geschrieben werden soll, wird writeMemory auf 1 gestellt
			writeMemory <= '1';
			readMemory <= '0';
	--		spX_decrement <= '1';
		elsif(alu_in1="1111") then -- falls vom Speicher gelesen werden soll
			writeMemory <='0';
			readMemory <='1';
		else
			writeMemory <= '0';
			readMemory <= '0';
		end if;
		
		
	WHEN TYP_2 =>
	
		

		if(alu_out= "1111" ) then  -- fals auf den Speicher geschrieben werden soll, wird writeMemory auf 1 gestellt
			writeMemory <= '1';
			readMemory <= '0';
	--		spX_decrement <= '1';
		elsif(alu_in1="1111") then -- falls vom Speicher gelesen werden soll
			writeMemory <='0';
			readMemory <='1';
		else
			writeMemory <= '0';
			readMemory <= '0';
		end if;
		
		
		instruction_register_ctrl<='0';
		pcX_increment<='0';
		register_ctrl <= '1';
		mux_alu_in_ctrl0 <= alu_in1;
		mux_alu_in_ctrl1 <= alu_in2;
		demux_alu_out_ctrl <= alu_out;
		mux_address_ctrl <= spx_pcx_in;
		alu_ctrl <= instruction_in;
	WHEN TYP_3 =>
	
	    if(alu_out = "1111") then  -- fals auf den Speicher geschrieben werden soll, wird writeMemory auf 1 gestellt
			writeMemory <= '1';
			readMemory <= '0';
			
		elsif(alu_in1="1111") then -- falls vom Speicher gelesen werden soll
			writeMemory <='0';
			readMemory <='1';
		else
			writeMemory <= '0';
			readMemory <= '0';
		end if;
		
		instruction_register_ctrl<='0';
		pcX_increment<='0';
		register_ctrl <= '1';
		mux_alu_in_ctrl0 <= alu_in1;
		mux_alu_in_ctrl1 <= alu_in2;
		demux_alu_out_ctrl <= alu_out;
		mux_address_ctrl <= spx_pcx_in;
		alu_ctrl <= instruction_in;
		absolute_register <= absolute_in;
	WHEN JUMP =>
		instruction_register_ctrl<='0';
		mux_alu_in_ctrl0 <= alu_in1;
		alu_ctrl <= instruction_in;
		demux_alu_out_ctrl <="1011";	-- store in pcX
		pcX_ctrl <= '1';
	
	WHEN JUMPZ =>
		instruction_register_ctrl<='0';
		mux_alu_in_ctrl0 <= alu_in1;
		mux_alu_in_ctrl1 <= alu_in2;
		mux_address_ctrl <= spx_pcx_in;
		alu_ctrl <= instruction_in;
	
	WHEN HALT =>
		instruction_register_ctrl<='0';
		pcX_increment<='0';
		spX_decrement<='0';
		alu_ctrl<="01111";

		
	WHEN EXECUTE =>
		pcx_increment<='1';
		register_ctrl<='1';
		instruction_register_ctrl<='0';
		
	WHEN WAIT_1SEC =>
		writeMemory <='0';
		readMemory <='0';
		register_ctrl<='0';
		
		
   WHEN  WAIT_2SEC =>
		pcx_increment <='0';
		spx_decrement <='0';
		pcX_increment <= '0';
		instruction_register_ctrl <= '0';
		absolute_register_ctrl<='0';
		register_ctrl <='0';
		writeMemory<='0';
		readMemory <='0';
		
		
	WHEN  WAIT_3SEC  =>
	
		register_ctrl<='0';
		instruction_register_ctrl <='0';
		
	WHEN WAIT_4SEC | WAIT_5SEC =>
		pcx_increment <='0';
		spx_decrement <='0';
		pcX_increment <= '0';
		instruction_register_ctrl <= '0';
		register_ctrl <='0';
		absolute_register_ctrl <='1';
		
		
		
	
	WHEN OTHERS =>
		alu_ctrl <= instruction_in;
    END CASE;


    end process; 


end behavior;




