// Parameter
laenge_a = 60;
breite= 10;
laenge_b = 20;
dicke = 3;
radius = 15;
winkel = 70;
$fn = 40;


module side_a(){
translate([0,-laenge_a,0])
cube([breite, laenge_a, dicke]);
translate([breite/2,-laenge_a,dicke/2])
cylinder(h=dicke,d=breite,center=true);
}

module side_b(){
cube([breite,laenge_b,dicke]);
translate([breite/2,laenge_b,dicke/2])
cylinder(h=dicke,d=breite,center=true);
}
// Gebogener Teil
module bow() {
rotate_extrude(angle = winkel)
translate([0, 0, 0])
square([breite, dicke]);}

module flange(){
side_a();
rotate([0, 0,winkel])
side_b();
bow();
}

translate([0,-laenge_a,0])
cube([breite,laenge_a,dicke]);

rotate([0,90,0])

flange();