library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity ecc_double_tb is
end ecc_double_tb ;

architecture ecc_double_tb_arch of ecc_double_tb is
    component ecc_double
    port (
        x_i : in Fp2;
        y_i : in Fp2;
        z_i : in Fp2;

        x_o : out Fp2;
        y_o : out Fp2;
        z_o : out Fp2
    );
    end component;

    signal x1_i_s : Fp2;
    signal y1_i_s : Fp2;
    signal z1_i_s : Fp2;

    signal x_o_s : Fp2;
    signal y_o_s : Fp2;
    signal z_o_s : Fp2;

begin

    -- x1_i_s <= (X"03", X"02", X"00");
    -- y1_i_s <= (X"07", X"05", X"00");
    -- z1_i_s <= (X"01", X"03", X"00");

    x1_i_s <= (X"03", X"09", X"00");
    y1_i_s <= (X"01", X"08", X"00");
    z1_i_s <= (X"0A", X"00", X"00");

    DUT: ecc_double
    port map (
        x_i => x1_i_s,
        y_i => y1_i_s,
        z_i => z1_i_s,

        x_o => x_o_s,
        y_o => y_o_s,
        z_o => z_o_s
    ) ;
end architecture ; -- ecc_double_tb_arch

configuration ecc_double_tb_conf of ecc_double_tb is
    for ecc_double_tb_arch 
        for DUT:ecc_double
            use entity lib_rtl.ecc_double(ecc_double_arch);
        end for;
    end for;
end configuration ecc_double_tb_conf;
