include <BOSL2/std.scad>

$slop = 0.075;
$fn = 90;

// bar_ir = 18/2;
// bar_or = 24/2;

cut_r = 4; // (d=14 -3mm depth of cut = 14/2 - 3 = 4)
ir = 3.1;
r1 = 14/2;
r2 = 24/2;
r3 = 30/2;
h1 = 2;
h2 = 4; // should be able  to squeeze inside of excess grip length. this prolly only works on left side
h3 = 4;

// #chamfer_everything
diff() cyl(h2, r2, chamfer2=0.2, chamfer1=-0.2) {
  attach(TOP, BOTTOM) {
    cyl(h1, r1, chamfer2=0.2, chamfer1=-0.2);
    tag("remove") xmove(r1 + cut_r) cuboid(size=[r1*2, r1*2, h1]);
  }
  attach(BOTTOM, TOP) cyl(h3, r3, chamfer=0.2) {
    tag("remove") attach(TOP, TOP, overlap=h3) cyl(h1+h2+h3,ir);
  }
}

