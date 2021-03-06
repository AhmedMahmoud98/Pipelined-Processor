LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FALLING_EDGE_REG IS
    GENERIC(Size: INTEGER := 32);
    PORT(
        CLK, RST, EN    : IN  STD_LOGIC;
        Din             : IN  STD_LOGIC_VECTOR(Size-1 DOWNTO 0);
        Dout            : OUT STD_LOGIC_VECTOR(Size-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch OF FALLING_EDGE_REG IS
BEGIN
    PROCESS(CLK, RST)
    BEGIN
        IF FALLING_EDGE(CLK) THEN
            IF RST='1' THEN
                Dout <= (OTHERS => '0');
            ELSIF EN='1' THEN
                Dout <= Din;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;