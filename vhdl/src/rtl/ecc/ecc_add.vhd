library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library lib_rtl;
use lib_rtl.const.all;

entity ecc_add is
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
end ecc_add ;

architecture ecc_add_arch of ecc_add is

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

    signal x1_s : FP2;
    signal y1_s : FP2;
    signal z1_s : FP2;
    signal x2_s : FP2;
    signal y2_s : FP2;
    signal z2_s : FP2;

    signal x_o_s : FP2;

    signal y_o_s : FP2;
    signal vw_s : FP2;
    signal t_vw_s : FP2;

    signal z_o_s : FP2;

    signal w_s : FP2;
    signal z1z2_s : FP2;
    signal t_z1z2_s : FP2;
    signal x1z2_x2z1_s : FP2;
    signal u_x1z2_x2z1_s : FP2;

    signal t_s : FP2;
    signal y1z2_s : FP2;
    signal y2z1_s : FP2;

    signal t2_s : FP2;

    signal v_s : FP2;
    signal k_s : FP2;

    signal u_s : FP2;
    signal x1z2_s : FP2;
    signal x2z1_s : FP2;

    signal u2_s : FP2;
    signal u3_s : FP2;

begin

    x_o <= x_o_s when (y1_s /= nullFP2) and (y2_s /= nullFP2) else
           x1_i when (y1_s /= nullFP2) and (y2_s = nullFP2) else
           x2_i when (y2_s /= nullFP2) and (y1_s = nullFP2) else
           upFP2;
    y_o <=  y_o_s when (y1_s /= nullFP2) and (y2_s /= nullFP2) else
            y1_i when (y1_s /= nullFP2) and (y2_s = nullFP2) else
            y2_i when (y2_s /= nullFP2) and (y1_s = nullFP2) else
            nullFP2;
    z_o <=  z_o_s when (y1_s /= nullFP2) and (y2_s /= nullFP2) else
            z1_i when (y1_s /= nullFP2) and (y2_s = nullFP2) else
            z2_i when (y2_s /= nullFP2) and (y1_s = nullFP2) else
            upFP2;

    x1_s <= x1_i;
    y1_s <= y1_i;
    z1_s <= z1_i;
    x2_s <= x2_i;
    y2_s <= y2_i;
    z2_s <= z2_i;
    ----- Compute U 
    -- X1Z2 = X1 * Z2 dans FP2
    X1Z2:Fp2_mul
    port map(
        op1 => x1_s,
        op2 => z2_s,
        res => x1z2_s
    );
    -- X2Z1 = X2 * Z1 dans FP2
    X2Z1:Fp2_mul
    port map(
        op1 => x2_s,
        op2 => z1_s,
        res => x2z1_s
    );
    -- U = X1Z2 - X2Z1 dans FP2
    U:Fp2_add
    port map(
        add => '0',
        op1 => x1z2_s,
        op2 => x2z1_s,
        res => u_s
    );

    ---------------------------------
    ----- Compute U^2 and U^3
    U2:Fp2_mul
    port map(
        op1 => u_s,
        op2 => u_s,
        res => u2_s
    );

    U3:Fp2_mul
    port map(
        op1 => u2_s,
        op2 => u_s,
        res => u3_s
    );

    -----------------------------------
    ------ Compute T

    Y1Z2:Fp2_mul
    port map(
        op1 => y1_s,
        op2 => z2_s,
        res => y1z2_s
    );

    Y2Z1: Fp2_mul
    port map(
        op1 => y2_s,
        op2 => z1_s,
        res => y2z1_s
    );

    T: Fp2_add
    port map(
        add => '0',
        op1 => y1z2_s,
        op2 => y2z1_s,
        res => t_s
    );

    T2: Fp2_mul
    port map(
        op1 => t_s,
        op2 => t_s,
        res => t2_s
    );

    -------------------------------
    ----- Compute W

    Z1Z2: Fp2_mul
    port map(
        op1 => z1_s,
        op2 => z2_s,
        res => z1z2_s
    );

    T2Z1Z2: Fp2_mul
    port map(
        op1 => z1z2_s,
        op2 => t2_s,
        res => t_z1z2_s
    );

    X1Z2_X2Z1: Fp2_add
    port map(
        add => '1',
        op1 => x1z2_s,
        op2 => x2z1_s,
        res => x1z2_x2z1_s
    );

    U_X1Z2_X2Z1: Fp2_mul
    port map(
        op1 => u2_s,
        op2 => x1z2_x2z1_s,
        res => u_x1z2_x2z1_s
    );

    W: Fp2_add
    port map(
        add => '0',
        op1 => t_z1z2_s,
        op2 => u_x1z2_x2z1_s,
        res => w_s
    );

    -----------------------------
    ---- Compute X_o

    X: Fp2_mul
    port map(
        op1 => u_s,
        op2 => w_s,
        res => x_o_s
    );

    -----------------------------
    ----- Compute V and K
    V: Fp2_mul
    port map(
        op1 => x1z2_s,
        op2 => u2_s,
        res => v_s
    );

    K: Fp2_mul
    port map(
        op1 => y1z2_s,
        op2 => u3_s,
        res => k_s
    );

    -----------------------------
    ------ Compute Y
    VW : Fp2_add
    port map(
        add => '0',
        op1 => v_s,
        op2 => w_s,
        res => vw_s
    );

    T_VW : Fp2_mul
    port map(
        op1 => t_s,
        op2 => vw_s,
        res => t_vw_s
    );

    Y : Fp2_add
    port map(
        add => '0',
        op1 => t_vw_s,
        op2 => k_s,
        res => y_o_s
    );

    ---------------------------
    ---- Compute Z

    Z : Fp2_mul
    port map(
        op1 => u3_s,
        op2 => z1z2_s,
        res => z_o_s
    );

end architecture ; -- ecc_add_arch