// Piputer — bottom enclosure shell (stepped / Ceres-1 profile)
//
// Profile (side view, Y axis):
//   Front zone  Y=0..130,  H_front=20  — keyboard area (open top, closed by kb_cover)
//   Rear zone   Y=130..200, H_rear=35  — electronics area (open top, closed by lid when open)
//   Lid sits on kb_cover: bezel at Z=H_front+kb_t=23, back at Z=38 (3mm hinge gap)
//
// Hinge barrel: Y=130, Z=38 (3mm above rear zone top)
//
// RPi/NVMe standoffs: OD=8mm, H=7mm, blind M2.5 heat-insert hole 3.5mm x 5mm from top

include <./params.scad>
use <./piMount.scad>;
use <./usvMount.scad>;


module bottom(
    W=W, D=D, H_front=H_front, H_rear=H_rear, wall=wall, floor_t=floor_t,
    D_front=D_front,

    // RPi5 / NVMe: board left/front corner in outer coords
    rpi_ox=rpi_ox, rpi_oy=rpi_oy,

    // Waveshare UPS 3S: rotated 90 deg -> 93mm X, 60mm Y (rear zone)
    usv_ox=usv_ox, usv_oy=usv_oy
) {
    D_rear      = D - D_front;   // = 70
    insertD     = ins_d_m25;
    insertDepth = ins_depth_m25;

    // RPi5 port offsets relative to rpi_oy
    eth_y_off = -11;    // Ethernet starts 11mm before board front edge
    usb_y_off = 5;      // USB starts 5mm after board front edge

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
        // Ethernet RJ45: 17mm x 16mm
        translate([W - wall - eps, rpi_oy + eth_y_off, 18])
            cube([wall + 2*eps, 17, 16]);
        // USB-A x 2 merged slot: 32mm x 15mm
        translate([W - wall - eps, rpi_oy + usb_y_off, 18])
            cube([wall + 2*eps, 32, 15]);

        // NVMe Base PCB overhang clearance (2.5mm past right inner wall, Z=10..11.6)
        translate([W - wall - eps, rpi_oy, 10 - eps])
            cube([wall + 2*eps, 56, 1.6 + 2*eps]);

        // ── Hinge bow clearance notches in step wall ────────────────────────
        // The bow arc outer edge intrudes ~1mm into the step wall inner face.
        translate([hinge_left_x - 1, D_front - wall - 1, 15])
            cube([10, wall + 1 + eps, 6]);
        translate([hinge_right_x - width - 2, D_front - wall - 1, 15])
            cube([10, wall + 1 + eps, 6]);

        // ── Rear wall ventilation slots ──────────────────────────────────────
        // 3 horizontal slots for RPi5 passive cooling
        for (i = [0 : 2])
            translate([W/2 - 20, D - wall - eps, H_front + 5 + i * 5])
                cube([40, wall + 2*eps, 2]);
    }

    // ── PCB standoffs ──────────────────────────────────────────────────────────

    // RPi5 / NVMe Base: HAT holes at [3.5, 3.5] from board left/front edge
    translate([rpi_ox + 3.5, rpi_oy + 3.5, floor_t])
        pi_mounts(z0=0, insertD=ins_d_m25, insertDepth=ins_depth_m25);

    // Waveshare UPS 3S: corner holes 3mm from board edge
    translate([usv_ox + 3, usv_oy + 3, floor_t])
        usv_mounts(z0=0, insertD=ins_d_m25, insertDepth=ins_depth_m25);

    // ── Hinge support bars ──────────────────────────────────────────────────
    // Solid pillars from floor to H_front under each hinge mount plate.
    // Blind M2.5 heat-insert holes match hole_row() in hinge_eeepc.scad.
    hinge_w       = width;
    hinge_plate_l = plate_len;
    hinge_mount_y = D_front - barrel_y_off;
    hinge_bar_y   = hinge_mount_y - hinge_plate_l;
    hinge_bar_h   = H_front - floor_t;

    hinge_holes   = holes_base;
    hinge_lr      = hole_margin;
    hinge_pitch   = hole_pitch;

    for (hx = [hinge_left_x, hinge_right_x - hinge_w]) {
        difference() {
            translate([hx, hinge_bar_y, floor_t])
                cube([hinge_w, hinge_plate_l, hinge_bar_h]);
            for (i = [0 : hinge_holes - 1])
                translate([hx + hinge_w/2,
                           hinge_bar_y + hinge_lr + i * hinge_pitch,
                           H_front - ins_depth_m25])
                    cylinder(h = ins_depth_m25 + eps, d = insertD, $fn=16);
        }
    }

}


bottom();
