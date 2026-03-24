// Piputer — bottom enclosure shell (stepped / Ceres-1 profile)
//
// Profile (side view, Y axis):
//   Front zone  Y=0..130,  H_front=20  — keyboard area (open top, closed by kb_cover)
//   Rear zone   Y=130..200, H_rear=35  — electronics area (open top, closed by lid when open)
//   Constraint: H_front(20) + H_lid(15) = H_rear(35) → flat top when closed
//
// Hinge axis: Y=130, Z=35 (barrel at step-wall top-outer corner)
//
// RPi/NVMe standoffs: OD=8mm, H=7mm, blind M2.5 heat-insert hole Ø3.5mm × 5mm from top

use <./piMount.scad>;
use <./usvMount.scad>;
use <./kbMount.scad>;


eps = 0.01;

module bottom(
    W=226, D=200, H_front=20, H_rear=35, wall=2, floor_t=3,
    D_front=130,   // depth of keyboard zone

    // RPi5 / NVMe: board left/front corner in outer coords (rear zone inner front face = D_front+wall)
    rpi_ox=139, rpi_oy=132,

    // Waveshare UPS 3S: rotated 90° → 93mm X, 60mm Y (rear zone)
    usv_ox=6,   usv_oy=132,

    // MC-8017 keyboard: 220×118mm (front zone)
    kb_ox=3,    kb_oy=2
) {
    D_rear      = D - D_front;   // = 70
    standoffH   = 7;
    standoffD   = 8;
    insertD     = 3.5;   // M2.5
    insertDepth = 5;
    

    difference() {
        union() {
            // Front block (keyboard zone)
            cube([W, D_front, H_front]);
            // Rear block (electronics zone)
            translate([0, D_front, 0])
                cube([W, D_rear, H_rear]);
}

        // ── Hollow interior ──────────────────────────────────────────────────

        // Front zone interior (open top at Z=H_front, no wall at Y=D_front)
        translate([wall, wall, floor_t])
            cube([W - 2*wall, D_front - wall, H_front - floor_t]);

        // Rear zone interior (open top at Z=H_rear, no front wall needed)
        translate([wall, D_front, floor_t])
            cube([W - 2*wall, D_rear - wall, H_rear - floor_t]);

        // ── Right-wall RPi5 port cutouts ─────────────────────────────────────
        // Ethernet RJ45: Y 121..138, Z 18..34 → 17mm × 16mm
        translate([W - wall - eps, 121, 18])
            cube([wall + 2*eps, 17, 16]);
        // USB-A × 2 merged slot: Y 137..169, Z 18..33 → 32mm × 15mm
        translate([W - wall - eps, 137, 18])
            cube([wall + 2*eps, 32, 15]);

        // NVMe Base PCB overhang clearance (2.5mm past right inner wall, Z=10..11.6)
        translate([W - wall - eps, rpi_oy, 10 - eps])
            cube([wall + 2*eps, 56, 1.6 + 2*eps]);

        // ── Ear heat-insert holes ─────────────────────────────────────────────
        translate([W/2,          -(earSz/2),              H_front - insertDepth])
            cylinder(h=insertDepth + eps, d=insertD);
        translate([-(earSz/2),   D_front/2,               H_front - insertDepth])
            cylinder(h=insertDepth + eps, d=insertD);
        translate([W+(earSz/2),  D_front/2,               H_front - insertDepth])
            cylinder(h=insertDepth + eps, d=insertD);
    }

    // ── PCB standoffs ──────────────────────────────────────────────────────────

    // RPi5 / NVMe Base: HAT holes at [3.5, 3.5] from board left/front edge, spacing 58×49mm
    translate([rpi_ox + 3.5, rpi_oy + 3.5, floor_t])
        pi_mounts(z0=0, insertD=3.5, insertDepth=5);

    // Waveshare UPS 3S: corner holes 3mm from board edge, spacing 87×54mm
    translate([usv_ox + 3, usv_oy + 3, floor_t])
        usv_mounts(z0=0, insertD=3.5, insertDepth=5);



// splitter and hinge mounts
translate([20,70,2]){
color("red"){
cube([10,50,20]);
}}
translate([190,70,2]){
color("red"){
cube([10,50,20]);
}}
translate([2,110,2]){
color("red"){
cube([220,10,20]);
}}

}


bottom();
