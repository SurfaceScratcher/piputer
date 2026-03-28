// Elecrow 7" 1024x600 IPS Touchscreen — OpenSCAD model
//
// Outer bounding box: 180 x 124 x 10 mm (with HDMI connector: 16.4 mm below PCB)
// Active area: 154.21 x 85.92 mm
// PCB: 170 x 114 x 1.5 mm
// 4x mounting lash tabs with 3.5mm bores
//
// Coordinate convention:
//   Z = 0    : PCB bottom face
//   Z = 1.5  : PCB top face
//   Z = 3.5  : display panel bottom
//   Z = 9.0  : display panel top (glass surface)

module display(
    panel_w = 165,
    panel_d = 109,
    panel_h = 5.5
) {
    color("black")
        cube([panel_w, panel_d, panel_h]);
}

module hdmi(
    body_w = 11,
    body_d = 15,
    body_h = 4.65,
    plug_w = 11,
    plug_d = 11,
    plug_h = 2
) {
    color("grey") {
        cube([body_w, body_d, body_h]);
        translate([0, 2, body_h])
            cube([plug_w, plug_d, plug_h]);
    }
}

module lash(
    tab_w   = 8,
    tab_d   = 4.5,
    tab_h   = 1.5,
    bore_d  = 3.5
) {
    difference() {
        union() {
            cube([tab_w, tab_d, tab_h]);
            translate([tab_w/2, 0, 0])
                cylinder(h=tab_h, d=tab_w, center=false, $fn=24);
        }
        translate([tab_w/2, 0, 0])
            cylinder(h=tab_h * 3, d=bore_d, center=true, $fn=16);
    }
}

module pcb(
    pcb_w = 170,
    pcb_d = 114,
    pcb_h = 1.5
) {
    color("green") {
        cube([pcb_w, pcb_d, pcb_h]);

        // 4x mounting lash tabs
        // Bottom left
        translate([0, -4.5, 0])
            lash();
        // Bottom right
        translate([pcb_w - 8, -4.5, 0])
            lash();
        // Top right
        translate([pcb_w, pcb_d, 0])
            rotate([0, 0, 180])
            translate([0, -4.5, 0])
                lash();
        // Top left
        translate([8, pcb_d, 0])
            rotate([0, 0, 180])
            translate([0, -4.5, 0])
                lash();
    }
}

module lcd() {
    // Display panel on PCB top face
    translate([2.5, 2.5, 2])
        display();

    // PCB
    pcb();

    // HDMI connector (extends below PCB)
    translate([170 + 1.5 - 11, 4.35, -6.4])
        hdmi();
}

lcd();
