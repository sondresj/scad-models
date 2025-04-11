include <BOSL2/std.scad>
include <./bar_end_adapter.scad>
include <./mirror_plug.scad>

$slop = 0.075;

d_mirr_end = 160; // todo: measure
t=1.6;
t2=8;

diff()
cuboid([t2, 40, 17], chamfer=4, except=BACK) {
  attach(LEFT, BOT, align=FRONT, shiftout=8)
  bar_end_adapter(16, false);

  // TODO: Use path_extrude instead
  attach(BACK, FRONT, align=RIGHT)
  yrot(10)
  cuboid([t2, 40, 17], chamfer=4, except=[FRONT, BACK+LEFT])
  attach(BACK, FRONT, align=RIGHT)
  yrot(80)
  cuboid([t2, 100, 17], chamfer=4, except=[FRONT+LEFT]);

  //attach(BACK, BACK)
  deflector();
}

module deflector(orient=UP, spin=0, anchor=CENTER){
  module shape() {
    intersect("i") 
    //cylindrical_extrude(ir = 40, or = 42, spin = spin-180, orient = orient)
    prismoid(
      [75, 100],
      [50, 100],
      h=25,
      shift=[-40,0],
      orient=orient,
      spin=spin,
      anchor=anchor
    ){
      tag("r")
      edge_profile([BOT+RIGHT], excess=30)
      mask2d_chamfer(30, angle=60, excess=.1);

      tag("i")
      xscale(3)
      zscale(1.5)
      spheroid(r=25, style="icosa", $fn=10, anchor=anchor, orient=orient, spin=spin);
    }
  }

  //top_half(z=-10)
  //back_half()
  diff("r") {
    shape();
    // scale([.9,.9,.9])
    // tag("r") shape();
    // children();
  }
}
