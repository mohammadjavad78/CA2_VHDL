LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;

ENTITY booth_multiplier_datapath IS 
    GENERIC(bits:INTEGER:=4);
    PORT(
        in1,in2:IN STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
        clk:IN STD_LOGIC;
        AREG_en:IN STD_LOGIC;
        AREG_rst:IN STD_LOGIC;
        AREG_loaden:IN STD_LOGIC;
        FINALREG_en1:IN STD_LOGIC;
        FINALREG_rst1:IN STD_LOGIC;
        FINALREG_en2:IN STD_LOGIC;
        FINALREG_rst2:IN STD_LOGIC;
        FINALREG_loaden1:IN STD_LOGIC;
        FINALREG_loaden2:IN STD_LOGIC;
        out1:OUT STD_LOGIC_VECTOR(2*bits-1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE radix4 OF booth_multiplier_datapath IS 
    SIGNAL AREGOUT:STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    SIGNAL AREGOUT0:STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    SIGNAL MUX3_out:STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
    SIGNAL MUX3_out_2:STD_LOGIC_VECTOR(bits+1 DOWNTO 0);
    SIGNAL FINALREG_out1:STD_LOGIC_VECTOR(bits+1 DOWNTO 0);
    SIGNAL FINALREG_out1_2:STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL FINALREG_out2:STD_LOGIC_VECTOR(2*bits DOWNTO 0);
    SIGNAL add_sub_out:STD_LOGIC_VECTOR(bits+1 DOWNTO 0);
    SIGNAL add_sub_out_shifted:STD_LOGIC_VECTOR(bits+1 DOWNTO 0);
    SIGNAL add_sub_out_2:STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL in2_0:STD_LOGIC_VECTOR(2*bits DOWNTO 0);
begin
    FINALREG_out1_2<=(FINALREG_out1(bits),FINALREG_out1(bits));
    ui:for i in 2*bits downto bits+1 generate begin 
    in2_0(i)<=in2(bits-1);
    end generate;
    in2_0(bits downto 0)<=in2&'0';
    MUX3_out_2<=AREGOUT(bits-1)&AREGOUT(bits-1)&MUX3_out when FINALREG_out2(2 DOWNTO 0)="011" else MUX3_out(bits-1)&MUX3_out(bits-1)&MUX3_out ;
    AREGOUT0<=AREGOUT(bits-2 DOWNTO 0)&'0';
    add_sub_out_2<=(add_sub_out(bits+1)&add_sub_out(bits+1));
    out1<=FINALREG_out1(bits-1 DOWNTO 0)&FINALREG_out2(2*bits DOWNTO bits+1);
    add_sub_out_shifted<=(add_sub_out(bits+1)&add_sub_out(bits+1)&add_sub_out(bits+1 DOWNTO 2));
    AREG:ENTITY WORK.reg GENERIC MAP(bits=>bits) PORT MAP(in1=>in1,en=>AREG_en,clk=>clk,rst=>AREG_rst,loaden=>AREG_loaden,out1=>AREGOUT);
    MUX3:ENTITY WORK.mux3 GENERIC MAP(bits=>bits) PORT MAP(in1=>(OTHERS=>'0'),in2=>AREGOUT,in3=>AREGOUT,in4=>AREGOUT0,in5=>AREGOUT0,in6=>AREGOUT,in7=>AREGOUT,in8=>(OTHERS=>'0'),cin=>FINALREG_out2(2 DOWNTO 0),out1=>MUX3_out);
    ADDSUB:ENTITY WORK.add_sub GENERIC MAP(bits=>bits+2) PORT MAP(in1=>FINALREG_out1,in2=>MUX3_out_2,cin=>FINALREG_out2(2),out1=>add_sub_out);
    FINALREG1:ENTITY WORK.shift_reg GENERIC MAP(bits=>bits+2) PORT MAP(in1=>add_sub_out_shifted,inbit=>add_sub_out_2,en=>FINALREG_en1,clk=>clk,rst=>FINALREG_rst1,loaden=>FINALREG_loaden1,out1=>FINALREG_out1);
    FINALREG2:ENTITY WORK.shift_reg GENERIC MAP(bits=>2*bits+1) PORT MAP(in1=>in2_0,inbit=>add_sub_out(1 DOWNTO 0),en=>FINALREG_en2,clk=>clk,rst=>FINALREG_rst2,loaden=>FINALREG_loaden2,out1=>FINALREG_out2);
END ARCHITECTURE;


LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.numeric_std.ALL;
    use IEEE.math_real.all;
    use IEEE.math_real."ceil";
    use IEEE.math_real."log2";
ENTITY booth_multiplier_controller IS 
    GENERIC(bits:INTEGER:=4);
    PORT(
        clk:IN STD_LOGIC;
        start:IN STD_LOGIC;
        rst:IN STD_LOGIC;
        AREG_en:OUT STD_LOGIC;
        AREG_rst:OUT STD_LOGIC;
        AREG_loaden:OUT STD_LOGIC;
        FINALREG_en1:OUT STD_LOGIC;
        FINALREG_rst1:OUT STD_LOGIC;
        FINALREG_loaden1:OUT STD_LOGIC;
        FINALREG_loaden2:OUT STD_LOGIC;
        FINALREG_en2:OUT STD_LOGIC;
        FINALREG_rst2:OUT STD_LOGIC;
        completeR4:OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE radix4 OF booth_multiplier_controller IS 
    TYPE state IS (s0,s1,s2);
    SIGNAL currentstate:state:=s0;
    SIGNAL nextstate:state:=s0;
    SIGNAL counter_en:STD_LOGIC;
    SIGNAL counter_rst:STD_LOGIC;
    SIGNAL load_en:STD_LOGIC;
    SIGNAL ZZ:STD_LOGIC;
    SIGNAL ZEROS:STD_LOGIC_VECTOR(integer(ceil(log2(real(bits))))+1 DOWNTO 0);
    SIGNAL load:STD_LOGIC_VECTOR(integer(ceil(log2(real(bits)))) DOWNTO 0);
    SIGNAL output:STD_LOGIC_VECTOR(integer(ceil(log2(real(bits)))) DOWNTO 0);
BEGIN
    ZEROS(0)<='0';
    ZZ<=ZEROS(integer(ceil(log2(real(bits))))+1);
    uui:FOR I IN 0 TO integer(ceil(log2(real(bits)))) GENERATE
    BEGIN
        ZEROS(I+1)<=ZEROS(I) OR output(I);
    END GENERATE;
    counter:ENTITY WORK.counter GENERIC MAP(inputbit=>integer(ceil(log2(real(bits))))+1) PORT MAP(clk=>clk,rst=>counter_rst,en=>counter_en,UPDOWN=>'0',load_en=>load_en,load=>load,output=>output);
PROCESS(currentstate,start,ZEROS(integer(ceil(log2(real(bits))))+1)) BEGIN
    AREG_loaden<='0'; 
    AREG_en<='0';
    AREG_rst<='0';
    AREG_loaden<='0';
    FINALREG_en1<='0';
    FINALREG_rst1<='0';
    FINALREG_en2<='0';
    FINALREG_rst2<='0';
    completeR4<='0';
    load_en<='0';
    CASE currentstate IS 
        WHEN s0=>
            AREG_loaden<='1';
            AREG_en<='1';
            FINALREG_en2<='0';
            FINALREG_loaden2<='0';
            FINALREG_rst1<='1';
            counter_en<='1';
            load_en<='1';
            load<=STD_LOGIC_VECTOR(TO_UNSIGNED(bits/2,load'LENGTH));
            IF(start='1') THEN
                nextstate<=s1;
            END IF;
        WHEN s1=>
            nextstate<=s2;
            FINALREG_en2<='1';
            FINALREG_loaden2<='1';
            counter_en<='1';
            load_en<='1';
            load<=STD_LOGIC_VECTOR(TO_UNSIGNED(bits/2,load'LENGTH));
            counter_en<='1';
        WHEN s2=>
            counter_en<='1';
            FINALREG_en2<='1';
            FINALREG_en1<='1';
            FINALREG_loaden1<='1';
            FINALREG_loaden2<='0';
            IF(ZEROS(integer(ceil(log2(real(bits))))+1)='0') THEN
                nextstate<=s0;
                completeR4<='1';
            ELSE
                nextstate<=s2;
            END IF;
    END CASE;
    END PROCESS;
    PROCESS(clk,rst) BEGIN 
        IF(rst='1') THEN
            currentstate<=s0;
        ELSIF(clk='1' AND clk'EVENT) THEN
            currentstate<=nextstate;
        END IF;
    END PROCESS;
END ARCHITECTURE;




LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;

ENTITY booth_multiplier IS 
    GENERIC(bits:INTEGER:=4);
    PORT(
        in1,in2:IN STD_LOGIC_VECTOR(bits-1 DOWNTO 0);
        clk:IN STD_LOGIC;
        start:IN STD_LOGIC;
        rst:IN STD_LOGIC;
        out1:OUT STD_LOGIC_VECTOR(2*bits-1 DOWNTO 0);
        completeR4:OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE radix4 OF booth_multiplier IS 
    SIGNAL AREG_en:STD_LOGIC;
    SIGNAL AREG_rst:STD_LOGIC;
    SIGNAL AREG_loaden:STD_LOGIC;
    SIGNAL FINALREG_en1:STD_LOGIC;
    SIGNAL FINALREG_rst1:STD_LOGIC;
    SIGNAL FINALREG_loaden1:STD_LOGIC;
    SIGNAL FINALREG_loaden2:STD_LOGIC;
    SIGNAL FINALREG_en2:STD_LOGIC;
    SIGNAL FINALREG_rst2:STD_LOGIC;
begin
    datapath:ENTITY WORK.booth_multiplier_datapath GENERIC MAP(bits=>bits) PORT MAP(in1=>in1,in2=>in2,clk=>clk,AREG_en=>AREG_en,AREG_rst=>AREG_rst,AREG_loaden=>AREG_loaden,FINALREG_en1=>FINALREG_en1,FINALREG_rst1=>FINALREG_rst1,FINALREG_en2=>FINALREG_en2,FINALREG_rst2=>FINALREG_rst2,FINALREG_loaden1=>FINALREG_loaden1,FINALREG_loaden2=>FINALREG_loaden2,out1=>out1);
    controller:ENTITY WORK.booth_multiplier_controller GENERIC MAP(bits=>bits) PORT MAP(clk=>clk,start=>start,rst=>rst,AREG_en=>AREG_en,AREG_rst=>AREG_rst,AREG_loaden=>AREG_loaden,FINALREG_en1=>FINALREG_en1,FINALREG_rst1=>FINALREG_rst1,FINALREG_loaden1=>FINALREG_loaden1,FINALREG_loaden2=>FINALREG_loaden2,FINALREG_en2=>FINALREG_en2,FINALREG_rst2=>FINALREG_rst2,completeR4=>completeR4);
END ARCHITECTURE;