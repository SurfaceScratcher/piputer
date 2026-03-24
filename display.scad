
module display(){
color("black"){
cube([165,109,5.5]);}}

module hdmi(){
color("grey"){
  cube([11,15,4.65]);
translate([0,2,4.65])
    cube([11,11,2]);
}
}

module lash(){
        difference(){
            // UNION: Kombiniere Würfel + Zylinder zur Lasche
            union(){
                cube([8,4.5,1.5]);
                translate([4,0,0])
                cylinder(h=1.5,d=8,center=false);
            }
            // Ziehe das Bohrloch ab
            translate([4,0,0])
            cylinder(h=4,d=3.5,center=true);
        }
    
}

module platine(){

    color("green"){
    // Hauptplatine
    cube([170,114,1.5]);
    
    // Lasche unten links
    translate([0, -4.5, 0])
    lash();
    
    // Lasche unten rechts
    translate([170-8, -4.5, 0])

    lash();
    
    // Lasche oben rechts
    translate([170, 114, 0])
    rotate([0, 0, 180])
    translate([0, -4.5, 0])
    lash();
    
    // Lasche oben links
    translate([8, 114, 0])
    rotate([0, 0, 180])
    translate([0, -4.5, 0])
    lash();
    }
}

module lcd() {
translate([2.5,2.5,2])
display();
// Platine rendern
platine();
translate([170 + 1.5 - 11,4.35,-6.4])
hdmi();
//difference(){
//cube([180,124,10]);
//translate([7.25,7.25,-3])
//cube([165.5, 109.5,80]);

//}
}

lcd();





