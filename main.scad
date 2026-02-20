
use <./displayMount.scad>;

use <./top.scad>;
use <./bottom.scad>;
use <./display.scad>;

bottom();

translate([0,0,10])
top();
display_mounts();

translate([0,0,50])
lcd();
