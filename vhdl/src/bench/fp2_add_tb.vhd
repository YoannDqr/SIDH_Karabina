library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity Fp2_add_tb is
end entity;

architecture Fp2_add_tb_arch of Fp2_add_tb  is

    component Fp2_add
    port(
        add : in std_logic;
        op1 : in FP2;
        op2 : in FP2;
        res : out FP2
    );
    end component;

    signal op1_s : FP2;
    signal op2_s : FP2;
    signal res_s : FP2;
begin
    DUT:Fp2_add
    port map(
        add => '0',
        op1 => op1_s,
        op2 => op2_s,
        res => res_s
    );

    op1_s <= (X"01", X"08", X"00"); -- 8X + 1
    op2_s <= (X"03", X"03", X"00"); -- 3X + 3
    
    
end architecture Fp2_add_tb_arch ; 

configuration Fp2_add_tb_conf of Fp2_add_tb is
    for Fp2_add_tb_arch 
        for DUT:Fp2_add
            use entity lib_rtl.Fp2_add(Fp2_add_arch);
        end for;
    end for;
end configuration Fp2_add_tb_conf;