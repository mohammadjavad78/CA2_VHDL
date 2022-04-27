LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY mux IS 
GENERIC(bits:INTEGER:=4);
PORT(
    in1,in2:IN STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    cin:IN STD_LOGIC;
    out1:OUT STD_LOGIC_VECTOR(bits-1 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE arch OF mux IS 
begin
    out1<=in1 WHEN cin='0' ELSE in2;
END ARCHITECTURE;