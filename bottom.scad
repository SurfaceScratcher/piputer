// bottomcase
use <./piMount.scad>;
use <./usvMount.scad>;


thickness=2;

module bottom(){
difference(){

cube([215,195,5]);
translate([thickness,thickness,thickness])
cube([215-(2*thickness),195-(2*thickness),8]);
}
translate([thickness + 20,thickness + 120,thickness])
pi_mounts();

translate([thickness + 140,thickness + 120,thickness])
usv_mounts();
}

bottom();



