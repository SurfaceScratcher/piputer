echo("USING PI MOUNT FILE");
use <./mounts.scad>;

module pi_mounts(distX=58, distY=49, standoffH=7, standoffD=8,
                 insertD=4.5, insertDepth=6, z0=0)
{
    mount4_standoffs(distX, distY, standoffD, standoffH, insertD, insertDepth, z0);
}
