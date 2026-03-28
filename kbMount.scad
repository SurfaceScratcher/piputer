include <./params.scad>
use <./mounts.scad>;

// MC-8017 keyboard standoffs
// Board 220x118mm, assumed corner holes 4mm from edges -> hole spacing 212x110mm
module kb_mounts(distX=212, distY=110, standoffH=7, standoffD=8,
                 insertD=3.5, insertDepth=5, z0=0)
{
    mount4_standoffs(distX, distY, standoffD, standoffH, insertD, insertDepth, z0);
}
