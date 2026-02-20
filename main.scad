
use <./displayMount.scad>;

use <./top.scad>;
use <./bottom.scad>;
use <./display.scad>;

bottom();

translate([0,0,10])
top();
display_mounts();

translate([30,100,50])
rotate([145,0,0])
lcd();
