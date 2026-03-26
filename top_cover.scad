// top_cover() — removable back plate for Piputer display lid
//
// Closes the open back face (Z=0) of top.scad.
// Print: outer face (Z=0) on bed.
//
// Z=0 : outer face (visible from back of open lid)
// Z=5 : inner face (presses against frame back opening)
//
// Hardware:
//   4 × M2.5×10 mm screws (back plate → frame corner bosses)
//   2 × M3× 6 mm screws  (display PCB rear lash bores → back-plate inserts)
//
// Display lash bore centres (lcd at (23,2) in top.scad coords):
//   Rear holes only: lash offset (4,118.5) and (166,118.5)
//   → (27, 120.5)  (189, 120.5)
//   Front lash holes fall outside lid footprint with D=130 — omitted.
//
// HDMI relief: lcd() HDMI block at (160.5,4.35,−6.4) → top.scad (183.5, 6.35)
//   Slot: 12×16 mm through-hole

eps = 0.01;

module top_cover(
    W=226, D=130, back_t=5,
    ins_d=4.5, ins_depth=4   // M3 heat-insert for display PCB lash screws
) {
    difference() {
        cube([W, D, back_t]);

        // 4 × M2.5 clearance holes (Ø2.7 mm) — back plate → frame corner bosses
        for (pos = [[6,6],[220,6],[6,124],[220,124]])
            translate([pos[0], pos[1], -eps])
                cylinder(h=back_t + 2*eps, d=2.7, $fn=16);

        // 2 × M3 heat-insert holes — rear display PCB lash bores
        for (pos = [[27, 120.5],[189, 120.5]])
            translate([pos[0], pos[1], back_t - ins_depth])
                cylinder(h=ins_depth + eps, d=ins_d, $fn=16);

        // HDMI cable-exit slot (12×16 mm, lcd HDMI block at Y=6.35)
        translate([183.5, 6.35, -eps])
            cube([12, 16, back_t + 2*eps]);

        // ── I4 fix: Barrel clearance notches at back edge ───────────────
        // Semicircular notches (Ø9 > barrel Ø7.4) at Y=130 for each hinge.
        // Only the half at Y<130 cuts into the cover.
        translate([62, 130, -eps])
            cylinder(h = back_t + 2*eps, d = 9, $fn=24);
        translate([164, 130, -eps])
            cylinder(h = back_t + 2*eps, d = 9, $fn=24);
    }
}

top_cover();
