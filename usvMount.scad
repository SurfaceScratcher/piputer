echo("USING USV MOUNT FILE");
use <./mounts.scad>;

module usv_mounts(distX=87, distY=54, standoffH=7, standoffD=8,
                  insertD=4.5, insertDepth=6, z0=0)
{
    mount4_standoffs(distX, distY, standoffD, standoffH, insertD, insertDepth, z0);
}
