//mount four pads
echo("LOADING MOUNTS FILE");

eps = 0.01;


module mount4_pads(distX, distY, padD, padH, z0=0) {
    translate([0,      0,      z0]) cylinder(padH, d = padD, center = false);
    translate([distX,  0,      z0]) cylinder(padH, d = padD, center = false);
    translate([0,      distY,  z0]) cylinder(padH, d = padD, center = false);
    translate([distX,  distY,  z0]) cylinder(padH, d = padD, center = false);
}

// Bohrungen (negativer Raum)
module mount4_holes(distX, distY, holeD, depth, z0=0) {
    h = depth + 2*eps;
    translate([0,      0,      z0 - eps]) cylinder(h, d = holeD, center = false);
    translate([distX,  0,      z0 - eps]) cylinder(h, d = holeD, center = false);
    translate([0,      distY,  z0 - eps]) cylinder(h, d = holeD, center = false);
    translate([distX,  distY,  z0 - eps]) cylinder(h, d = holeD, center = false);
}
