// Piputer — shared parametric constants
//
// Include (not use) this file in every .scad that needs these values:
//   include <./params.scad>
//
// OpenSCAD scoping: module parameter defaults override these globals
// inside the module body, which is the desired behaviour for optional overrides.

// ── Enclosure envelope ───────────────────────────────────────────────────────
W        = 226;     // enclosure width (X)
D        = 220;     // enclosure total depth (Y)
D_front  = 130;     // keyboard zone depth
D_clearance=20;      // space between electronicszone and lid
D_rear   = D - D_front-D_clearance;  // = 70, electronics zone depth
H_front  = 20;      // front zone height (Z)
H_rear   = 35;      // rear zone height (Z)
wall     = 2;       // shell wall thickness
floor_t  = 3;       // floor thickness

// ── Keyboard cover ───────────────────────────────────────────────────────────
kb_t     = 3;       // keyboard cover plate thickness

// ── Display lid ──────────────────────────────────────────────────────────────
back_t   = 5;       // display back plate thickness (top_cover)
bezel_t  = 3;       // display bezel thickness
lid_H    = 15;      // display lid total height

// ── Hinge geometry ───────────────────────────────────────────────────────────
thickness        = 1.5;     // arm/plate thickness (spring strip, 1.5mm min for FDM)
width            = 7.4;     // arm/barrel width
interleave_gap   = 4;       // gap between pin halves
bend_angle       = 70;      // spring-strip bend angle (degrees)
hinge_rise       = 7;       // barrel height above mount plate
barrel_z         = H_front + kb_t + hinge_rise;  // = 30

// Base-side mount plate length
plate_len        = 29.6;

// Lid-side mount plate length
lid_plate_len    = 22;

// Base-side arm length (derived: barrel sits exactly hinge_rise above mount plate)
arm_len = (hinge_rise + cos(bend_angle) * width/2) / sin(bend_angle);

// Barrel-axis offsets from bottom_mount() placement origin
barrel_y_off = sin(bend_angle) * width/2 + cos(bend_angle) * arm_len;
barrel_z_off = sin(bend_angle) * arm_len - cos(bend_angle) * width/2;

// Barrel Z in top.scad local coords (inside lid interior)
bz_local = 8;

// Hinge X positions (world coords, left inner edge)
hinge_left_x  = W-10;
hinge_right_x = 10;

// ── Hinge pin geometry ───────────────────────────────────────────────────────
pin_d_large  = width;
pin_d_small  = width / 2;
pin_h_full   = 4 * thickness;
pin_h_half   = interleave_gap / 2;

// ── Hinge screw holes ────────────────────────────────────────────────────────
hole_d         = 2.5;     // hole diameter
hole_margin    = 3;       // margin: edge to first/last hole
hole_pitch     = 4;       // hole spacing
holes_base     = 5;       // holes in base mount plate
holes_lid      = 4;       // holes in lid mount plate

// ── PCB placement (outer coords) ───────────────────────────────────────────
rpi_ox  = 139;    rpi_oy = 152;    // RPi5 / NVMe Base: board left/front corner
usv_ox  = 6;      usv_oy = 152;    // Waveshare UPS 3S
kb_ox   = 3;      kb_oy  = 2;      // MC-8017 keyboard

// PCB Z positions
pcb_z_nvme = floor_t + 7;           // = 10  (floor + standoff height)
pcb_z_rpi  = pcb_z_nvme + 1.6 + 7;  // = 18.6 (NVMe PCB + spacer)

// ── Hardware: heat-set inserts ───────────────────────────────────────────────
ins_d_m25     = 3.5;    // M2.5 heat-insert bore diameter
ins_depth_m25 = 5;      // M2.5 insert depth
clr_d_m25     = 2.7;    // M2.5 clearance hole diameter
ins_d_m3      = 4.5;    // M3 heat-insert bore (display PCB lash screws only)
ins_depth_m3  = 4;      // M3 insert depth

// ── Standoffs ────────────────────────────────────────────────────────────────
standoff_h = 7;      // standoff height
standoff_d = 8;      // standoff outer diameter

// ── PCB mount hole spacings ──────────────────────────────────────────────────
pi_hole_dx  = 58;    pi_hole_dy  = 49;    // RPi5 / NVMe Base (HAT pattern)
usv_hole_dx = 87;    usv_hole_dy = 54;    // Waveshare UPS 3S
kb_hole_dx  = 212;   kb_hole_dy  = 110;   // MC-8017 keyboard

// ── Manifold fix ─────────────────────────────────────────────────────────────
eps = 0.01;
