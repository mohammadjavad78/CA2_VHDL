LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY add_sub IS 
GENERIC(bits:INTEGER:=4);
PORT(
    in1,in2:IN STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    cin:IN STD_LOGIC;
    out1:OUT STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    cout1:OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE arch OF add_sub IS 
    SIGNAL output:STD_LOGIC_VECTOR(bits DOWNTO 0);
begin
    cout1<=output(bits);
    out1<=output(bits-1 DOWNTO 0);
    output<=(in1(bits-1)&in1)+in2+cin WHEN CIN='0' ELSE (in1(bits-1)&in1)+(not(IN2))+cin;
END ARCHITECTURE;