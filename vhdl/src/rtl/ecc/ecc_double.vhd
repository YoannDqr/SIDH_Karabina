library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity ecc_double is
  port (
    x_i : in FP2;
    y_i : in FP2;
    z_i : in FP2;

    x_o : out FP2;
    y_o : out FP2;
    z_o : out FP2
  ) ;
end ecc_double ;

architecture ecc_double_arch of ecc_double is

    component Fp2_add
    port(
        add : in std_logic;
        op1 : in FP2;
        op2 : in FP2;
        res : out FP2
    );
    end component Fp2_add;

    component Fp2_mul
    port(
        op1 : in FP2;
        op2 : in FP2;
        res : out FP2
    );
    end component Fp2_mul;

    signal x_s: FP2;
    signal y_s: FP2;
    signal z_s: FP2;
    signal x_o_s: FP2;
    signal y_o_s: FP2;
    signal z_o_s: FP2;

    signal t_s: FP2;
    signal z2_s: FP2;
    signal x2_s: FP2;
    signal az2_s: FP2;
    signal az2_tmp_s: FP2Mult;
    signal trois_x2_s: FP2;
    signal trois_x2_tmp_s: FP2Mult;

    signal u_s: FP2;
    signal yz_s: FP2;
    signal u_tmp_s: FP2Mult;

    signal w_s: FP2;
    signal t2_s: FP2;
    signal xy_s: FP2;
    signal uxy_s: FP2;
    signal quatre_uxy_tmp_s: FP2Mult;
    signal quatre_uxy_s: FP2;

    signal v_s: FP2;
    signal deux_uxy_s: FP2;
    signal deux_uxy_tmp_s: FP2Mult;

    signal u2_s : FP2;
    signal y2_s : FP2;
    signal uy2_s : FP2;
    signal k_tmp_s:FP2Mult;
    signal k_s: FP2;

    signal u3_s: FP2;
    signal tv_s: FP2;

begin

    x_o <= x_o_s when (y_s /= nullFP2) else x_i when (y_s /= nullFP2) else upFP2;
    y_o <= y_o_s when (y_s /= nullFP2) else y_i when (y_s /= nullFP2) else upFP2;
    z_o <= z_o_s when (y_s /= nullFP2) else z_i when (y_s /= nullFP2) else upFP2;


    x_s <= x_i;
    y_s <= y_i;
    z_s <= z_i;
    Z2: Fp2_mul
    port map(
        op1 => z_s,
        op2 => z_s,
        res => z2_s
    );

    X2: Fp2_mul
    port map(
        op1 => x_s,
        op2 => x_s,
        res => x2_s
    );

    Y2: Fp2_mul
    port map(
        op1 => y_s,
        op2 => y_s,
        res => y2_s
    );

    FOR1:for i in 0 to m generate
        az2_tmp_s(i) <= std_logic_vector((unsigned(z2_s(i)) * a) mod p );
        az2_s(i) <= az2_tmp_s(i)(Fp_bytes_length downto 0);

        trois_x2_tmp_s(i) <= std_logic_vector((unsigned(x2_s(i)) * 3) mod p );
        trois_x2_s(i) <= trois_x2_tmp_s(i)(Fp_bytes_length downto 0);

        u_tmp_s(i) <= std_logic_vector((unsigned(yz_s(i)) * 2) mod p );
        u_s(i) <= u_tmp_s(i)(Fp_bytes_length downto 0);

        quatre_uxy_tmp_s(i) <= std_logic_vector((unsigned(uxy_s(i)) * 4) mod p );
        quatre_uxy_s(i) <= quatre_uxy_tmp_s(i)(Fp_bytes_length downto 0);

        deux_uxy_tmp_s(i) <= std_logic_vector((unsigned(uxy_s(i)) * 2) mod p );
        deux_uxy_s(i) <= deux_uxy_tmp_s(i)(Fp_bytes_length downto 0);

        k_tmp_s(i) <= std_logic_vector((unsigned(uy2_s(i)) * 2) mod p );
        k_s(i) <= k_tmp_s(i)(Fp_bytes_length downto 0);
    end generate;

    T: Fp2_add
    port map(
        add => '1',
        op1 => trois_x2_s,
        op2 => az2_s,
        res => t_s
    );

    T2: Fp2_mul
    port map(
        op1 => t_s,
        op2 => t_s,
        res => t2_s
    );

    YZ: Fp2_mul
    port map(
        op1 => y_s,
        op2 => z_s,
        res => yz_s
    );

    XY: Fp2_mul
    port map(
        op1 => x_s,
        op2 => y_s,
        res => xy_s
    );

    UXY: Fp2_mul
    port map(
        op1 => u_s,
        op2 => xy_s,
        res => uxy_s
    );

    W: Fp2_add
    port map(
        add => '0',
        op1 => t2_s,
        op2 => quatre_uxy_s,
        res => w_s
    );

    U2: Fp2_mul
    port map(
        op1 => u_s,
        op2 => u_s,
        res => u2_s
    );

    U3: Fp2_mul
    port map(
        op1 => u2_s,
        op2 => u_s,
        res => u3_s
    );

    UY2: Fp2_mul
    port map(
        op1 => u2_s,
        op2 => y2_s,
        res => uy2_s
    );

    V: Fp2_add
    port map(
        add => '0',
        op1 => deux_uxy_s,
        op2 => w_s,
        res => v_s
    );

    TV: Fp2_mul
    port map(
        op1 => t_s,
        op2 => v_s,
        res => tv_s
    );

    z_o_s <= u3_s;

    X:Fp2_mul
    port map(
        op1 => u_s,
        op2 => w_s,
        res => x_o_s
    );

    Y: Fp2_add
    port map(
        add => '0',
        op1 => tv_s,
        op2 => k_s,
        res => y_o_s
    );

end ecc_double_arch ; -- ecc_double_arch