// Waveshare UPS Module 3S
// 3-cell series Li-ion UPS for Raspberry Pi
//
// PCB dimensions: 60 × 93 × 1.6 mm
// Mounting holes:  Ø3 mm, 3 mm from each edge → spacing 54 × 87 mm
//
// Coordinate convention (natural orientation):
//   X = 0..60   (short axis / width)
//   Y = 0..93   (long axis / depth)
//   Z = 0       : PCB bottom face
//   Z = 1.6     : PCB top face
//
// NOTE: in bottom.scad this board is placed rotated 90° (93 mm → X, 60 mm → Y).
//       Mount-hole centres in that orientation: distX=87, distY=54.

include <./params.scad>

// ─── PCB ──────────────────────────────────────────────────────────────────

module _usv_pcb(W=60, D=93, H=1.6, hole_d=3.2, hole_off=3) {
    color("darkgreen")
    difference() {
        cube([W, D, H]);
        for (x = [hole_off, W - hole_off])
            for (y = [hole_off, D - hole_off])
                translate([x, y, -eps])
                    cylinder(h=H + 2*eps, d=hole_d, $fn=20);
    }
}

// ─── Connectors ───────────────────────────────────────────────────────────

// USB-C receptacle — 5 V / 5 A output, centred on front short edge (Y=0)
// Body: 9 × 7.5 × 3.3 mm, overhangs PCB by 1 mm
module _usv_usbc(pcb_w=60, pcb_h=1.6) {
    color("silver")
    translate([pcb_w/2 - 4.5, -1, pcb_h])
        cube([9, 7.5, 3.3]);
}

// XH2.54 2-pin power-input connector (12.6 V charger)
// Right-rear corner, body 7 × 6 × 5 mm
module _usv_xh_pwr(pcb_w=60, pcb_d=93, pcb_h=1.6) {
    color("white")
    translate([pcb_w - 10, pcb_d - 8, pcb_h])
        cube([7, 6, 5]);
}

// XH2.54 4-pin battery-pack connector (3S 18650 cells)
// Centre-rear area, body 13 × 6 × 5 mm
module _usv_xh_bat(pcb_w=60, pcb_d=93, pcb_h=1.6) {
    color("white")
    translate([pcb_w/2 - 6.5, pcb_d - 8, pcb_h])
        cube([13, 6, 5]);
}

// XH2.54 2-pin output connector (or test pads) — front-left
module _usv_xh_out(pcb_h=1.6) {
    color("white")
    translate([2, 2, pcb_h])
        cube([7, 6, 5]);
}

// ─── RPi interface header ──────────────────────────────────────────────────

// 4-pin 2.54 mm header (5 V, GND, SDA, SCL) along left long edge
// Body: 2.5 × 10.2 × 2.5 mm, 4 pins at 2.54 mm pitch
module _usv_rpi_header(pcb_h=1.6) {
    color("black")
    translate([0, 12, pcb_h])
        cube([2.5, 4*2.54, 2.5]);
    // Pins below PCB (through-hole)
    color("silver")
    for (i = [0:3])
        translate([1.25, 12 + i*2.54 + 1.27, -3])
            cylinder(h=3, d=0.6, $fn=8);
}

// ─── Active components ────────────────────────────────────────────────────

// BMS IC — IP5328P or similar, QFN package, centre-left region
module _usv_bms_ic(pcb_h=1.6) {
    color("darkgray")
    translate([10, 28, pcb_h])
        cube([10, 10, 1.0]);
}

// Boost-converter IC — SOT/QFN, right of BMS
module _usv_boost_ic(pcb_h=1.6) {
    color("darkgray")
    translate([36, 28, pcb_h])
        cube([8, 8, 1.0]);
}

// Shielded power inductor — Ø12 × 6 mm, centre
module _usv_inductor(pcb_w=60, pcb_h=1.6) {
    color("gray")
    translate([pcb_w/2, 50, pcb_h])
        cylinder(h=6, d=12, $fn=36);
}

// Bulk electrolytic capacitors × 2 (charge pump / output filter)
module _usv_caps(pcb_h=1.6) {
    color("#4169e1")   // steel-blue
    for (y = [58, 70])
        translate([12, y, pcb_h])
            cylinder(h=9, d=6.3, $fn=20);
}

// Small MLCC / ceramics (decoupling)
module _usv_ceramics(pcb_h=1.6) {
    color("tan")
    for (pos = [[20,20],[28,20],[36,20],[20,38],[36,38]])
        translate([pos[0], pos[1], pcb_h])
            cube([3.2, 1.6, 1.0]);
}

// ─── Controls & indicators ────────────────────────────────────────────────

