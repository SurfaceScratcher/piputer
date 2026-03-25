// Piputer — parametric spring-strip clamshell hinge
//
// Two-piece spring hinge for the Piputer step-wall barrel position:
//   Barrel world position: Y=130, Z=35  (D_front, H_rear)
//
// bottom_mount() — base half: flat plate + arc + arm
//   Mount plate lies at Z=0, extends in −Y from origin.
//   Place at world (X, D_front=130, Z=0).
//
// flange2()      — lid half: short arm + small arc
//   After eeepc_hinge_asm() the lid piece sits at
//   (offset_x, offset_y, offset_z) ≈ (4, 6.5, 37.1) above the base origin.
//   In the Piputer assembly (lid closed) that maps to top.scad local
//   (X+offset_x, D_front+offset_y, −(offset_z−H_rear)) ≈ (X+4, 136.5, −2.1).
//
// Usage in main.scad:
//   use <./hinge_eeepc.scad>;
//   // base half (outside assembly block)
//   translate([60,  D_front, 0]) bottom_mount();
//   translate([166, D_front, 0]) mirror([1,0,0]) bottom_mount();
//   // lid half (inside mirror([0,0,1]) lid block, top.scad coords)
//   translate([64,   136.5, -2.1]) rotate([0,180,0]) flange2();
//   translate([162,  136.5, -2.1]) mirror([1,0,0]) rotate([0,180,0]) flange2();

// ============================================================
// PARAMETER
// ============================================================

dicke             = 1;
breite            = 7.4;
laenge_a          = 29.6;
laenge_aq         = 22;
breite_dazwischen = 4;
winkel            = 70;
$fn               = 40;

abstand           = 13;

// -- Löcher --
loch_d            = 2.5;   // Lochdurchmesser
loch_rand         = 3;     // Abstand Rand → erstes/letztes Loch
loch_abstand      = 4;     // Abstand zwischen den Löchern
anzahl_unten      = 5;     // Löcher Bodenplatte
anzahl_oben       = 4;     // Löcher side_aq


// ============================================================
// ABGELEITETE GRÖßEN
// ============================================================

laenge_b = (abstand + (breite/2) * cos(winkel)) / (1 + sin(winkel));

zapfen_d_gross = breite;
zapfen_d_klein = breite / 2;
zapfen_h_voll  = 4 * dicke;
zapfen_h_halb  = breite_dazwischen / 2;

offset_x = 4 * dicke;
offset_y = breite/2 * (sin(winkel) - 1) + laenge_b * cos(winkel);
offset_z = laenge_b * (1 + sin(winkel)) - breite/2 * cos(winkel);

// True barrel-axis offset from the bottom_mount() placement origin.
// Derived by tracing the side_b() pin (breite/2, laenge_b, 2*dicke)
// through rotate([0,0,winkel]) then rotate([0,90,0]) in flange():
//   Ry90( Rz(winkel)·pin ) → (2·dicke,  sin·b/2+cos·lb,  sin·lb−cos·b/2)
barrel_y_off = sin(winkel) * breite/2 + cos(winkel) * laenge_b;
barrel_z_off = sin(winkel) * laenge_b - cos(winkel) * breite/2;

// Gesamtlänge die die Lochreihe belegt – zur Validierung
belegte_laenge_unten = 2 * loch_rand + (anzahl_unten - 1) * loch_abstand;
belegte_laenge_oben  = 2 * loch_rand + (anzahl_oben  - 1) * loch_abstand;

// Warnung im Log falls Löcher nicht passen
dummy_unten = (belegte_laenge_unten > laenge_a)  ? echo("⚠️  WARNUNG: Löcher passen nicht in Bodenplatte!") : 0;
dummy_oben  = (belegte_laenge_oben  > laenge_aq) ? echo("⚠️  WARNUNG: Löcher passen nicht in side_aq!") : 0;


// ============================================================
// MODULE
// ============================================================

// Löcher zentriert auf breite/2, gleichmäßig mit loch_abstand
module loecher_reihe(anzahl) {
    for (i = [0 : anzahl - 1]) {
        translate([breite/2, loch_rand + i * loch_abstand, -0.1])
            cylinder(h = dicke + 0.2, d = loch_d, center = false);
    }
}

module side_a() {
    translate([0, -laenge_a, 0])
        cube([breite, laenge_a, dicke]);
    translate([breite/2, -laenge_a, dicke/2])
        cylinder(h=breite_dazwischen/2, d=breite, center=true);
}

module side_b() {
    cube([breite, laenge_b, dicke]);
    translate([breite/2, laenge_b, dicke/2])
        cylinder(h=dicke, d=zapfen_d_gross, center=true);
    translate([breite/2, laenge_b, 2*dicke])
        cylinder(h=zapfen_h_voll, d=zapfen_d_klein, center=true);
}

