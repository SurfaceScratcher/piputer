// Piputer — top shell (display lid)
//
// Display: Elecrow 7" 1024x600 IPS Touchscreen
//   Outer bounding box: 180x124x10 mm
//   Active area:        154.21 x 85.92 mm
//
// Lid covers keyboard area only: W=226 x D=130 mm
// H=15: display 10mm + bezel 3mm + 2mm clearance
//
// Coordinate convention (standalone / print orientation):
//   Z = 0  : open back face  <- display inserted from here; print this face DOWN
//   Z = H  : display/bezel face (faces keyboard when closed, user when open)
//
// Shell cross-section (Z axis):
//   Z  0..12 : hollow interior  (display panel lives here)
//   Z 12..15 : front bezel (3 mm solid -- active-area window cut through)
//
// Back face (Z=0) is fully open -- closed by top_cover.scad.
// Hinge: barrel axis at back edge Y=D_front=130, Z=0 -> world (Y=130, Z=38) when closed.

include <./params.scad>

module top(
    W=W, D=130, H=lid_H, wall=wall,
    back_t  = back_t,
    bezel_t = bezel_t,

    // Active-area window -- lcd() placed at (23, 2, 0) in top.scad coords
    ao_x      = 36.0,
    ao_y      = 21.0,
    disp_ao_w = 154.21,
    disp_ao_d = 85.92,

    // Corner boss M2.5 heat-insert holes (back-plate attachment)
    ins_d     = ins_d_m25,
    ins_depth = ins_depth_m3
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

            // Corner bosses (dia 8 x 5 mm) at back-plate corners
            for (pos = [[6,6],[220,6],[6,124],[220,124]])
                translate([pos[0], pos[1], 0])
                    cylinder(h=back_t, d=standoff_d, $fn=24);
        }

        // Active-area window through front bezel
        translate([ao_x, ao_y, int_z1 - eps])
            cube([disp_ao_w, disp_ao_d, bezel_t + 2*eps]);

        // Boss M2.5 heat-insert holes (dia 3.5 x 4 mm blind from Z=0)
        for (pos = [[6,6],[220,6],[6,124],[220,124]])
            translate([pos[0], pos[1], -eps])
                cylinder(h=ins_depth + eps, d=ins_d, $fn=16);

        // ── Hinge-zone wall relief ──────────────────────────────────────
        // Remove rear 12 mm of left/right side walls (Z=0..int_z1) so
        // the lid nests inside the bottom shell at Y=130..140.
        translate([-eps , D - wall - 10, -eps])
            cube([wall + 30 + 2*eps, 10 + wall + eps, int_z1 + eps]);
        translate([W - wall - 30 - eps, D - wall - 10, -eps])
            cube([wall + 30 + 2*eps, 10 + wall + eps, int_z1 + eps]);

    }

}

top();