// Tactile power switch, right-centre
module _usv_switch(pcb_w=60, pcb_h=1.6) {
    color("red")
    translate([pcb_w - 11, 40, pcb_h])
        cube([6, 6, 3.5]);
    // button cap
    color("darkred")
    translate([pcb_w - 9, 42, pcb_h + 3.5])
        cylinder(h=1.5, d=3.5, $fn=16);
}

// Status LEDs × 3 (charge / full / fault), right side near front
module _usv_leds(pcb_w=60, pcb_h=1.6) {
    cols = ["limegreen", "limegreen", "red"];
    for (i = [0:2]) {
        color(cols[i])
        translate([pcb_w - 6, 10 + i*5, pcb_h])
            cube([1.6, 1.6, 1.2]);
    }
}

// ─── Batteries ────────────────────────────────────────────────────────────

// Single 18650 Li-ion cell.
// Bounding box origin at (0,0,0).
// Cell axis along Y:  X = 0..d,  Y = 0..l,  Z = 0..d
module battery_18650(d=18.5, l=65) {
    r = d / 2;
    translate([r, 0, r]) {
        rotate([-90, 0, 0]) {
            // PVC heat-shrink sleeve
            color("#2255aa")
            cylinder(h=l, r=r, $fn=40);
            // Positive terminal (+) button at Y=l end
            color("silver")
            translate([0, 0, l])
                cylinder(h=2, d=5.5, $fn=20);
            // Negative terminal (−) flat disc at Y=0
            color("#333333")
            translate([0, 0, -0.3])
                cylinder(h=0.3, d=d * 0.9, $fn=40);
        }
    }
}

// 3 × 18650 battery pack with plastic holder.
// Cells arranged side-by-side along X, axis along Y.
// Bounding box: X=0..hold_w, Y=0..hold_d, Z=0..hold_h
module usv_battery_pack(cell_d=18.5, cell_l=65, n=3, wall=1.5, contact=3) {
    hold_w = n * cell_d + 2 * wall;           // ≈ 58.5 mm
    hold_d = cell_l + 2 * (wall + contact);   // ≈ 74   mm
    hold_h = cell_d + 2 * wall;               // ≈ 21.5 mm

    // Outer shell with cell cavities removed
    color("gold", 0.55)
    difference() {
        cube([hold_w, hold_d, hold_h]);

        // 3 cylindrical cell bores (+ 0.4 mm radial clearance)
        for (i = [0 : n - 1])
            translate([wall + i * cell_d + cell_d / 2,
                       wall + contact,
                       wall + cell_d / 2])
                rotate([-90, 0, 0])
                    cylinder(h=cell_l, r=cell_d / 2 + 0.4, $fn=40);

        // Open bottom slot for wiring access
        translate([wall, hold_d / 2 - 4, -eps])
            cube([hold_w - 2 * wall, 8, wall + 2 * eps]);
    }

    // Spring contact strips (nickel, both ends)
    color("silver")
    for (y_side = [wall - 0.4, wall + contact + cell_l + 0.4 - 1])
        translate([wall, y_side, wall])
            cube([n * cell_d, 1, cell_d]);

    // 3 × cells
    for (i = [0 : n - 1])
        translate([wall + i * cell_d, wall + contact, wall])
            battery_18650(cell_d, cell_l);

    // 4-wire cable stub exiting the bottom slot (to XH connector)
    color("#cc4400")
    translate([hold_w / 2 - 1, hold_d / 2, -8])
        cube([2, 4, 8]);
}

// ─── Main assembly ────────────────────────────────────────────────────────

// batteries=true  → include battery pack behind the PCB
module usv(W=60, D=93, pcb_h=1.6, batteries=true) {
    _usv_pcb(W, D, pcb_h);
    _usv_usbc(W, pcb_h);
    _usv_xh_pwr(W, D, pcb_h);
    _usv_xh_bat(W, D, pcb_h);
    _usv_xh_out(pcb_h);
    _usv_rpi_header(pcb_h);
    _usv_bms_ic(pcb_h);
    _usv_boost_ic(pcb_h);
    _usv_inductor(W, pcb_h);
    _usv_caps(pcb_h);
    _usv_ceramics(pcb_h);
    _usv_switch(W, pcb_h);
    _usv_leds(W, pcb_h);

    if (batteries) {
        cell_d = 18.5; cell_l = 65; n = 3; wall = 1.5; contact = 3;
        hold_w = n * cell_d + 2 * wall;           // ≈ 58.5 mm
        hold_d = cell_l + 2 * (wall + contact);   // ≈ 74 mm
        // Centre pack on PCB in XY, sit on top of PCB (Z = pcb_h)
        translate([(W - hold_w) / 2, (D - hold_d) / 2, pcb_h])
            usv_battery_pack();
    }
}

usv();
