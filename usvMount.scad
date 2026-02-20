echo("USING PI MOUNT FILE");
use <./mounts.scad>;
usv_mountDistX    = 58;
usv_mountDistY    = 48;
usv_mountHeight   = 5;
usv_mountD        = 4;

module usv_mounts(
    distX = usv_mountDistX,
    distY = usv_mountDistY,
    h     = usv_mountHeight,
    d     = usv_mountD
) {
    mount4_holes(distX, distY, d, h, 0);
}
