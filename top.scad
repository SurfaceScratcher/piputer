// Piputer — top shell (display lid)
use <./hinge.scad>;
//
// Display: Elecrow 7" 1024×600 IPS Touchscreen
//   Outer bounding box: 180×124×10 mm
//   Active area:        154.21 × 85.92 mm
//
// Lid covers keyboard area only: W=226 × D=130 mm
// H=15: display 10mm + bezel 3mm + 2mm clearance
//
// Coordinate convention (standalone / print orientation):
//   Z = 0  : open back face  ← display inserted from here; print this face DOWN
//   Z = H  : display/bezel face (faces keyboard when closed, user when open)
//
// Shell cross-section (Z axis):
//   Z  0..12 : hollow interior  (display panel lives here)
//   Z 12..15 : front bezel (3 mm solid — active-area window cut through)
//
// Back face (Z=0) is fully open — closed by top_cover.scad.
// Hinge: integral barrel knuckles (2 of 5) at back edge Y=D=130, Z=0 → world (Y=130, Z=35) when closed.
// Ear flanges match bottom shell ears for lid-closure screws (M2.5).

eps = 0.01;

module top(
    W=226, D=140, H=15, wall=2,
    back_t  = 5,    // boss height / back-plate thickness
    bezel_t = 3,    // display bezel thickness

    // Active-area window — lcd() placed at (23, 2, 0) in top.scad coords
    // ao_y = lcd_y + (124 − 85.92)/2 = 2 + 19.04 = 21.04
    ao_x      = 36.0,
    ao_y      = 21.0,
    disp_ao_w = 154.21,
    disp_ao_d = 85.92,

    // Corner boss M2.5 heat-insert holes (back-plate attachment)
    ins_d     = 3.5,   // M2.5 insert bore
    ins_depth = 4,

    // Lid-closure ear flanges
    // Left/right ears at Y=65 = D/2, matches bottom shell ear at D_front/2=65 in world coords
    earSz   = 12,
    ear_lr_y = 65
) {
    int_z1 = H - bezel_t;   // = 12

    difference() {
        union() {
            // Hollow frame: 2 mm walls, open at Z=0, bezel at Z=12..15
            difference() {
                cube([W, D, H]);
                translate([wall, wall, -eps])
                    cube([W-2*wall, D-2*wall, H-bezel_t+eps]);
            }

            // Ear flanges: front / left / right
           // translate([W/2 - earSz/2,    -earSz,              0]) cube([earSz, earSz, H]); // front
          //  translate([-earSz,            ear_lr_y-earSz/2,   0]) cube([earSz, earSz, H]); // left
           // translate([W,                 ear_lr_y-earSz/2,   0]) cube([earSz, earSz, H]); // right

            // Corner bosses (Ø8 × 5 mm) at back-plate corners
            for (pos = [[6,6],[220,6],[6,124],[220,124]])
                translate([pos[0], pos[1], 0])
                    cylinder(h=back_t, d=8, $fn=24);
        }

        // Active-area window through front bezel
        translate([ao_x, ao_y, int_z1 - eps])
            cube([disp_ao_w, disp_ao_d, bezel_t + 2*eps]);

        // Lid-closure M2.5 clearance holes Ø2.7 mm through ear flanges
        translate([W/2,           -(earSz/2), -eps]) cylinder(h=H + 2*eps, d=2.7, $fn=16); // front
        translate([-(earSz/2),    ear_lr_y,   -eps]) cylinder(h=H + 2*eps, d=2.7, $fn=16); // left
        translate([W+(earSz/2),   ear_lr_y,   -eps]) cylinder(h=H + 2*eps, d=2.7, $fn=16); // right

        // Boss M2.5 heat-insert holes (Ø3.5 × 4 mm blind from Z=0)
        for (pos = [[6,6],[220,6],[6,124],[220,124]])
            translate([pos[0], pos[1], -eps])
                cylinder(h=ins_depth + eps, d=ins_d, $fn=16);
    }

}

top();
