// Piputer — keyboard cover plate (Tastaturabdeckung)
// Sits on top of bottom shell at Z=H (=35), closes the open top.
// Keyboard cutout exposes the MC-8017 key area.
//
// Coordinate convention: matches bottom.scad (X=0..W, Y=0..D, Z=0..t)
// Place in assembly: translate([0, 0, 35]) kb_cover();

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

    difference() {
        cube([W, D, t]);

        // Keyboard cutout
        translate([cut_x, cut_y, -eps])
            cube([cut_w, cut_d, t + 2*eps]);
    }
}

kb_cover();
