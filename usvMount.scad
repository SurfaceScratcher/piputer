include <./params.scad>
use <./mounts.scad>;

module usv_mounts(distX=87, distY=54, standoffH=7, standoffD=8,
                  insertD=3.5, insertDepth=5, z0=0)
{
    mount4_standoffs(distX, distY, standoffD, standoffH, insertD, insertDepth, z0);
}
