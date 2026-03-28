include <./params.scad>
use <./bottom_asm.scad>;
use <./display_asm.scad>;

// Open angle: 0 = closed, 120 = typical laptop open
open_angle = 120;

// ── Bottom unit ────────────────────────────────────────────────────────────
bottom_asm(open_angle=open_angle, barrel_z=barrel_z);

// ── Display lid ────────────────────────────────────────────────────────────
//
// Assembly logic:
//   mirror([0,0,1]) flips lid so Z=H (bezel) faces down (toward keyboard) when closed.
//   translate([0,-D_front,bz_local]) moves the mirrored barrel to the origin.
//   rotate([-open_angle,0,0]) opens the lid around the barrel axis.
//   translate([0,D_front,barrel_z]) restores barrel to world (Y=130, Z=30).
//
// Verification (closed, open_angle=0):
//   Barrel (top.scad Z=8) -> mirror Z=-8 -> translate([0,0,8]): Z=0
//     -> rotate(0) -> translate([0,130,30]): Z=30
//   Bezel (top.scad Z=15) -> mirror Z=-15 -> translate([0,0,8]): Z=-7
//     -> translate([0,130,30]): Z=23 (on kb_cover)
//   Back face (top.scad Z=0) -> mirror Z=0 -> translate([0,0,8]): Z=8
//     -> translate([0,130,30]): Z=38 (3 mm above H_rear — hinge gap)

translate([0, D_front, barrel_z])
rotate([-open_angle, 0, 0])
translate([0, -D_front, bz_local])
mirror([0, 0, 1])
    display_asm(back_t=back_t);
