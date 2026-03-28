// Piputer — parametric spring-strip clamshell hinge
//
// Two-piece spring hinge for the Piputer step-wall barrel position:
//   Barrel world position: Y=D_front(130), Z=barrel_z(30)
//   Mount plate rests on keyboard cover at Z=H_front+kb_t(23)
//   Arm bridges hinge_rise = barrel_z - (H_front+kb_t) = 30-23 = 7 mm
//
// BARREL AXIS CONVENTION:
//   The barrel axis runs parallel to X. Both halves share this axis.
//   All rotation of the lid half MUST happen around this axis only.
//   In local coords (bottom_mount origin), the barrel axis is at:
//     (Y, Z) = (barrel_y_off, barrel_z_off)
//   In world coords (assembly), the barrel axis is at:
//     (Y, Z) = (bar_y, bar_z)   e.g. (D_front, barrel_z) = (130, 30)
//
// bottom_mount() — base half: flat plate + arc + arm + pin in +X
//   Mount plate lies at Z=0 in local coords, extends in -Y from origin.
//   Pin extends from X=0 in +X direction.
//
// eeepc_hinge_lid_half() — lid half: flat plate + vertical arm + pin in -X
//   L-bracket (no arc): side_aq flat plate + side_bq vertical arm.
//   Barrel near local origin, pin extends in -X.
//   Interleaves with bottom_mount +X pin.
//
// eeepc_hinge_split() — assembly module for Piputer:
//   bar_y, bar_z = barrel world position (Y=130, Z=30)
//   Mount plate auto-positioned at (bar_y - barrel_y_off, bar_z - barrel_z_off)

include <./params.scad>

// ============================================================
// DERIVED SIZES (from params.scad globals)
// ============================================================

$fn = 40;

offset_x = 4 * thickness;
offset_y = width/2 * (sin(bend_angle) - 1) + arm_len * cos(bend_angle);
offset_z = arm_len * (1 + sin(bend_angle)) - width/2 * cos(bend_angle);

// Validate hole pattern fits in mount plates
base_holes_span = 2 * hole_margin + (holes_base - 1) * hole_pitch;
lid_holes_span  = 2 * hole_margin + (holes_lid  - 1) * hole_pitch;
dummy_base = (base_holes_span > plate_len)     ? echo("WARNING: holes don't fit in base plate!") : 0;
dummy_lid  = (lid_holes_span  > lid_plate_len) ? echo("WARNING: holes don't fit in lid plate!") : 0;


// ============================================================
// PRIMITIVE MODULES
// ============================================================

// Holes centred on width/2, evenly spaced with hole_pitch
module hole_row(count) {
    for (i = [0 : count - 1]) {
        translate([width/2, hole_margin + i * hole_pitch, -0.1])
            cylinder(h = thickness + 0.2, d = hole_d, center = false);
    }
}

// Base mount plate (extends in -Y from origin)
module side_a() {
    translate([0, -plate_len, 0])
        cube([width, plate_len, thickness]);
    translate([width/2, -plate_len, thickness/2])
        cylinder(h=interleave_gap/2, d=width, center=true);
}

// Base arm (extends in +Y, pin at tip)
module side_b() {
    cube([width, arm_len, thickness]);
    // Bearing disc at arm tip (flush with arm, same as lid disc → forms bearing at X=0)
    translate([width/2, arm_len, thickness/2])
        cylinder(h=thickness, d=pin_d_large, center=true);
    // Small pin extends in +Z (becomes +X after flange rotation)
    translate([width/2, arm_len, 2*thickness])
        cylinder(h=pin_h_full, d=pin_d_small, center=true);
}

// Lid mount plate (extends in -Y from origin, with screw holes)
module side_aq() {
    difference() {
        translate([0, -lid_plate_len, 0])
            cube([width, lid_plate_len, thickness]);
        translate([0, -lid_plate_len, 0])
            hole_row(holes_lid);
    }
}

// Lid arm (extends in +Y, pin at tip — same arm_len as base for matching barrel height)
module side_bq() {
    cube([width, arm_len, thickness]);
    // Bearing disc at arm tip
    translate([width/2, arm_len, thickness/2])
        cylinder(h=thickness, d=pin_d_large, center=true);
    // Small pin extends in +Z (becomes -X after lid_half flip)
    translate([width/2, arm_len, 2*thickness])
        cylinder(h=pin_h_half, d=pin_d_small, center=true);
}

// Arc connecting plate and arm
module bow() {
    rotate_extrude(angle=bend_angle)
        square([width, thickness]);
}


// ============================================================
// FLANGE ASSEMBLIES
// ============================================================

