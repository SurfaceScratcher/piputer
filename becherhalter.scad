h_klein=10;
h_gross=30;
d_klein=66;
d_gross=80;
d_becher=72;



cylinder(h_klein,d=d_klein,true);

translate([0,0,h_klein-1])
 difference()
 {
  cylinder(h_gross,d=d_gross,true);
 translate([0,0,h_klein -8])
 cylinder(h_gross+5,d=d_becher,true);
}