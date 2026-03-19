// bottomcase
use <./piMount.scad>;
use <./usvMount.scad>;


thickness=2;
width=215;
length=195;
disp_cover=100;
base_h=25;

module top(){
difference(){
translate([0,0,base_h])
cube([width,disp_cover,20]);



}
difference(){

cube([width,length,base_h]);
translate([thickness,thickness,-2*thickness])
cube([width-(2*thickness),length -(2*thickness),base_h]);
translate([thickness, thickness,-2*thickness])
cube([width-(2*thickness),disp_cover -(2*thickness),base_h + 2*thickness + 20]);
}

}

top();


