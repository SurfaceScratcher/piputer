// Piputer — bottom enclosure shell (stepped / Ceres-1 profile)
//
// Profile (side view, Y axis):
//   Front zone  Y=0..130,  H_front=20  — keyboard area (open top, closed by kb_cover)
//   Rear zone   Y=130..200, H_rear=35  — electronics area (open top, closed by lid when open)
//   Lid sits on kb_cover: bezel at Z=H_front+kb_t=23, back at Z=38 (3mm hinge gap)
//
// Hinge barrel: Y=130, Z=38 (3mm above rear zone top)
//
// RPi/NVMe standoffs: OD=8mm, H=7mm, blind M2.5 heat-insert hole Ø3.5mm × 5mm from top

use <./piMount.scad>;
use <./usvMount.scad>;
use <./kbMount.scad>;


eps = 0.01;

module bottom(
    W=226, D=200, H_front=20, H_rear=35, wall=2, floor_t=3,
    D_front=130,   // depth of keyboard zone

    // RPi5 / NVMe: board left/front corner in outer coords (rear zone inner front face = D_front+wall)
    rpi_ox=139, rpi_oy=132,

    // Waveshare UPS 3S: rotated 90° → 93mm X, 60mm Y (rear zone)
    usv_ox=6,   usv_oy=132,

    // MC-8017 keyboard: 220×118mm (front zone)
    kb_ox=3,    kb_oy=2
) {
    D_rear      = D - D_front;   // = 70
    standoffH   = 7;
    standoffD   = 8;
    insertD     = 3.5;   // M2.5
    insertDepth = 5;
    

    difference() {
        union() {
            // Front block (keyboard zone)
            cube([W, D_front, H_front]);
            // Rear block (electronics zone)
            translate([0, D_front, 0])
                cube([W, D_rear, H_rear]);
}

        // ── Hollow interior ──────────────────────────────────────────────────

        // Front zone interior (open top at Z=H_front, no wall at Y=D_front)
        translate([wall, wall, floor_t])
            cube([W - 2*wall, D_front - wall, H_front - floor_t]);

        // Rear zone interior (open top at Z=H_rear, no front wall needed)
        translate([wall, D_front, floor_t])
            cube([W - 2*wall, D_rear - wall, H_rear - floor_t]);

        // ── Right-wall RPi5 port cutouts ─────────────────────────────────────
        // Ethernet RJ45: Y 121..138, Z 18..34 → 17mm × 16mm
        translate([W - wall - eps, 121, 18])
            cube([wall + 2*eps, 17, 16]);
        // USB-A × 2 merged slot: Y 137..169, Z 18..33 → 32mm × 15mm
        translate([W - wall - eps, 137, 18])
            cube([wall + 2*eps, 32, 15]);

        // NVMe Base PCB overhang clearance (2.5mm past right inner wall, Z=10..11.6)
        translate([W - wall - eps, rpi_oy, 10 - eps])
            cube([wall + 2*eps, 56, 1.6 + 2*eps]);

        // ── Hinge bow clearance notches in step wall ────────────────────────
        // The bow arc outer edge intrudes ~1mm into the step wall inner face.
        // Cut a small relief at each hinge position.
        translate([59, D_front - wall - 1, 15])
            cube([10, wall + 1 + eps, 6]);
        translate([157, D_front - wall - 1, 15])
            cube([10, wall + 1 + eps, 6]);
    }

    // ── PCB standoffs ──────────────────────────────────────────────────────────

    // RPi5 / NVMe Base: HAT holes at [3.5, 3.5] from board left/front edge, spacing 58×49mm
    translate([rpi_ox + 3.5, rpi_oy + 3.5, floor_t])
        pi_mounts(z0=0, insertD=3.5, insertDepth=5);

    // Waveshare UPS 3S: corner holes 3mm from board edge, spacing 87×54mm
    translate([usv_ox + 3, usv_oy + 3, floor_t])
        usv_mounts(z0=0, insertD=3.5, insertDepth=5);



    // ── Hinge support bars ──────────────────────────────────────────────────
    // Solid pillars from floor to H_front under each hinge mount plate.
    // Blind M2.5 heat-insert holes (Ø3.5 × 5 mm) match loecher_reihe() in
    // hinge_eeepc.scad (loch_rand=3, loch_abstand=4, anzahl_unten=5).
    //
    // Barrel offsets (hinge_rise=15, winkel=70, breite=7.4):
    //   barrel_y_off ≈ 9.40 → mount_y = D_front − 9.40 ≈ 120.60
    //   Mount plate Y span: 91.00 .. 120.60 (laenge_a=29.6)
    hinge_w       = 7.4;    // breite
    hinge_plate_l = 29.6;   // laenge_a
    hinge_mount_y = D_front - 9.40;               // mount plate Y origin
    hinge_bar_y   = hinge_mount_y - hinge_plate_l; // ≈ 92.09
    hinge_bar_h   = H_front - floor_t;             // 17 mm

    hinge_holes   = 5;
    hinge_lr      = 3;      // loch_rand
    hinge_pitch   = 4;      // loch_abstand

    for (hx = [60, 166 - hinge_w]) {
        difference() {
            translate([hx, hinge_bar_y, floor_t])
                cube([hinge_w, hinge_plate_l, hinge_bar_h]);
            for (i = [0 : hinge_holes - 1])
                translate([hx + hinge_w/2,
                           hinge_bar_y + hinge_lr + i * hinge_pitch,
                           H_front - insertDepth])
                    cylinder(h = insertDepth + eps, d = insertD, $fn=16);
        }
    }

}


bottom();
