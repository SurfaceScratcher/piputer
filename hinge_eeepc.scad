// Piputer — parametric spring-strip clamshell hinge
//
// Two-piece spring hinge for the Piputer step-wall barrel position:
//   Barrel world position: Y=D_front(130), Z=H_rear(35)
//   Mount plate rests on keyboard cover at Z=H_front(20)
//   Arm bridges hinge_rise = H_rear − H_front = 15 mm
//
// bottom_mount() — base half: flat plate + arc + arm
//   Mount plate lies at Z=0 in local coords, extends in −Y from origin.
//
// flange2()      — lid half: short arm + pin
//   // TODO: side_aq and side_bq are not connected by a bow() arc.
//   //       They may render as two disconnected bodies.
//   //       The mounting plate (side_aq) sits behind the lid back face
//   //       (top.scad Z<0) — external mounting strategy TBD.
//
// eeepc_hinge_split() — assembly module for Piputer:
//   bar_y, bar_z = barrel world position (Y=130, Z=35)
//   Mount plate auto-positioned at (bar_y − barrel_y_off, bar_z − barrel_z_off)

// ============================================================
// PARAMETERS
// ============================================================

dicke             = 1;
breite            = 7.4;
laenge_a          = 29.6;
laenge_aq         = 22;
breite_dazwischen = 4;
winkel            = 70;
$fn               = 40;

// Height the barrel must sit above the mount plate.
// = H_rear(35) − H_front(20) − kb_cover_t(3) = 12
// Mount plate rests on top of the keyboard cover at Z = H_front + 3 = 23.
hinge_rise        = 12;

// -- Löcher --
loch_d            = 2.5;   // Lochdurchmesser
loch_rand         = 3;     // Abstand Rand → erstes/letztes Loch
loch_abstand      = 4;     // Abstand zwischen den Löchern
anzahl_unten      = 5;     // Löcher Bodenplatte
anzahl_oben       = 4;     // Löcher side_aq


// ============================================================
// ABGELEITETE GRÖßEN
// ============================================================

// Arm length derived from hinge_rise so barrel sits exactly hinge_rise
// above the mount plate:  barrel_z_off = sin(w)·lb − cos(w)·b/2 = hinge_rise
laenge_b = (hinge_rise + cos(winkel) * breite/2) / sin(winkel);

zapfen_d_gross = breite;
zapfen_d_klein = breite / 2;
zapfen_h_voll  = 4 * dicke;
zapfen_h_halb  = breite_dazwischen / 2;

offset_x = 4 * dicke;
offset_y = breite/2 * (sin(winkel) - 1) + laenge_b * cos(winkel);
offset_z = laenge_b * (1 + sin(winkel)) - breite/2 * cos(winkel);

// True barrel-axis offset from the bottom_mount() placement origin.
// Derived by tracing the side_b() pin (breite/2, laenge_b, 2*dicke)
// through rotate([0,0,winkel]) then rotate([0,90,0]) in flange().
barrel_y_off = sin(winkel) * breite/2 + cos(winkel) * laenge_b;
barrel_z_off = sin(winkel) * laenge_b - cos(winkel) * breite/2;
// With hinge_rise=12: barrel_z_off = 12, barrel_y_off ≈ 8.3

// Gesamtlänge die die Lochreihe belegt – zur Validierung
belegte_laenge_unten = 2 * loch_rand + (anzahl_unten - 1) * loch_abstand;
belegte_laenge_oben  = 2 * loch_rand + (anzahl_oben  - 1) * loch_abstand;

// Warnung im Log falls Löcher nicht passen
dummy_unten = (belegte_laenge_unten > laenge_a)  ? echo("WARNUNG: Löcher passen nicht in Bodenplatte!") : 0;
dummy_oben  = (belegte_laenge_oben  > laenge_aq) ? echo("WARNUNG: Löcher passen nicht in side_aq!") : 0;


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

// TODO: side_aq and side_bq are not connected by a bow() arc.
//       They may be two disconnected bodies — verify in OpenSCAD preview.
//       The mounting plate (side_aq) sits behind the lid back face — external mount TBD.
module flange2() {
    rotate([0, 0, 90])
        side_aq();
    rotate([0, 90, 0]) {
        rotate([0, 0, 90])
            side_bq();
    }
}

// Lid-side hinge half, barrel axis at origin, pin in −X.
// Interleaves with bottom_mount +X pin.
// Caller translates to barrel position; mirror([1,0,0]) for right side.
module eeepc_hinge_lid_half() {
    translate([2*dicke, -breite/2, laenge_b])
        rotate([0, 180, 0])
            flange2();
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

// Positioned hinge for the Piputer assembly (both halves as one rigid unit).
// Spring deformation is not modelled.
//
// open_angle : 0 = closed, 120 = typical open
// side       : "left" or "right"
// x_pos      : X coordinate of hinge in world coords
// bar_y      : barrel axis Y (world) — D_front = 130
// bar_z      : barrel axis Z (world) — H_rear  =  35
module eeepc_hinge_piputer(open_angle=0, side="left", x_pos=60,
                            bar_y=130, bar_z=35) {
    x_off   = (side == "right") ? -offset_x : offset_x;
    mount_y = bar_y - barrel_y_off;
    mount_z = bar_z - barrel_z_off;

    color([0.15, 0.15, 0.15])
    translate([0, bar_y, bar_z])
    rotate([-open_angle, 0, 0])
    translate([0, -bar_y, -bar_z]) {
        // Base half
        translate([x_pos, mount_y, mount_z]) {
            if (side == "right")
                mirror([1, 0, 0]) bottom_mount();
            else
                bottom_mount();
        }
        // Lid half
        translate([x_pos + x_off, mount_y + offset_y, mount_z + offset_z]) {
            if (side == "right")
                mirror([1, 0, 0]) rotate([0, 180, 0]) flange2();
            else
                rotate([0, 180, 0]) flange2();
        }
    }
}


// Base-side hinge for the Piputer assembly (fixed to bottom shell).
// Lid-side half (flange2) belongs in display_asm.scad — it moves with the lid.
//
// bar_y, bar_z = barrel world position (Y=130, Z=35).
// Mount plate auto-positioned at bar_y − barrel_y_off, bar_z − barrel_z_off.
module eeepc_hinge_split(side="left", x_pos=60,
                          bar_y=130, bar_z=35) {
    mount_y = bar_y - barrel_y_off;
    mount_z = bar_z - barrel_z_off;

    color([0.15, 0.15, 0.15])
    translate([x_pos, mount_y, mount_z]) {
        if (side == "right")
            mirror([1, 0, 0]) bottom_mount();
        else
            bottom_mount();
    }
}


// ============================================================
// PREVIEW
// ============================================================

eeepc_hinge_asm();
