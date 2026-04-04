// top_cover() — removable back plate for Piputer display lid
//
// Closes the open back face (Z=0) of top.scad.
// Print: outer face (Z=0) on bed.
//
// Z=0 : outer face (visible from back of open lid)
// Z=5 : inner face (presses against frame back opening)
//
// Hardware:
//   4 x M2.5x10 mm screws (back plate -> frame corner bosses)
//   2 x M3x 6 mm screws  (display PCB rear lash bores -> back-plate inserts)
//
// Display lash bore centres (lcd at (23,2) in top.scad coords):
//   Rear holes only: lash offset (4,118.5) and (166,118.5)
//   -> (27, 120.5)  (189, 120.5)
//   Front lash holes fall outside lid footprint with D=130 — omitted.
//
// HDMI relief: lcd() HDMI block at (160.5,4.35,-6.4) -> top.scad (183.5, 6.35)
//   Slot: 12x16 mm through-hole
//
// NOTE: M3 heat-inserts (ins_d=4.5) used here instead of M2.5 elsewhere,
//       because display PCB lash tabs have 3.5mm bores — M3 screw head seats on tab.

include <./params.scad>

module front_plate(W=W, D=D_front, back_t=back_t,
    ins_d=ins_d_m3, ins_depth=ins_depth_m3){
    cube([W,D, back_t]);
    
    translate([W/2,D,14])
    rotate([0,90,0]){
    difference(){
    cylinder(h=W-20,r=14,center=true);
    cylinder(h=W-18,r=9,center=true);
    translate([-21,-18,-120])
    cube([30,20,230]);
    }
    
    }
}

module top_cover(
    W=W, D=D_front+D_clearance, back_t=back_t,
    ins_d=ins_d_m3, ins_depth=ins_depth_m3
) {
    barrel_clr_d = width + 1.6;    // barrel clearance: dia 9 > width 7.4
    difference() {

        front_plate();

        // 4 x M2.5 clearance holes (dia 2.7 mm) — back plate -> frame corner bosses
        for (pos = [[6,6],[220,6],[6,124],[220,124]])
            translate([pos[0], pos[1], -eps])
                cylinder(h=back_t + 2*eps, d=clr_d_m25, $fn=16);

        // 2 x M3 heat-insert holes — rear display PCB lash bores
        for (pos = [[27, 120.5],[189, 120.5]])
            translate([pos[0], pos[1], back_t - ins_depth])
                cylinder(h=ins_depth + eps, d=ins_d, $fn=16);

        // HDMI cable-exit slot (12x16 mm, lcd HDMI block at Y=6.35)
        translate([183.5, 6.35, -eps])
            cube([12, 16, back_t + 2*eps]);

        // ── Barrel clearance notches at back edge ───────────────────────
        // Semicircular notches at Y=D_front for each hinge barrel.
     //   translate([hinge_left_x, D, -eps])
       //     cylinder(h = back_t + 2*eps, d = barrel_clr_d, $fn=24);
       // translate([hinge_right_x, D, -eps])
       //     cylinder(h = back_t + 2*eps, d = barrel_clr_d, $fn=24);
    }
}

top_cover();
