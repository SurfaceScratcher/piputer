use <./mounts.scad>;

display_mountDistX   = 150;
display_mountDistY   = 122;
displayGlassHeight   = 2;

displayGlassCutoutX  = 166;
displayGlassCutoutY  = 110;
displayGlassHeight   = 2;


heatInsert_outerD   = 5;      // Außendurchmesser Insert (z.B. Voron-Style)
heatInsert_length   = 4;      // Länge Insert
heatInsert_holeD    = 4.6;    // Bohrungsdurchmesser (4.5–4.7 üblich)
heatInsert_extraZ   = 1.5;    // zusätzl. Tiefe unter Insert (Material darunter)



module display_mounts(
 glassX   = displayGlassCutoutX,
    glassY   = displayGlassCutoutY,
    glassH   = displayGlassHeight,
    mountDX  = display_mountDistX,
    mountDY  = display_mountDistY,
    insert_outerD = heatInsert_outerD,
    insert_len    = heatInsert_length,
    insert_holeD  = heatInsert_holeD,
    insert_extra  = heatInsert_extraZ
) {
    padD = insert_outerD + 2;
    padH = glassH;                 // Abstand zur Displayoberfläche
    holeDepth = padH;              // Bohrung durch den Standoff

    // Lokale Geometrie: Pads MIT Bohrung
    translate([glassX/2 - mountDX/2, glassY/2 - mountDY/2, 0])
        difference() {
            // Standoff-Pads
            mount4_pads(mountDX, mountDY, padD, padH, 0);

            // Kernlöcher für Heat-Inserts
            mount4_holes(mountDX, mountDY, insert_holeD, holeDepth, 0);
        }
}