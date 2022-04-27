LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY counter IS
    GENERIC(inputbit:INTEGER:=4);
    port (clk:IN STD_LOGIC;
    rst:IN STD_LOGIC;
    en:IN STD_LOGIC;
    UPDOWN:IN STD_LOGIC;
    load_en:IN STD_LOGIC;
    load:IN STD_LOGIC_VECTOR(inputbit-1 DOWNTO 0);
    output:OUT STD_LOGIC_VECTOR(inputbit-1 DOWNTO 0));
END counter;
ARCHITECTURE ARCH OF counter IS
    SIGNAL oup:STD_LOGIC_VECTOR(inputbit-1 DOWNTO 0);
BEGIN
    identifier : PROCESS( clk,rst )
    BEGIN
        IF(rst='1') THEN
            oup<=(OTHERS=>'0');
        ELSIF(clk='1' AND clk'EVENT) THEN 
            IF(en='1') THEN
                IF(UPDOWN='1') THEN
                oup<=oup+1;
                ELSIF(UPDOWN='0') THEN
                oup<=oup-1;
                END IF;
                IF(load_en='1') THEN
                    oup<=load;
                END IF;
            END IF;
        END IF;
    END PROCESS ;
    output<=oup;
end ARCHITECTURE;