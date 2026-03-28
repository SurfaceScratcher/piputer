// Piputer — keyboard cover plate (Tastaturabdeckung)
// Sits on top of bottom shell front zone at Z=H_front(20), closes the open top.
// Keyboard cutout exposes the MC-8017 key area.
//
// Coordinate convention: matches bottom.scad (X=0..W, Y=0..D, Z=0..t)
// Place in assembly: translate([0, 0, H_front]) kb_cover();

include <./params.scad>

module kb_cover(
    W     = W,
    D     = D_front,    // covers keyboard area only (lid footprint)
    t     = kb_t,
    wall  = wall,

    // Keyboard cutout: 205 mm (X) x 79 mm (Y)
    // Centred in X, flush with front inner wall in Y
    cut_w = 205,
    cut_d = 79
) {
    cut_x = (W - cut_w) / 2;   // = 10.5 mm -> centred
    cut_y = wall;               // flush with inner front wall

    // Hinge screw positions (from params.scad)
    hinge_w       = width;
    hinge_mount_y = D - barrel_y_off;
    hinge_bar_y   = hinge_mount_y - plate_len;
    hinge_lr      = hole_margin;
    hinge_pitch   = hole_pitch;
    hinge_holes   = holes_base;
    clr_d         = clr_d_m25;

    difference() {
        cube([W, D, t]);

        // Keyboard cutout
        translate([cut_x, cut_y, -eps])
            cube([cut_w, cut_d, t + 2*eps]);

        // Hinge screw clearance holes (5 per hinge, 2 hinges)
        for (hx = [hinge_left_x + hinge_w/2, hinge_right_x - hinge_w/2])
            for (i = [0 : hinge_holes - 1])
                translate([hx, hinge_bar_y + hinge_lr + i * hinge_pitch, -eps])
                    cylinder(h = t + 2*eps, d = clr_d, $fn=16);

        // side_a knuckle cylinder clearance (dia=width at far end of each mount plate)
        for (hx = [hinge_left_x + hinge_w/2, hinge_right_x - hinge_w/2])
            translate([hx, hinge_bar_y, -eps])
                cylinder(h = t + 2*eps, d = width, $fn=24);
    }
}

kb_cover();
