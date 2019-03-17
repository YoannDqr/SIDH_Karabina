library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity Fp2_mul is
    port(
        op1 : in FP2;
        op2 : in FP2;
        res : out FP2
    );
end entity Fp2_mul;

architecture Fp2_mul_arch of Fp2_mul is
    component Fp2_add
        port(
            add : in std_logic;
            op1 : in FP2;
            op2 : in FP2;
            res : out FP2
        );
    end component;

    component Fp2_mul_redux
        port(
            op : in FP2;
            res : out FP2
        );
    end component;

    signal op1_s: FP2;
    signal op2_s: FP2;
    signal res_s: FP2;

    signal c1_s: FP2;
    signal c2_s: FP2;

    signal a1_s: FP2;
    signal a2_s: FP2;

    signal ab1_s: FP2;
    signal ab2_s: FP2;

    signal ab1_tmp: FP2Mult;
    signal ab2_tmp: FP2Mult;

begin

    op1_s <= op1;
    op2_s <= op2;
    res <= res_s;

    c1_s <= ((others=>'0'), (others=>'0'), (others=>'0'));
    a1_s <= op1_s;
    ADD1:FP2_add
    port map(
        add => '1',
        op1 => c1_s,
        op2 => ab1_s,
        res => c2_s
    );

    REDUX1: Fp2_mul_redux
    port map(
        op => a1_s,
        res => a2_s
    );

    ADD2:FP2_add
    port map(
        add => '1',
        op1 => c2_s,
        op2 => ab2_s,
        res => res_s
    );

    
    FOR1:for i in 0 to 2 generate
        -- A * b_i dans F_p
        ab1_tmp(i) <= std_logic_vector(unsigned(a1_s(i) * op2_s(0)) mod p );
        ab1_s(i) <= ab1_tmp(i)(ab1_s(i)'length - 1 downto 0);

        ab2_tmp(i) <= std_logic_vector(unsigned(a2_s(i) * op2_s(1)) mod p );
        ab2_s(i) <= ab2_tmp(i)(ab2_s(i)'length - 1 downto 0);
    end generate;

end architecture Fp2_mul_arch;

configuration Fp2_mul_conf of Fp2_mul is
    for Fp2_mul_arch

        for ADD1:Fp2_add
            use entity lib_rtl.Fp2_add(Fp2_add_arch);
        end for;
        for ADD2:Fp2_add
            use entity lib_rtl.Fp2_add(Fp2_add_arch);
        end for;

        for REDUX1:Fp2_mul_redux
            use entity lib_rtl.Fp2_mul_redux(Fp2_mul_redux_arch);
        end for;
    
    end for;
end configuration Fp2_mul_conf;