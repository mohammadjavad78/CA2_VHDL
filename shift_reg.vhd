LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;

ENTITY shift_reg IS 
GENERIC(bits:INTEGER:=4);
PORT(
    in1:IN STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    inbit:IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    en:IN STD_LOGIC;
    clk:IN STD_LOGIC;
    rst:IN STD_LOGIC;
    loaden:IN STD_LOGIC;
    out1:OUT STD_LOGIC_VECTOR(bits-1 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE arch OF shift_reg IS 
SIGNAL output:STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
begin
out1<=output;
PROCESS(clk,rst) BEGIN 
    IF(rst='1') THEN
        output<=(OTHERS=>'0');
    ELSIF(clk='1' AND clk'EVENT) THEN 
        IF(en='1') THEN
            IF(loaden='1') THEN
                output<=in1;
            ELSE 
                output<=(inbit&output(bits-1 DOWNTO 2));
            END IF;
        END IF;
    END IF;
END PROCESS;
END ARCHITECTURE;