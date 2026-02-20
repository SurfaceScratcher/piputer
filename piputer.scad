// ---------- Globale Basis-Parameter ----------

eps = 0.01;                  // kleiner Überstand für stabile CSG-Operationen

// --- Pi-Mount ---
pi_mountDistX    = 58;
pi_mountDistY    = 48;
pi_mountHeight   = 5;
pi_mountD        = 4;

// --- M3 Heat-Insert für Display-Mounts ---
heatInsert_outerD   = 5;      // Außendurchmesser Insert (z.B. Voron-Style)
heatInsert_length   = 4;      // Länge Insert
heatInsert_holeD    = 4.6;    // Bohrungsdurchmesser (4.5–4.7 üblich)
heatInsert_extraZ   = 1.5;    // zusätzl. Tiefe unter Insert (Material darunter)

// Mount-Layout für Display (Abstand der Befestigungs­löcher des Displays)
display_mountDistX   = 150;
display_mountDistY   = 122;

// --- Display (Frontausschnitt) ---
// Verhältnis, wie weit oben das Fenster sitzen soll (0..1)
lcd_window_pos   = 0.73;

// Glasbereich (PCB / Glas)
displayGlassCutoutX  = 166;
displayGlassCutoutY  = 110;
displayGlassHeight   = 2;

// Sichtbereich (Fenster)
displayViewCutoutX   = 155;
displayViewCutoutY   = 88;
displayViewMarginY   = 5;    // Abstand Fenster oben zum Glasrand

// --- Case (Top) ---
case_top_x        = 230;
case_top_y        = 260;
case_top_height   = 5;
case_wall_thick   = 3;
case_inner_offsetZ = 5;      // Start der Innenaushöhlung in Z

// --- Keyboard module pi_mounts(
    distX = pi_mountDistX,
    distY = pi_mountDistY,
    h     = pi_mountHeight,
    d     = pi_mountD
) {
    mount4_holes(distX, distY, d, h, 0);
}---
kbCutoutX         = 206;
kbCutoutY         = 79;
kbCutoutOffsetY   = 9;

// Kleine Bohrungspositionen im Topcase
smallHoleZDepth   = 100;
smallHoleD        = 2;

smallHole1_offset = [104,    6];
smallHole2_offset = [104+200,6];
smallHole3_offset = [10,     kbCutoutY + 25];
smallHole4_offset = [10+200, kbCutoutY + 25];
smallHole5_offset = [10+200+184, kbCutoutY + 25];


// ---------- Mount-Basis-Module ----------

// Standoff-Pads (positives Material)
module mount4_pads(distX, distY, padD, padH, z0=0) {
    translate([0,      0,      z0]) cylinder(padH, d = padD, center = false);
    translate([distX,  0,      z0]) cylinder(padH, d = padD, center = false);
    translate([0,      distY,  z0]) cylinder(padH, d = padD, center = false);
    translate([distX,  distY,  z0]) cylinder(padH, d = padD, center = false);
}

// Bohrungen (negativer Raum)
module mount4_holes(distX, distY, holeD, depth, z0=0) {
    h = depth + 2*eps;
    translate([0,      0,      z0 - eps]) cylinder(h, d = holeD, center = false);
    translate([distX,  0,      z0 - eps]) cylinder(h, d = holeD, center = false);
    translate([0,      distY,  z0 - eps]) cylinder(h, d = holeD, center = false);
    translate([distX,  distY,  z0 - eps]) cylinder(h, d = holeD, center = false);
}


// gewünschte Restwandstärke unter dem Glas
glass_rest = 0.3;

// ---------- LCD-Glas + Fenster-Ausschnitt ----------
module lcd_cutout(outerX, outerY, viewX, viewY, viewMarginY, depth) {
    // Wandstärke oben (Case-Deckel)
    wall = case_top_height;          // = 5 bei dir

    // 1) Glas-/Platinenöffnung:
    //    geht NICHT komplett durch, lässt 'glass_rest' Material stehen
    //    => Cutout-Tiefe = wall - glass_rest
    translate([0, 0, wall - (wall - glass_rest) - eps])    // start kurz unter Außenfläche
        cube([
            outerX,
            outerY,
            (wall - glass_rest) + 2*eps
        ]);

