use <./bottom.scad>;
use <./top.scad>;
use <./top_cover.scad>;
use <./display.scad>;
use <./rpi5.scad>;
use <./usv.scad>;
use <./nvme.scad>;
use <./kb_cover.scad>;
use <./hinge_eeepc.scad>;

// Open angle: 0 = closed, 120 = typical laptop open
open_angle = 120;

H_top      = 15;    // top shell height (H in top.scad) — display 10mm + bezel 3mm + 2mm
H_front    = 20;    // front zone height (keyboard area)
H_rear     = 35;    // rear zone height (electronics area)
D_front    = 130;   // depth of keyboard / front zone
back_t     =  5;    // back plate thickness
pcb_z_nvme = 10;    // NVMe Base Z: floor_t(3) + standoffH(7)
pcb_z_rpi  = 18.6;  // RPi 5 Z: pcb_z_nvme(10) + nvme_pcb(1.6) + M2.5_spacer(7)

// Bottom shell (stepped: H_front=20 keyboard + H_rear=35 electronics)
bottom();

// ── Keyboard cover plate ───────────────────────────────────────────────────
// 226×130×3 mm panel closing the open top of the front zone at Z=H_front.
translate([0, 0, H_front])
    kb_cover();

// ── Pimoroni NVMe Base ─────────────────────────────────────────────────────
translate([139, 132, pcb_z_nvme])
    nvme_base();

// ── Raspberry Pi 5 ────────────────────────────────────────────────────────
translate([139, 132, pcb_z_rpi])
    raspberry_pi_5();

// ── Waveshare UPS 3S ──────────────────────────────────────────────────────
// Rotated 90°: 93mm along X, 60mm along Y. Outer extent X=6..99, Y=132..192.
translate([99, 132, pcb_z_nvme])
rotate([0, 0, 90])
    usv(batteries=true);

// ── EeePC friction hinge pair ──────────────────────────────────────────────
//
// Base halves sit on rear-zone step-wall outer edge (world Y=D_front, Z=0).
// Plate extends in −Y (outside the case front face), arc rises to Z≈H_rear.
// Left:  barrel base X=60, base arm X=8..60
// Right: barrel base X=166, base arm X=166..218  (mirror of left)
//
// offset_x≈4, offset_y≈6.5, offset_z≈37.1  (from hinge_eeepc.scad)
// Lid halves are placed in top.scad local coords inside the lid block below:
//   local Z = −(offset_z − H_rear) ≈ −2.1  (just behind lid back plate)

translate([60,  D_front, 0]) bottom_mount();
translate([166, D_front, 0]) mirror([1, 0, 0]) bottom_mount();

// ── Top shell assembly ─────────────────────────────────────────────────────
//
// Lid coordinate convention (top.scad):
//   Z=0  : open back face (display inserted here)
//   Z=H  : bezel face (faces keyboard when closed, user when open)
//
// Assembly logic:
//   mirror([0,0,1]) flips lid so Z=H (bezel) faces down (toward keyboard) when closed.
//   translate([0,-D_front,0]) moves the hinge axis — at top.scad (Y=D=130, Z=0) —
//   to the world origin so rotation is around the correct axis.
//   rotate([-open_angle,0,0]) opens the lid.
//   translate([0,D_front,H_rear]) restores hinge axis to world (Y=130, Z=35).
//
// Verification (closed, open_angle=0):
//   Bezel face (top.scad Y=0, Z=H=15) → after mirror Z=-15 → after translate([0,-130,0]) Y=-130
//   → after rotate unchanged → after translate([0,130,35]): Y=0, Z=20 ✓ (sits on front zone)
//   Back edge (Y=130, Z=0) → mirror Z=0 → translate Y=0 → rotate unchanged → translate: Y=130, Z=35 ✓

translate([0, D_front, H_rear])
rotate([-open_angle, 0, 0])
translate([0, -D_front, 0])
mirror([0, 0, 1]) {
    top();
    translate([0, 0, -back_t]) top_cover();   // back plate at Z=-5..0 → world outside
    translate([23, 2, 0])      lcd();          // display PCB flush with front inner wall

    // Lid halves of EeePC friction hinge pair (top.scad local coords, closed pos).
    // local Z = −(offset_z − H_rear) ≈ −2.1 → world Z≈37.1 (just behind back plate)
    // local Y = D_front + offset_y ≈ 136.5   (offset_y≈6.5 into rear zone)
    translate([64,  136.5, -2.1]) rotate([0, 180, 0]) flange2();
    translate([162, 136.5, -2.1]) mirror([1, 0, 0]) rotate([0, 180, 0]) flange2();
}
