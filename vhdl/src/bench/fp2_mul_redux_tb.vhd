library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity Fp2_mul_redux_tb is
end entity;

architecture Fp2_mul_redux_tb_arch of Fp2_mul_redux_tb  is

    component Fp2_mul_redux
    port(
        op : in FP2;
        res : out FP2
    );
    end component;

    signal op_s : FP2;
    signal res_s : FP2;
begin
    DUT:Fp2_mul_redux
    port map(
        op => op_s,
        res => res_s
    );

    op_s <= (X"01", X"01", X"00"); -- 8X + 1
    
    
end architecture Fp2_mul_redux_tb_arch ; 

configuration Fp2_mul_redux_tb_conf of Fp2_mul_redux_tb is
    for Fp2_mul_redux_tb_arch 
        for DUT:Fp2_mul_redux
            use entity lib_rtl.Fp2_mul_redux(Fp2_mul_redux_arch);
        end for;
    end for;
end configuration Fp2_mul_redux_tb_conf;