include <BOSL2/std.scad>

$slop = 0.075;
$fn = 90;

// bar_ir = 18/2;
// bar_or = 24/2;

cut_r = 4; // (d=14 -3mm depth of cut = 14/2 - 3 = 4)
ir = 3.3;
r1 = 14/2;
r2 = 20/2;
h1 = 2;
h2 = 2;
h3 = 8;
wrench_r = 17/2-$slop*2;

diff() cyl(h2, r2, chamfer2=0.5) {
  // center hole
  tag("remove")
  attach(TOP, TOP, overlap=h2+h3)
  cyl(h1+h2+h3+$slop,ir, chamfer1=-0.5);

  // inner bush
  attach(TOP, BOT) {
    cyl(h1, r1, chamfer2=0.5, chamfer1=-0.5);
    tag("remove") up(0.001) xmove(r1 + cut_r) cuboid(size=[r1*2, r1*2, h1]);
  }

  // outer spacer + wrench slot
  attach(BOT, TOP) {
    cyl(h=h3, r=r2);

    #tag("remove")
    down(1)
    xcopies(wrench_r*2+r2*2, n=2)
    cuboid(
      size=[r2*2,r2*2, h3+2],
      chamfer=2,
      edges=[TOP+LEFT, TOP+RIGHT]
    );
  }
}

