// bottomcase
use <./piMount.scad>;
use <./usvMount.scad>;


thickness=2;

module bottom(){
difference(){

cube([240,200,5]);
translate([thickness,thickness,thickness])
cube([240-(2*thickness),200-(2*thickness),8]);
}
translate([thickness + 20,thickness + 120,thickness])
pi_mounts();

translate([thickness + 140,thickness + 120,thickness])
usv_mounts();
}

bottom();



