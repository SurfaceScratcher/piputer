// Pimoroni NVMe Base — HAT-format PCIe M.2 NVMe carrier for Raspberry Pi 5
// PCB: 87.5 × 56 × 1.6 mm (HAT footprint)
// Mounting: 4× M2.5, same hole pattern as RPi 5 (58×49 mm, 3.5 mm from corners)
// Stacks below RPi 5 with 7 mm M2.5 board-to-board spacers (included in Pimoroni kit)

module nvme_base(ssd_length=42) {
    pcb_h = 1.6;

    // PCB body (with mounting holes)
    difference() {
        color("darkgreen") cube([87.5, 56, pcb_h]);
        // 4× M2.5 mounting holes Ø2.7mm, 3.5 mm from each corner, 58×49 mm spacing
        translate([3.5,  3.5,  -0.1]) cylinder(h=pcb_h + 0.2, d=2.7, $fn=16);
        translate([61.5, 3.5,  -0.1]) cylinder(h=pcb_h + 0.2, d=2.7, $fn=16);
        translate([3.5,  52.5, -0.1]) cylinder(h=pcb_h + 0.2, d=2.7, $fn=16);
        translate([61.5, 52.5, -0.1]) cylinder(h=pcb_h + 0.2, d=2.7, $fn=16);
    }

    // --- Components on PCB top face (Z=pcb_h above PCB bottom) ---

    // FPC connector → RPi 5 PCIe port (right side, toward RPi)
    translate([8, 1, pcb_h])
        color("white") cube([12, 4, 3]);

    // M.2 Key-M edge connector
    translate([20, 17, pcb_h])
        color("silver") cube([22, 4.4, 3.5]);

    // NVMe SSD placeholder (M.2 form factor)
    translate([20, 14, pcb_h + 3.5])
        color("dimgray") cube([ssd_length, 22, 3.5]);

    // Retention screw boss (cylinder at far end of SSD)
    translate([20 + ssd_length - 3, 25, pcb_h])
        color("darkgray") cylinder(h=3, d=5, $fn=16);

    // NVMe controller IC
    translate([55, 8, pcb_h])
        color("darkgray") cube([8, 8, 1]);

    // 4× M2.5 board-to-board spacers (Pimoroni kit), Ø5 OD, H=7, bore Ø2.7
    for (pos = [[3.5, 3.5], [61.5, 3.5], [3.5, 52.5], [61.5, 52.5]]) {
        translate([pos[0], pos[1], pcb_h])
            difference() {
                color("silver") cylinder(h=7, d=5, $fn=16);
                translate([0, 0, -0.1]) cylinder(h=7.2, d=2.7, $fn=16);
            }
    }
}

nvme_base();
