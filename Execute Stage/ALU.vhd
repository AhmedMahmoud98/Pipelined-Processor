LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY ALU IS 
    PORT(
        A , B : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        OP    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        C     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        FLAGS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)    -- 0 & C & N & Z
    );
END ENTITY;

ARCHITECTURE arch OF ALU IS 
BEGIN 
    PROCESS(A,B,OP)
    VARIABLE RES : STD_LOGIC_VECTOR(32 DOWNTO 0);
    VARIABLE CARRY,FLAGS_UPD: STD_LOGIC;
    BEGIN 
	RES   := (OTHERS => '0');
	CARRY := '0';
	FLAGS_UPD := '0';
	IF OP = "0010" THEN		-- NOT
		RES(31 DOWNTO 0) := NOT A;
		FLAGS_UPD := '1';
	ELSIF OP = "0011" THEN	-- INC
		RES := ('0' & A) + 1;
		CARRY := RES(32);
		FLAGS_UPD := '1';
	ELSIF OP = "0100" THEN	-- DEC
		RES := ('0' & A) + ('0'& x"FFFFFFFF");
		CARRY := RES(32);
		FLAGS_UPD := '1';
	ELSIF OP = "0101" THEN	-- ADD
		RES := ('0' & A) + ('0' & B);
		CARRY := RES(32);
		FLAGS_UPD := '1';
	ELSIF OP = "0110" THEN	-- SUB
		RES := ('0' & A) - ('0' & B);
		CARRY := RES(32);
		FLAGS_UPD := '1';
	ELSIF OP = "0111" THEN	-- AND
		RES(31 DOWNTO 0) := A AND B;
		FLAGS_UPD := '1';
	ELSIF OP = "1000" THEN	-- OR
		RES(31 DOWNTO 0) := A OR B;
		FLAGS_UPD := '1';
	ELSIF OP = "1001" THEN  -- SHL
		IF TO_INTEGER(UNSIGNED(B)) < 32 THEN
			RES(31 DOWNTO 0) := STD_LOGIC_VECTOR(SHIFT_LEFT(SIGNED(A),TO_INTEGER(UNSIGNED(B))));
			IF TO_INTEGER(UNSIGNED(B)) = 0 THEN
				CARRY := '0';
			ELSE 
				CARRY := A(32 - TO_INTEGER(UNSIGNED(B)));
			END IF;
			FLAGS_UPD := '1';
		END IF;
	ELSIF OP = "1010" THEN  -- SHR
		IF TO_INTEGER(UNSIGNED(B))<32 THEN
			RES(31 DOWNTO 0) := STD_LOGIC_VECTOR(SHIFT_RIGHT(SIGNED(A),TO_INTEGER(UNSIGNED(B))));
			IF TO_INTEGER(UNSIGNED(B)) = 0 THEN
				CARRY := '0';
			ELSE 
				CARRY := A(TO_INTEGER(UNSIGNED(B)) - 1);
			END IF;
			FLAGS_UPD := '1';
		END IF;
	ELSIF OP = "1011" THEN  -- LDM
		RES(31 DOWNTO 0) := B;
	ELSE 
		RES(31 DOWNTO 0) := A;
	END IF;
	C <= RES(31 DOWNTO 0);
	IF FLAGS_UPD = '1' THEN
		IF RES(31 DOWNTO 0) = x"00000000" THEN
			FLAGS(0) <= '1';
		ELSE 
			FLAGS(0) <= '0';
		END IF;
			FLAGS(1) <= RES(31);
			FLAGS(2) <= CARRY;
	END IF;
    END PROCESS;
	FLAGS(3) <= '0';
END ARCHITECTURE;