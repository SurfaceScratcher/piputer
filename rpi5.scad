// Raspberry Pi 5 OpenSCAD Model
// Basierend auf offiziellen Dimensionen: 85mm x 58mm x ~11mm
// Quelle: Raspberry Pi 5 Mechanical Drawing

// Parameter
board_width = 85;        // mm
board_depth = 58;        // mm  
board_height = 1.6;      // Standard PCB Dicke
corner_radius = 3;       // Eckenradius

// Montagelöcher
hole_diameter = 2.75;    // Bohrungsdurchmesser
hole_positions = [       // [x, y] Positionen der Löcher
    [3.5, 3.5],
    [3.5, 52.5],
    [61.5, 3.5],
    [61.5, 52.5]
];

// Komponenten Höhen
usb_height = 12.8;
ethernet_height = 13.3;
usb_c_height = 3.2;
gpio_height = 8.5;
hdmi_height = 3.4;

module rounded_rect(width, depth, height, radius) {
    hull() {
        for(x = [radius, width - radius])
            for(y = [radius, depth - radius])
                translate([x, y, 0])
                    cylinder(r = radius, h = height, $fn = 30);
    }
}

module mounting_hole(x, y) {
    translate([x, y, -0.1])
        cylinder(d = hole_diameter, h = board_height + 0.2, $fn = 30);
}

module pcb_board() {
    difference() {
        rounded_rect(board_width, board_depth, board_height, corner_radius);
        
        // Montagelöcher
        for(pos = hole_positions) {
            mounting_hole(pos[0], pos[1]);
        }
    }
}

// USB 3.0 Ports (2x)
module usb_ports() {
    color("Silver") {
        // Linker USB Port
        translate([68, 32, board_height])
            cube([15, 13.5, usb_height]);
        
        // Rechter USB Port
        translate([68, 16.5, board_height])
            cube([15, 13.5, usb_height]);
    }
}

// Gigabit Ethernet Port
module ethernet_port() {
    color("Silver")
        translate([68, -1, board_height])
            cube([21.5, 16, ethernet_height]);
}

// USB-C Power Port
module usb_c_port() {
    color("Silver")
        translate([-5.5, 6, board_height])
            cube([9, 9, usb_c_height]);
}

// Micro HDMI Ports (2x)
module hdmi_ports() {
    color("Silver") {
        // HDMI 0
        translate([-3, 24, board_height])
            cube([7, 6.5, hdmi_height]);
        
        // HDMI 1
        translate([-3, 38, board_height])
            cube([7, 6.5, hdmi_height]);
    }
}

// GPIO Header (40 Pin)
module gpio_header() {
    color("Black")
rotate([0,0,90])
        translate([32, -53.5, board_height])
            cube([5.1, 50.5, gpio_height]);
}

// Processor (SoC)
module processor() {
    color("DarkSlateGray")
        translate([28, 15, board_height])
            cube([15, 15, 2.4]);
}

// SD Card Slot
module sd_card_slot() {
    color("Silver")
        translate([26, -3, board_height - 1])
            cube([15, 3.5, 1.8]);
}

// CSI Camera Connector
module camera_connector() {
    color("WhiteSmoke")
        translate([3, 26, board_height])
            cube([22, 4, 5.5]);
}

// DSI Display Connector
module display_connector() {
    color("WhiteSmoke")
        translate([3, 45, board_height])
            cube([22, 4, 5.5]);
}

// Haupt Assembly
module raspberry_pi_5() {
    // PCB
    color("Green")
        pcb_board();
    
    // Komponenten
    usb_ports();
    ethernet_port();
    usb_c_port();
    hdmi_ports();
   // gpio_header();
    processor();
    sd_card_slot();
    camera_connector();
    display_connector();
}

// Render
raspberry_pi_5();