// Base-side flange: plate + arc + arm.
// After rotate([0,90,0]), barrel axis is at (Y,Z) = (barrel_y_off, barrel_z_off),
// pin extending along +X from X=0 to X=pin_h_full.
module flange() {
    rotate([0, 90, 0]) {
        side_a();
        rotate([0, 0, bend_angle])
            side_b();
        bow();
    }
}

// Lid-side flange: flat plate (side_aq) + vertical arm (side_bq) — L-bracket, no arc.
// rotate([0,0,90]) on each sub-part orients them so:
//   side_aq → flat plate in XY plane at Z=0
//   side_bq → vertical arm along Z, pin at top
module flange2() {
    rotate([0, 0, 90])
        side_aq();
    rotate([0, 90, 0]) {
        rotate([0, 0, 90])
            side_bq();
    }
}


// ============================================================
// HINGE HALVES
// ============================================================

// Base hinge half: flange + screw-hole mount plate.
// Barrel axis at (Y, Z) = (barrel_y_off, barrel_z_off) in local coords.
// Pin extends along +X.
module bottom_mount() {
    flange();
    difference() {
        translate([0, -plate_len, 0])
            cube([width, plate_len, thickness]);
        translate([0, -plate_len, 0])
            hole_row(holes_base);
    }
}

// Lid hinge half: flange2 repositioned so barrel is near origin, pin in -X.
// Interleaves with bottom_mount +X pin.
// Caller translates to barrel position; mirror([1,0,0]) for right side.
module eeepc_hinge_lid_half() {
    translate([2*thickness, -width/2, arm_len])
        rotate([0, 180, 0])
            flange2();
}


// ============================================================
// ASSEMBLY MODULES
// ============================================================

// Complete hinge preview (base + lid), with adjustable open angle.
// Lid half rotates ONLY around the barrel axis.
//
// open_angle : 0 = closed, 120 = typical open
module eeepc_hinge_asm(open_angle=0) {
    color([0.15, 0.15, 0.15]) {
        // Base half — fixed
        bottom_mount();

        // Lid half — rotates around barrel axis only
        // 1. eeepc_hinge_lid_half() has barrel at (0,0,0) along X
        // 2. rotate([-open_angle,0,0]) rotates around X at origin = barrel axis
        // 3. translate to barrel position in bottom_mount coords
        translate([0, barrel_y_off, barrel_z_off])
        rotate([-open_angle, 0, 0])
            eeepc_hinge_lid_half();
    }
}

// Positioned hinge for the Piputer assembly.
// Base half is fixed; lid half rotates around the barrel axis.
//
// open_angle : 0 = closed, 120 = typical open
// side       : "left" or "right"
// x_pos      : X coordinate of hinge in world coords
// bar_y      : barrel axis Y (world) — D_front = 130
// bar_z      : barrel axis Z (world) — barrel_z = 30
module eeepc_hinge_piputer(open_angle=0, side="left", x_pos=60,
                            bar_y=D_front, bar_z=barrel_z) {
    mount_y = bar_y - barrel_y_off;
    mount_z = bar_z - barrel_z_off;

    color([0.15, 0.15, 0.15]) {
        // Base half — fixed to bottom shell
        translate([x_pos, mount_y, mount_z]) {
            if (side == "right")
                mirror([1, 0, 0]) bottom_mount();
            else
                bottom_mount();
        }

        // Lid half — rotates ONLY around barrel axis
        // Barrel axis is at (x_pos, bar_y, bar_z) in world coords, along X.
        // eeepc_hinge_lid_half() barrel is at local (0,0,0).
        // rotate at origin, then translate to world barrel position.
        translate([x_pos, bar_y, bar_z])
        rotate([-open_angle, 0, 0]) {
            if (side == "right")
                mirror([1, 0, 0]) eeepc_hinge_lid_half();
            else
                eeepc_hinge_lid_half();
        }
    }
}


// Base-side hinge only for the Piputer split assembly.
// Lid-side half belongs in display_asm.scad — it moves with the lid.
//
// bar_y, bar_z = barrel world position.
// Mount plate auto-positioned at bar_y - barrel_y_off, bar_z - barrel_z_off.
module eeepc_hinge_split(side="left", x_pos=60,
                          bar_y=D_front, bar_z=barrel_z) {
    mount_y = bar_y - barrel_y_off;
    mount_z = bar_z - barrel_z_off;

    color([0.15, 0.15, 0.15])
    translate([x_pos, mount_y, mount_z]) {
        if (side == "right")
            mirror([1, 0, 0]) bottom_mount();
        else
            bottom_mount();
    }
}


// ============================================================
// PREVIEW — shows both halves with open_angle
// ============================================================

preview_open_angle = 45;

eeepc_hinge_asm(open_angle=preview_open_angle);
