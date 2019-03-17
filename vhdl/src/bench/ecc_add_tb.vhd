library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity ecc_add_tb is
end ecc_add_tb ;

architecture ecc_add_tb_arch of ecc_add_tb is
    component ecc_add
    port (
        x1_i : in Fp2;
        y1_i : in Fp2;
        z1_i : in Fp2;

        x2_i : in Fp2;
        y2_i : in Fp2;
        z2_i : in Fp2;

        x_o : out Fp2;
        y_o : out Fp2;
        z_o : out Fp2
    ) ;
    end component;

    signal x1_i_s : Fp2;
    signal y1_i_s : Fp2;
    signal z1_i_s : Fp2;

    signal x2_i_s : Fp2;
    signal y2_i_s : Fp2;
    signal z2_i_s : Fp2;

    signal x_o_s : Fp2;
    signal y_o_s : Fp2;
    signal z_o_s : Fp2;

begin

    x1_i_s <= (X"03", X"02", X"00");
    y1_i_s <= (X"07", X"05", X"00");
    z1_i_s <= (X"01", X"03", X"00");

    x2_i_s <= (X"08", X"01", X"00");
    y2_i_s <= (X"00", X"00", X"00");
    z2_i_s <= (X"09", X"09", X"00");



    DUT: ecc_add
    port map (
        x1_i => x1_i_s,
        y1_i => y1_i_s,
        z1_i => z1_i_s,

        x2_i => x2_i_s,
        y2_i => y2_i_s,
        z2_i => z2_i_s,

        x_o => x_o_s,
        y_o => y_o_s,
        z_o => z_o_s
    ) ;
end architecture ; -- ecc_add_tb_arch

configuration ecc_add_tb_conf of ecc_add_tb is
    for ecc_add_tb_arch 
        for DUT:ecc_add
            use entity lib_rtl.ecc_add(ecc_add_arch);
        end for;
    end for;
end configuration ecc_add_tb_conf;
