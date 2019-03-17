library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity Fp2_mul_tb is
end Fp2_mul_tb;

architecture Fp2_mul_tb_arch of Fp2_mul_tb is
    component Fp2_mul
        port(
            op1 : in FP2;
            op2 : in FP2;
            res : out FP2
        );
    end component;
    signal op1_s:FP2;
    signal op2_s:FP2;
    signal res_s: FP2;
begin
    op1_s <= (X"01", X"01", X"00");
    op2_s <= (X"00", X"01", X"00");

    DUT:Fp2_mul
    port map(
        op1 => op1_s,
        op2 => op2_s,
        res => res_s
    );
end architecture ; -- Fp2_mul_tb_ar

configuration Fp2_mul_tb_conf of Fp2_mul_tb is
    for Fp2_mul_tb_arch 
        for DUT:Fp2_mul
            use entity lib_rtl.Fp2_mul(Fp2_mul_arch);
        end for;
    end for;
end configuration Fp2_mul_tb_conf;
