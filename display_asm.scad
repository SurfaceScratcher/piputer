// Piputer — display lid assembly
//
// Includes: top shell, back cover plate, LCD panel, hinge lid halves.
// Standalone preview: set preview_angle below to test at various open angles.
//
// Hinge lid halves (flange2) are part of the lid so they rotate with it.
// Barrel positions at back face Y=D_front=130, Z=bz_local=8 (lid-local coords).
//
// BARREL AXIS: each lid hinge half has its barrel at local (0,0,0) along X.
// The translate below places the barrel at the correct position in lid coords.
// rotate([180,0,0]) flips the arm into -Z (into lid interior) — this is a
// rotation around the barrel axis (X), so the axis alignment is preserved.

include <./params.scad>
use <./top.scad>;
use <./top_cover.scad>;
use <./display.scad>;
use <./hinge_eeepc.scad>;

module display_asm(
    back_t = back_t,
    barrel_left_x  = hinge_left_x,     // must match bottom_asm x_pos
    barrel_right_x = hinge_right_x,     // must match bottom_asm x_pos
    barrel_y       = D_front,
    open_angle     = 0       // 0 = closed/print, 120 = typical open
) {
    top();
   translate([0, 0, -back_t]) top_cover();
    translate([23, 10, 5])      lcd();

    // Hinge lid halves — barrel at (X, barrel_y, bz_local)
    // eeepc_hinge_lid_half() has barrel at local (0,0,0), pin in -X.
    // rotate([180,0,0]) rotates around barrel axis (X) to flip arm into lid interior.
    // mirror([1,0,0]) for right side flips pin from -X to +X.
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

// Set preview_angle to test hinge clearance at various positions
// 0 = closed/print orientation, 120 = typical open
preview_angle = 0;

display_asm(open_angle=preview_angle);