    // 2) Sichtfenster:
    //    muss komplett durch die Wand durch
    //    => Tiefe >= wall
    translate([
        (outerX - viewX) / 2,
        outerY - viewY - viewMarginY,
        -eps              // von leicht außerhalb nach innen schneiden
    ])
        cube([
            viewX,
            viewY,
            wall + depth + 2*eps   // sicher durch Deckel + etwas Reserve
        ]);
}



// ---------- Keyboard-Cutout ----------

module keyboard_cutout(case_x, kbX, kbY, offsetY, depth) {
    translate([
        (case_x - kbX) / 2,
        offsetY,
        -eps
    ])
        cube([kbX, kbY, depth + 2*eps]);
}


// ---------- kleine Bohrungen ----------

module small_holes(case_x, kbX, z0, depth, d, offsets) {
    for (p = offsets) {
        translate([
            (case_x - kbX + p[0]) / 2,
            p[1],
            z0 - eps
        ])
            cylinder(depth + 2*eps, d = d, center = false);
    }
}


// ---------- Display-Mount (M3 Heat-Insert) ----------
//
// Display-Mounts werden relativ zum Display-Glas-Ausschnitt positioniert:
// - X: zentriert unter dem Glas-Ausschnitt
// - Y: z.B. direkt hinter der Glasfläche (PCB-Ebene)

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



// ---------- Pi-Mount (Schraub-Bohrungen) ----------

module pi_mounts(
    distX = pi_mountDistX,
    distY = pi_mountDistY,
    h     = pi_mountHeight,
    d     = pi_mountD
) {
    mount4_holes(distX, distY, d, h, 0);
}


// ---------- Topcase inkl. Display-Ausschnitt ----------

module case_top(
    size     = [case_top_x, case_top_y, case_top_height],
    wall_th  = case_wall_thick,
    innerZ0  = case_inner_offsetZ,
    kbX      = kbCutoutX,
    kbY      = kbCutoutY,
    kbOffY   = kbCutoutOffsetY,
    lcdPos   = lcd_window_pos,
    glassX   = displayGlassCutoutX,
    glassY   = displayGlassCutoutY,
    glassH   = displayGlassHeight,
    viewX    = displayViewCutoutX,
    viewY    = displayViewCutoutY,
    viewMarginY = displayViewMarginY
) {
    case_x = size[0];
    case_y = size[1];
    case_h = size[2];

    difference() {
        cube([case_x, case_y, case_h + 10]);

        // Innenaushöhlung
        translate([wall_th, wall_th, innerZ0 - eps])
            cube([
                case_x - 2*wall_th,
                case_y - 2*wall_th,
                case_h + 11 + 2*eps
            ]);

        // Tastatur-Ausschnitt
        keyboard_cutout(case_x, kbX, kbY, kbOffY, smallHoleZDepth);

        // Kleine Bohrungen
        small_holes(
            case_x,
            kbX,
            -2,
            smallHoleZDepth,
            smallHoleD,
            [
                smallHole1_offset,
                smallHole2_offset,
                smallHole3_offset,
                smallHole4_offset,
                smallHole5_offset
            ]
        );

        // LCD-Ausschnitt: X mittig, Y je nach lcdPos in der Front
        lcd_x = (case_x - glassX) / 2;
        lcd_y = case_y * lcdPos - glassY / 2;
        lcd_z = -eps;

        translate([lcd_x, lcd_y, lcd_z])
            lcd_cutout(
                glassX,
                glassY,
                viewX,
                viewY,
                viewMarginY,
                glassH
            );
    }
}


// ---------- Szenen-Aufbau ----------

// Topcase
case_top();

// Display-Mounts relativ zum Display-Ausschnitt platzieren:
// gleiche lcd_x/lcd_y wie im case_top, aber in Z auf die Innenseite / PCB-Ebene
lcd_x_global = (case_top_x - displayGlassCutoutX) / 2;
lcd_y_global = case_top_y * lcd_window_pos - displayGlassCutoutY / 2;
lcd_z_global = case_top_height; // z.B. direkt auf der Innenseite des Deckels

translate([lcd_x_global, lcd_y_global, lcd_z_global])
    display_mounts();

// Pi-Mounts z.B. links unten im Gehäuseinneren
//translate([pi_mountD/2 + 10, pi_mountD/2 + 10, case_inner_offsetZ])
  //  pi_mounts();
