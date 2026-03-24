// ThinkPad-style pivot hinge for Piputer
//
// Principle (matches ThinkPad design):
//   • Barrel visible at the back, sitting at the step-wall top-outer corner.
//   • Base arm : flat plate extending in +Y from barrel → screws into rear-zone top face.
//   • Lid arm  : flat plate extending in −Y from barrel when closed → screws into lid back.
//   • No integral plastic knuckles — hinge is a separate part, fastened to both shells.
//
// Barrel axis : X (left-right).
// Module origin : barrel centre.
//
// Placement in Piputer world (see main.scad):
//   Left  hinge: tp_hinge(open_angle, side="left",  x_pos= 20, bar_y=D_front, bar_z=H_rear)
//   Right hinge: tp_hinge(open_angle, side="right", x_pos=206, bar_y=D_front, bar_z=H_rear)
//
// Verification (closed, open_angle=0):
//   Base arm top face at Z=0 (module) = world Z=H_rear=35 — flush with rear-zone top. ✓
//   Lid arm: extends −Y from barrel → world Y=130..100, inside lid body at Z=35. ✓

eps = 0.01;

BARREL_D   =  8;    // barrel outer Ø
BARREL_L   = 14;    // barrel length, centred on X (±7 mm)
ARM_W      =  8;    // arm width along X
ARM_T      =  2;    // arm thickness (sits below barrel centre, Z=−ARM_T..0)
ARM_L_BASE = 40;    // base arm length in +Y (into rear zone, world Y=130..170)
ARM_L_LID  = 30;    // lid arm length in −Y (into lid body, world Y=100..130 when closed)
HOLE_D     =  2.7;  // M2.5 clearance bore

// Single flat arm with equally-spaced M2.5 clearance holes.
// Top face at Z=0 (barrel centre height); extends in +Y.
module _tp_arm(arm_l, n_holes=3) {
    difference() {
        translate([-ARM_W/2, 0, -ARM_T])
            cube([ARM_W, arm_l, ARM_T]);
        for (i = [1 : n_holes])
            translate([0, arm_l / (n_holes + 1) * i, -ARM_T - eps])
                cylinder(h = ARM_T + 2*eps, d = HOLE_D, $fn = 16);
    }
}

// Complete ThinkPad-style hinge: barrel + base arm + lid arm.
//
// open_angle : 0 = closed, 120 = typical laptop open.
// side       : "left" or "right"  (mirror([1,0,0]) for right side).
// x_pos      : barrel centre X in world coords.
// bar_y/bar_z: barrel world position — defaults match Piputer (D_front=130, H_rear=35).
module tp_hinge(open_angle=0, side="left", x_pos=20,
                bar_y=130, bar_z=35) {
    flip = (side == "right") ? [1, 0, 0] : [0, 0, 0];

    color([0.15, 0.15, 0.15])
    translate([x_pos, bar_y, bar_z])
    mirror(flip) {
        // ── Barrel ────────────────────────────────────────────────────────
        rotate([0, 90, 0])
            cylinder(h = BARREL_L, d = BARREL_D, $fn = 32, center = true);

        // ── Base arm — fixed, lies on rear-zone top face ──────────────────
        // Top face at Z=0 → world Z=H_rear=35, flush with rear-zone top.
        // Extends in +Y → world Y=bar_y..bar_y+ARM_L_BASE (into rear zone).
        _tp_arm(ARM_L_BASE, n_holes = 3);

        // ── Lid arm — rotates with lid around barrel axis ─────────────────
        // rotate([180,0,0]): points arm in −Y (into lid body when closed).
        // rotate([−open_angle,0,0]): opens the lid (matches main.scad transform).
        rotate([-open_angle, 0, 0])
        rotate([180, 0, 0])
            _tp_arm(ARM_L_LID, n_holes = 3);
    }
}


// ── Preview ───────────────────────────────────────────────────────────────
tp_hinge(open_angle = 120, side = "left",  x_pos =  0);
translate([50, 0, 0])
    tp_hinge(open_angle = 120, side = "right", x_pos = 0);
