// Piputer — complete bottom unit assembly
//
// Includes: bottom shell, keyboard cover, PCBs (NVMe, RPi 5, UPS), hinge pair.
// Standalone preview renders the closed bottom unit (open_angle=0).

include <./params.scad>
use <./bottom.scad>;
use <./kb_cover.scad>;
use <./nvme.scad>;
use <./rpi5.scad>;
use <./usv.scad>;
use <./hinge_eeepc.scad>;

module bottom_asm(
    open_angle = 120,
    H_front    = H_front,
    H_rear     = H_rear,
    D_front    = D_front,
    barrel_z   = barrel_z,
    pcb_z_nvme = pcb_z_nvme,
    pcb_z_rpi  = pcb_z_rpi
) {
    // ── Shell ────────────────────────────────────────────────────────────────
    bottom();

    // ── Keyboard cover plate ─────────────────────────────────────────────────
    translate([0, 0, H_front])
        kb_cover();

    // ── Pimoroni NVMe Base ───────────────────────────────────────────────────
    translate([rpi_ox, rpi_oy, pcb_z_nvme])
        nvme_base();

    // ── Raspberry Pi 5 ──────────────────────────────────────────────────────
    translate([rpi_ox, rpi_oy, pcb_z_rpi])
        raspberry_pi_5();

    // ── Waveshare UPS 3S ─────────────────────────────────────────────────────
    // Rotated 90 deg: 93mm along X, 60mm along Y
    translate([usv_ox + 93, usv_oy, pcb_z_nvme])
    rotate([0, 0, 90])
        usv(batteries=true);

    // ── EeePC friction hinge pair (base halves only) ────────────────────────
    // Lid halves are in display_asm.scad — they rotate with the lid.
    eeepc_hinge_split(side="left",  x_pos=hinge_left_x,
                      bar_y=D_front, bar_z=barrel_z);
    eeepc_hinge_split(side="right", x_pos=hinge_right_x,
                      bar_y=D_front, bar_z=barrel_z);
}

bottom_asm();
