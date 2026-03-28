// Piputer — display lid assembly
//
// Includes: top shell, back cover plate, LCD panel, hinge lid halves.
// Standalone preview renders the lid in print orientation (bezel face up).
//
// Hinge lid halves (flange2) are part of the lid so they rotate with it.
// Barrel positions at back face Z=0, Y=D_front=130.
// X coords must match bottom_asm hinge x_pos + 2*dicke (left) / - 2*dicke (right).

use <./top.scad>;
use <./top_cover.scad>;
use <./display.scad>;
use <./hinge_eeepc.scad>;

module display_asm(
    back_t = 5,    // back plate thickness
    barrel_left_x  = 62,    // left barrel X  (bottom_asm x_pos=60  + 2*dicke)
    barrel_right_x = 164,   // right barrel X (bottom_asm x_pos=166 − 2*dicke)
    barrel_y       = 130     // barrel Y (= D_front)
) {
    top();
    translate([0, 0, -back_t]) top_cover();
    translate([23, 10, 5])      lcd();

    // Hinge lid halves — barrel at Z=8 inside lid interior
    // rotate([180,0,0]) flips arm into −Z; with barrel at Z=8 the arm
    // spans Z=8..−5 (inside lid + top_cover zone, nothing sticks out).
    bz_local = 8;
    color([0.15, 0.15, 0.15]) {
        translate([barrel_left_x, barrel_y, bz_local])
            rotate([180, 0, 0])
                eeepc_hinge_lid_half();
        translate([barrel_right_x, barrel_y, bz_local])
            mirror([1, 0, 0])
                rotate([180, 0, 0])
                    eeepc_hinge_lid_half();
    }
}

display_asm();
