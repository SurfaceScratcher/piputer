// bottomcase
use <./piMount.scad>;
use <./usvMount.scad>;


thickness=2;

module top(){
difference(){
translate([0,100,15])
cube([240,100,20]);



}
difference(){

cube([240,200,15]);
translate([thickness,thickness,-2*thickness])
cube([240-(2*thickness),200-(2*thickness),15]);
translate([thickness,100 + thickness,-2*thickness])
cube([240-(2*thickness),100-(2*thickness),40]);
}

}

top();


