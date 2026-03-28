// Piputer — shared standoff / pad / hole modules
//
// mount4_pads()      — 4 solid pads at rectangle corners
// mount4_holes()     — 4 through-holes (negative space)
// mount4_standoffs() — 4 solid standoffs with blind heat-insert bores

include <./params.scad>

module mount4_pads(distX, distY, padD, padH, z0=0) {
    translate([0,      0,      z0]) cylinder(padH, d = padD, center = false);
    translate([distX,  0,      z0]) cylinder(padH, d = padD, center = false);
    translate([0,      distY,  z0]) cylinder(padH, d = padD, center = false);
    translate([distX,  distY,  z0]) cylinder(padH, d = padD, center = false);
}

module mount4_holes(distX, distY, holeD, depth, z0=0) {
    h = depth + 2*eps;
    translate([0,      0,      z0 - eps]) cylinder(h, d = holeD, center = false);
    translate([distX,  0,      z0 - eps]) cylinder(h, d = holeD, center = false);
    translate([0,      distY,  z0 - eps]) cylinder(h, d = holeD, center = false);
    translate([distX,  distY,  z0 - eps]) cylinder(h, d = holeD, center = false);
}

module mount4_standoffs(distX, distY, standoffD, standoffH, insertD, insertDepth, z0=0) {
    for (px = [0, distX]) {
        for (py = [0, distY]) {
            translate([px, py, z0]) {
                difference() {
                    cylinder(h=standoffH, d=standoffD, center=false);
                    translate([0, 0, standoffH - insertDepth])
                        cylinder(h=insertDepth + eps, d=insertD, center=false);
                }
            }
        }
    }
}
