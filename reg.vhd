LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;

ENTITY reg IS 
GENERIC(bits:INTEGER:=4);
PORT(
    in1:IN STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    en:IN STD_LOGIC;
    clk:IN STD_LOGIC;
    rst:IN STD_LOGIC;
    loaden:IN STD_LOGIC;
    out1:OUT STD_LOGIC_VECTOR(bits-1 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE arch OF reg IS 
begin
PROCESS(clk,rst) BEGIN 
    IF(rst='1') THEN
        out1<=(OTHERS=>'0');
    ELSIF(clk='1' AND clk'EVENT) THEN 
        IF(en='1' AND loaden='1') THEN
            out1<=in1;
        END IF;
    END IF;
END PROCESS;
END ARCHITECTURE;