module side_aq() {
    difference() {
        translate([0, -laenge_aq, 0])
            cube([breite, laenge_aq, dicke]);
        translate([0, -laenge_aq, 0])
            loecher_reihe(anzahl_oben);
    }
}

module side_bq() {
    cube([breite, laenge_b, dicke]);
    translate([breite/2, laenge_b, dicke/2])
        cylinder(h=dicke, d=zapfen_d_gross, center=true);
    translate([breite/2, laenge_b, 2*dicke])
        cylinder(h=zapfen_h_halb, d=zapfen_d_klein, center=true);
}

module bow() {
    rotate_extrude(angle=winkel)
        square([breite, dicke]);
}

module flange() {
    rotate([0, 90, 0]) {
        side_a();
        rotate([0, 0, winkel])
            side_b();
        bow();
    }
}

module flange2() {
    rotate([0, 0, 90])
        side_aq();
    rotate([0, 90, 0]) {
        rotate([0, 0, 90])
            side_bq();
    }
}

module bottom_mount() {
    flange();
    difference() {
        translate([0, -laenge_a, 0])
            cube([breite, laenge_a, dicke]);
        translate([0, -laenge_a, 0])
            loecher_reihe(anzahl_unten);
    }
}

// Full assembled hinge (base + lid piece, closed position).
// Mirrors X for the right-side instance: mirror([1,0,0]) eeepc_hinge_asm().
module eeepc_hinge_asm() {
    color([0.15, 0.15, 0.15]) {
        bottom_mount();
        translate([offset_x, offset_y, offset_z])
            rotate([0, 180, 0])
                flange2();
    }
}

// Positioned hinge for the Piputer assembly.
// Both halves treated as one rigid unit rotating with the lid.
// Spring deformation is not modelled — the base plate lifts slightly
// when open, which is physically acceptable for a spring-strip hinge.
//
// open_angle : 0 = closed, 120 = typical open
// side       : "left" or "right"
// x_pos      : X coordinate of hinge in world coords
// bar_y      : barrel axis Y (world) — D_front = 130
// bar_z      : barrel axis Z (world) — H_rear  =  35
module eeepc_hinge_piputer(open_angle=0, side="left", x_pos=60,
                            bar_y=130, bar_z=35) {
    flip  = (side == "right") ? [1, 0, 0] : [0, 0, 0];
    x_off = (side == "right") ? -offset_x : offset_x;

    color([0.15, 0.15, 0.15])
    translate([0, bar_y, bar_z])
    rotate([-open_angle, 0, 0])
    translate([0, -bar_y, -bar_z]) {
        // Base half
        translate([x_pos, bar_y, 0])
            mirror(flip) bottom_mount();
        // Lid half
        translate([x_pos + x_off, bar_y + offset_y, offset_z])
            mirror(flip) mirror([1, 0, 0]) flange2();
    }
}


// Split-piece articulated hinge for the Piputer assembly.
// bottom_mount() stays fixed; only flange2() rotates — physically correct
// clamshell kinematics.
//
// The barrel pin is geometrically offset from the bottom_mount() origin by
// (2·dicke, barrel_y_off, barrel_z_off).  The mount plate is raised to
// Z = bar_z − barrel_z_off so the pin lands exactly at world Z = bar_z.
// The rotation pivot is (*, bar_y + barrel_y_off, bar_z).
//
// open_angle : 0 = closed, positive = lid opening upward
// side       : "left" or "right"
// x_pos      : X coordinate of hinge mount in world coords
// bar_y      : Y of the bottom_mount() base — D_front = 130
// bar_z      : target world Z of the barrel axis  — H_rear  =  35
module eeepc_hinge_split(open_angle=0, side="left", x_pos=60,
                          bar_y=130, bar_z=35) {
    x_off   = (side == "right") ? -offset_x : offset_x;
    mount_z = bar_z - barrel_z_off;   // base plate Z so barrel pin sits at bar_z
    pivot_y = bar_y + barrel_y_off;   // world Y of barrel axis

    color([0.15, 0.15, 0.15]) {
        // Base half — fixed; barrel pin lands at (x_pos+2·dicke, pivot_y, bar_z)
        translate([x_pos, bar_y, mount_z]) {
            if (side == "right")
                mirror([1, 0, 0]) bottom_mount();
            else
                bottom_mount();
        }

        // Lid half — pivots around (*, pivot_y, bar_z)
        translate([0, pivot_y, bar_z])
        rotate([-open_angle, 0, 0])
        translate([0, -pivot_y, -bar_z])
        translate([x_pos + x_off, bar_y + offset_y, mount_z + offset_z]) {
            if (side == "right")
                mirror([1, 0, 0]) rotate([0, 180, 0]) flange2();
            else
                rotate([0, 180, 0]) flange2();
        }
    }
}


// ============================================================
// PREVIEW
// ============================================================

eeepc_hinge_asm();