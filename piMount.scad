echo("USING PI MOUNT FILE");
use <./mounts.scad>;
pi_mountDistX    = 58;
pi_mountDistY    = 48;
pi_mountHeight   = 5;
pi_mountD        = 4;

module pi_mounts(
    distX = pi_mountDistX,
    distY = pi_mountDistY,
    h     = pi_mountHeight,
    d     = pi_mountD
) {
    mount4_holes(distX, distY, d, h, 0);
}
