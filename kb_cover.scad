// Piputer — keyboard cover plate (Tastaturabdeckung)
// Sits on top of bottom shell front zone at Z=H_front(20), closes the open top.
// Keyboard cutout exposes the MC-8017 key area.
//
// Coordinate convention: matches bottom.scad (X=0..W, Y=0..D, Z=0..t)
// Place in assembly: translate([0, 0, H_front]) kb_cover();

eps = 0.01;

module kb_cover(
    W     = 226,   // matches bottom shell width
    D     = 130,   // covers keyboard area only (lid footprint)
    t     = 3,     // cover thickness
    wall  = 2,     // inner wall thickness (matches bottom.scad)

    // Keyboard cutout: 205 mm (X) × 79 mm (Y)
    // Centred in X, flush with front inner wall in Y
    cut_w = 205,
    cut_d = 79
) {
    cut_x = (W - cut_w) / 2;   // = 10.5 mm → centred
    cut_y = wall;               // flush with inner front wall

    // Hinge screw positions (must match hinge_eeepc.scad & bottom.scad)
    hinge_w     = 7.4;    // breite
    hinge_mount_y = D - 9.40;                     // ≈ 120.60 (barrel_y_off with hinge_rise=15)
    hinge_bar_y   = hinge_mount_y - 29.6;         // ≈ 91.00
    hinge_lr      = 3;
    hinge_pitch   = 4;
    hinge_holes   = 5;
    clr_d         = 2.7;   // M2.5 clearance

    difference() {
        cube([W, D, t]);

        // Keyboard cutout
        translate([cut_x, cut_y, -eps])
            cube([cut_w, cut_d, t + 2*eps]);

        // Hinge screw clearance holes (5 per hinge, 2 hinges)
        for (hx = [60 + hinge_w/2, 166 - hinge_w/2])
            for (i = [0 : hinge_holes - 1])
                translate([hx, hinge_bar_y + hinge_lr + i * hinge_pitch, -eps])
                    cylinder(h = t + 2*eps, d = clr_d, $fn=16);

        // side_a knuckle cylinder clearance (Ø8 at far end of each mount plate)
        for (hx = [60 + hinge_w/2, 166 - hinge_w/2])
            translate([hx, hinge_bar_y, -eps])
                cylinder(h = t + 2*eps, d = 8, $fn=24);
    }
}

kb_cover();
