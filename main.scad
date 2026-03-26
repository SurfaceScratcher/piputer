use <./bottom_asm.scad>;
use <./display_asm.scad>;

// Open angle: 0 = closed, 120 = typical laptop open
open_angle = 120;

H_rear    = 35;   // rear zone height
D_front   = 130;  // keyboard zone depth — hinge axis Y
kb_t      =  3;   // keyboard cover thickness
back_t    =  5;   // back plate thickness
barrel_z  = 38;   // hinge barrel Z = H_front(20) + kb_t(3) + H_lid(15)
                   // 3 mm above H_rear → visible hinge gap when closed

// ── Bottom unit ────────────────────────────────────────────────────────────
bottom_asm(open_angle=open_angle, barrel_z=barrel_z);

// ── Display lid ────────────────────────────────────────────────────────────
//
// Assembly logic:
//   mirror([0,0,1]) flips lid so Z=H (bezel) faces down (toward keyboard) when closed.
//   translate([0,-D_front,0]) moves the hinge axis — at top.scad (Y=D_front, Z=0) —
//   to the world origin so rotation is around the correct axis.
//   rotate([-open_angle,0,0]) opens the lid.
//   translate([0,D_front,barrel_z]) restores hinge axis to world (Y=130, Z=38).
//
// Verification (closed, open_angle=0):
//   Bezel face (top.scad Z=H=15) → mirror Z=-15 → translate([0,130,38]): Z=23 ✓ (on kb_cover)
//   Back edge (top.scad Y=D_front, Z=0) → mirror Z=0 → translate: Y=130, Z=38 ✓ (barrel)

translate([0, D_front, barrel_z])
rotate([-open_angle, 0, 0])
translate([0, -D_front, 0])
mirror([0, 0, 1])
    display_asm(back_t=back_t);
