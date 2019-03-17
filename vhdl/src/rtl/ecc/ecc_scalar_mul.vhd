library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity ecc_scalar_mul is
  port (
    op_i : in std_logic_vector(Mult_bytes_length downto 0);
    x_i : in FP2;
    y_i : in FP2;
    z_i : in FP2;

    x_o : out FP2;
    y_o : out FP2;
    z_o : out FP2
  );
end ecc_scalar_mul;

architecture ecc_scalar_mul_arch of ecc_scalar_mul is
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

    component ecc_double
    port (
        x_i : in Fp2;
        y_i : in Fp2;
        z_i : in Fp2;

        x_o : out Fp2;
        y_o : out Fp2;
        z_o : out Fp2
    ) ;
    end component;

    signal x_s : FP2;
    signal y_s : FP2;
    signal z_s : FP2;

    signal x_o_s : FP2;
    signal y_o_s : FP2;
    signal z_o_s : FP2;

    signal q : ECCMult;
    signal n : ECCMult;
    signal n_use: ECCMult;

begin
    x_s <= x_i;
    y_s <= y_i;
    z_s <= z_i;
    x_o <= x_o_s;
    y_o <= y_o_s;
    z_o <= z_o_s;



    n(0)(0) <= x_s;
    n(0)(1) <= y_s;
    n(0)(2) <= z_s;

    q(0)<= infPoint when op_i(0) = '0' else (x_s, y_s, z_s);

    FOR1:for i in 0 to Mult_bytes_length generate
        n_use(i) <= infPoint when op_i(i) = '0' else (n(i)(0), n(i)(1), n(i)(2));

        QN: ecc_add
        port map(
            x1_i => q(i)(0),
            y1_i => q(i)(1),
            z1_i => q(i)(2),

            x2_i => n_use(i)(0),
            y2_i => n_use(i)(1),
            z2_i => n_use(i)(2),

            x_o => q(i+1)(0),
            y_o => q(i+1)(1),
            z_o => q(i+1)(2)
        );

        NN:ecc_double
        port map(
            x_i => n(i)(0),
            y_i => n(i)(1),
            z_i => n(i)(2),

            x_o => n(i+1)(0),
            y_o => n(i+1)(1),
            z_o => n(i+1)(2)
        );

    end generate;
    x_o_s <= q(Mult_bytes_length + 1)(0);
    y_o_s <= q(Mult_bytes_length + 1)(1);
    z_o_s <= q(Mult_bytes_length + 1)(2);

end architecture; -- ecc_scalar_mul_arch