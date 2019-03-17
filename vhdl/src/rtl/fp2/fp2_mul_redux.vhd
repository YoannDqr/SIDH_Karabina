library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity Fp2_mul_redux is
    port(
        op : in FP2;
        res : out FP2
    );
end entity Fp2_mul_redux;

architecture Fp2_mul_redux_arch of Fp2_mul_redux is
    signal res_s: FP2;
    signal res_tmp: FP2Mult;
    signal op_s : FP2;
    signal reduction: std_logic;
begin
    op_s <= op;

    res_s(2) <= (others => '0');
    res_tmp(1) <= std_logic_vector(to_unsigned((-1 * to_integer(unsigned(F(1) * op_s(1)))) mod p, res_tmp(0)'length));
    res_s(1) <= op_s(0) when op_s(1) = res_s(2) else std_logic_vector(unsigned(op_s(0) + res_tmp(1)(Fp_bytes_length downto 0)) mod p);
    res_tmp(0) <= std_logic_vector(to_unsigned((-1 * to_integer(unsigned(F(0) * op_s(1)))) mod p, res_tmp(0)'length));
    res_s(0) <= (others => '0') when op_s(1) = res_s(2) else res_tmp(0)(Fp_bytes_length downto 0);
    
    res <= res_s;
end architecture Fp2_mul_redux_arch;