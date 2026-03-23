// Integral clamshell barrel hinge for Piputer
//
// Geometry (5 knuckles, X-axis aligned):
//   Bottom shell contributes 3 knuckles: B1 X=13..43 | B2 X=98..128 | B3 X=183..213
//   Top shell contributes 2 knuckles:   T1 X=44..97  | T2 X=129..182
//   1mm assembly gap between adjacent knuckles.
//
// Rod: 4mm steel rod or M4 rod, 220mm long (slides in from either end).
//
// wall_y : Y of inner step-wall face the web connects to
// bar_y  : Y of barrel axis centre
// z_axis : Z of barrel axis in caller's coordinate system

eps_h = 0.01;

HINGE_R      = 5;    // knuckle barrel outer radius → Ø10mm
HINGE_BORE_D = 4.5;  // rod bore diameter (4mm rod + 0.25mm clearance/side)

// Internal: single knuckle barrel with rectangular web.
module _hinge_knuckle(xStart, length, z_axis, wall_y, bar_y) {
    y_web = min(wall_y, bar_y);
    y_len = abs(bar_y - wall_y);
    difference() {
        union() {
            translate([xStart, y_web, z_axis - HINGE_R])
                cube([length, y_len, 2 * HINGE_R]);
            translate([xStart, bar_y, z_axis])
                rotate([0, 90, 0])
                    cylinder(h=length, r=HINGE_R, center=false);
        }
        translate([xStart - eps_h, bar_y, z_axis])
            rotate([0, 90, 0])
                cylinder(h=length + 2*eps_h, d=HINGE_BORE_D, center=false);
    }
}

// 3 knuckles for bottom shell step wall.
// z_axis = H_rear = 35 (step-wall top-outer corner).
// wall_y = inner face of step wall = D_front - wall = 128.
// bar_y  = D_front = 130 (barrel at step-wall outer face).
module hinge_bottom(z_axis=35, wall_y=128, bar_y=130) {
    _hinge_knuckle(13,  30, z_axis, wall_y, bar_y);   // B1  X = 13..43
    _hinge_knuckle(98,  30, z_axis, wall_y, bar_y);   // B2  X = 98..128
    _hinge_knuckle(183, 30, z_axis, wall_y, bar_y);   // B3  X = 183..213
}

// 2 knuckles for top shell back edge.
// z_axis = 0 (lid back face in top.scad coords → world Z=35 when closed).
// wall_y / bar_y: same values as hinge_bottom so knuckles interleave.
module hinge_top(z_axis=0, wall_y=128, bar_y=130) {
    _hinge_knuckle(44,  53, z_axis, wall_y, bar_y);   // T1  X = 44..97
    _hinge_knuckle(129, 53, z_axis, wall_y, bar_y);   // T2  X = 129..182
}
