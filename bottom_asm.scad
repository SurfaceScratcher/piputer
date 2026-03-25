// Piputer — complete bottom unit assembly
//
// Includes: bottom shell, keyboard cover, PCBs (NVMe, RPi 5, UPS), hinge pair.
// Standalone preview renders the closed bottom unit (open_angle=0).

use <./bottom.scad>;
use <./kb_cover.scad>;
use <./nvme.scad>;
use <./rpi5.scad>;
use <./usv.scad>;
use <./hinge_eeepc.scad>;

module bottom_asm(
    open_angle = 120,
    H_front    = 20,
    H_rear     = 35,
    D_front    = 130,
    pcb_z_nvme = 10,      // NVMe Base Z : floor_t(3) + standoffH(7)
    pcb_z_rpi  = 18.6     // RPi 5 Z     : pcb_z_nvme(10) + nvme_pcb(1.6) + M2.5_spacer(7)
) {
    // ── Shell ────────────────────────────────────────────────────────────────
    bottom();

    // ── Keyboard cover plate ─────────────────────────────────────────────────
    translate([0, 0, H_front])
        kb_cover();

    // ── Pimoroni NVMe Base ───────────────────────────────────────────────────
    translate([139, 132, pcb_z_nvme])
        nvme_base();

    // ── Raspberry Pi 5 ──────────────────────────────────────────────────────
    translate([139, 132, pcb_z_rpi])
        raspberry_pi_5();

    // ── Waveshare UPS 3S ─────────────────────────────────────────────────────
    // Rotated 90°: 93mm along X, 60mm along Y. Outer extent X=6..99, Y=132..192.
    translate([99, 132, pcb_z_nvme])
    rotate([0, 0, 90])
        usv(batteries=true);

    // ── EeePC friction hinge pair ──────────────────────────────────────────
    translate([-41,-30,-8])
eeepc_hinge_split(open_angle=open_angle, side="left",  x_pos=60,
                      bar_y=D_front, bar_z=H_rear);
translate([41,-30,-8])
    eeepc_hinge_split(open_angle=open_angle, side="right", x_pos=166,
                      bar_y=D_front, bar_z=H_rear);
}

bottom_asm();
