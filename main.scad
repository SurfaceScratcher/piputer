use <./bottom_asm.scad>;
use <./display_asm.scad>;

// Open angle: 0 = closed, 120 = typical laptop open
open_angle = 120;

H_rear  = 35;   // rear zone height — hinge axis Z
D_front = 130;  // keyboard zone depth — hinge axis Y
back_t  =  5;   // back plate thickness

// ── Bottom unit ────────────────────────────────────────────────────────────
bottom_asm(open_angle=open_angle);

// ── Display lid ────────────────────────────────────────────────────────────
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

translate([0, D_front-14, H_rear])
rotate([-open_angle, 0, 0])
translate([0, -D_front, 0])
mirror([0, 0, 1])
    display_asm(back_t=back_t);
