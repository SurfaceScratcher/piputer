// Piputer — display lid assembly
//
// Includes: top shell, back cover plate, LCD panel.
// Standalone preview renders the lid in print orientation (bezel face up).

use <./top.scad>;
use <./top_cover.scad>;
use <./display.scad>;

module display_asm(
    back_t = 5    // back plate thickness
) {
    top();
    //translate([0, 0, -back_t]) top_cover();
    translate([23, 10, 5])      lcd();
}

display_asm();
