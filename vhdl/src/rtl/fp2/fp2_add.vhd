library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity Fp2_add is
    port(
        add : in std_logic; -- 1 => op1 + op2 % p ; 0 => op1 - op2 % p
        op1 : in FP2;
        op2 : in FP2;
        res : out FP2
    );
end entity Fp2_add;

architecture FP2_add_arch of FP2_add is
    signal op1_s : FP2;
    signal op2_s : FP2 ;
    signal res_s : FP2;
    signal res_int_s : FP2;
    -- signal reduction : std_logic_vector(7 downto 0);
    type mem is array(0 to 2) of integer;
    signal tmp : mem;
begin
    op1_s <= op1;
    op2_s <= op2;
    res <= res_s;

    FOR1: for i in 0 to m generate
        tmp(i) <= (-1*to_integer(unsigned(op2_s(i)))) mod p;
        res_int_s(i) <= std_logic_vector(unsigned(op1_s(i) + op2_s(i)) mod p) when add = '1' else std_logic_vector( (unsigned(op1_s(i)) + ((-1*to_integer(unsigned(op2_s(i)))) mod p) )mod p);
    end generate FOR1;
    -- reduction <= std_logic_vector(to_unsigned((-1*to_integer(unsigned(F(1) * res_int_s(2)))) mod p,res_s(1)'length));
    res_s(2) <= (others=>'0');
    res_s(1) <= std_logic_vector(unsigned(res_int_s(1) + std_logic_vector(to_unsigned((-1*to_integer(unsigned(F(1) * res_int_s(2)))) mod p,res_s(1)'length))) mod p);
    res_s(0) <= std_logic_vector(unsigned(res_int_s(0) + std_logic_vector(to_unsigned((-1*to_integer(unsigned(F(0) * res_int_s(2)))) mod p,res_s(1)'length))) mod p);


        

end architecture FP2_add_arch;