use <./mounts.scad>;

// MC-8017 keyboard standoffs
// Board 220×118mm, assumed corner holes 4mm from edges → hole spacing 212×110mm
module kb_mounts(distX=212, distY=110, standoffH=7, standoffD=8,
                 insertD=4.5, insertDepth=6, z0=0)
{
    mount4_standoffs(distX, distY, standoffD, standoffH, insertD, insertDepth, z0);
}
