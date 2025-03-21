include <BOSL2/std.scad>
include <BOSL2/cubetruss.scad>
include <BOSL2/hinges.scad>

$slop = 0.075;
$fn = 90;

// rc-car measurements

pin_r = 2.5 - $slop;
pin_h = 8;
// screw fixing pin to suspension subframe
pin_s_z = 2.5;
pin_s_r = 1;
pin_s_l = pin_r*2 + 0.2;
pin_dist_w = 25 - $slop*2; // spacing is almost 25mm, but not quite
pin_dist_l = 177.5;

wheel_dist_l = pin_dist_l;
wheel_dist_w = 138;
wheel_r = 40;

subf_w = 98.34;
subf_l = 217.5;
subf_h = 35;
pin_subf_z = 75;

// distance relative to rear pins
engine_fwd = 38;
radio_fwd = 38;
switch_fwd = 116;
servo_fwd = 80;
serwo_right = 8; // clearance required from edge of subframe

// parts measurements

cs = 30;
frame_len = cubetruss_dist(4,0,cs); // 108;

frame() {
   attach([LEFT, RIGHT], BACK, shiftout=8) side_frame();

   attach([FRONT, BACK], BACK, overlap=4) subframe_anchor();

   attach(TOP, BACK, shiftout=8) 
   fwd(cubetruss_dist(2,0,cs))
   hood();

   attach(TOP, BOT, shiftout=8)
   back(cubetruss_dist(2,0,cs))
   roll_cage();

   attach(TOP, BOT, shiftout=8) spoiler();
}
if ($preview) {
  color("grey", .5) down(47) rc_car();
}

module frame() {
  echo(frame_len);
  cubetruss(size=cs, bracing=false, extents=[1,4,1]) children();
}

module subframe_anchor() {
  shiftout = pin_dist_l/2 - cs/2 - frame_len/2 + 2;

  cubetruss_support(size = cs) {
    attach(TOP, BOT, overlap=pin_h+pin_r)
    fwd(shiftout)
    xcopies(pin_dist_w)
    diff()
    cyl(h = pin_h, r = pin_r, rounding1 = pin_r/1.5)
    attach(FRONT, BOT, align=TOP, inside=true)
    fwd(pin_s_z + pin_s_r)
    cyl(h = pin_s_l, r = pin_s_r);

    attach(TOP, BOT, overlap=pin_r*2)
    xcopies(pin_dist_w)
    fwd(shiftout/2 + 14/2)
    cuboid(
      size=[pin_r*2.1, 18, pin_r*2],
      rounding=pin_r,
      edges=[FRONT+TOP, FRONT+LEFT, FRONT+RIGHT]
    );
  }
}

module side_frame() {
  zrot(180)
  cubetruss_support(extents=[2,1,1], size=cs)
  attach(BACK, FRONT, overlap=$cubetruss_clip_thickness) {
    cubetruss_uclip(dual=false, size=cs);
    xcopies(cubetruss_dist(2,0,cs)) cubetruss_uclip(dual=false, size=cs);
  }
  // cubetruss_clip(extents=2, size=cs);
}

module hood() {
  l=cubetruss_dist(4,0,cs) + 2*$cubetruss_strut_size;
  w=cs;
  diff() panel(l, w+20, w+10, 10) {

    attach(LEFT, RIGHT, shiftout=12)
    yrot(-30)
    panel(l/2, w*2/3, w*2/5, 4)
    attach(RIGHT, BOT, spin=90, overlap=2)
    down(7)
    xrot(90)
    snap_lock(thick=1,foldangle=60);

    attach(RIGHT, LEFT, shiftout=12)
    yrot(30)
    panel(l/2, w*2/3, w*2/5, 4)
    attach(LEFT, BOT, spin=-90, overlap=2)
    down(7)
    xrot(90)
    snap_lock(thick=1,foldangle=60);

    attach(LEFT, BOT, spin=90, overlap=10)
    xrot(-90)
    down(1)
    right(10)
    snap_socket(thick=2, foldangle=60);

    attach(RIGHT, BOT, spin=-90, overlap=10)
    xrot(-90)
    down(1)
    left(10)
    snap_socket(thick=2, foldangle=60);

    attach(BACK, FRONT, spin=90, overlap=0.1)
    xcopies(cubetruss_dist(2,0,cs))
    right(l/5)
    cubetruss_uclip(dual=false, size=cs);
  }
}

module panel(l, w1, w2, c, anchor=CENTER, spin=0, orient=UP) {
  t = 2;
  prismoid(
    [w2, t],
    [w1, t+l*tan(2)],
    h=l,
    anchor=anchor,
    spin=spin,
    orient=orient
  ) {
    edge_profile([TOP+LEFT, TOP+RIGHT, BOT+LEFT, BOT+RIGHT], excess=1) 
    tag("remove") mask2d_chamfer(y=c, mask_angle=100, angle=35, excess=1);
    children();
  }
  // attachable(
  //   size=[w1,t,l-c*2],
  //   size2=[w2,t],
  //   axis=FRONT,
  //   anchor,
  //   spin,
  //   orient
  // ) 
  // {
  //   chain_hull() { 
  //     cuboid([w2, l, t], chamfer=c, edges=[FRONT+LEFT, FRONT+RIGHT]);
  //     move([0,l/2-c,-1/2])
  //     xrot_copies([0,3], cp=[0,-l,0])
  //     cuboid([w1, c*2, 1], chamfer=c, edges=[BACK+LEFT, BACK+RIGHT]);
  //   }
  //   children();
  // }
}

module roll_cage() {
  l = cubetruss_dist(2,0,cs) + $cubetruss_strut_size;

  intersect("mask", "frame")
  cubetruss([1,2,1], bracing=false, size=cs){

    attach(BOT, BOT, inside=true)
    tag("mask")
    cuboid(
      [cs, l, $cubetruss_strut_size],
      chamfer=6,
      edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]
    );

    tag("frame")
    attach(TOP, BOT, overlap=cs-$cubetruss_strut_size)
    diff() {

      o=$cubetruss_strut_size;
      shift=[0,cs/2-o/2];

      prismoid([cs,l], [cs*3/4, cs], h=cs/2, chamfer=6, shift=shift)
      {
        attach(BACK, BOT, align=TOP, overlap=10)
        prismoid([cs*3/4, o], [cs, o/2], h=10 + o, shift=[0, o/4], chamfer=1);
        attach(BACK, BOT, align=TOP, overlap=20-o*2)
        back(6)
        prismoid([cs/4, o*4], [cs/4, o/2], h=20, shift=[0, o/4], chamfer=1);

        tag("remove") {
          attach(BACK, TOP, align=TOP, inside=true)
          xrot(-23)
          down(10)
          yscale(1.5)
          cyl($fn=6, h=40, r=cs/8);


          attach(BOT, BOT, align=BACK, inside=true)
          fwd(o*1.5)
          diff("r","k")
          prismoid([cs+o, l-o*3], [cs+o, cs-o*1.3], h=cs/2-o, shift=[0,cs/2-o*1.4]) {
            edge_profile([BOT+FRONT], excess=10) 
            tag("r") mask2d_chamfer(5, angle=1, mask_angle=30, excess=1);

            edge_profile([TOP+FRONT], excess=10) 
            tag("r") mask2d_chamfer(18, mask_angle=150, excess=1);

            edge_profile([TOP+BACK], excess=1) 
            tag("r") mask2d_chamfer(9, mask_angle=90, excess=1);
          }

          attach(BOT, BOT, align=BACK, inside=true)
          back(.1)
          diff("r","k")
          prismoid([cs-o*3, l+o], [cs*3/4-o*2.5, l+o], h=cs/2-o*3/2)
          edge_profile([TOP+RIGHT, TOP+LEFT], excess=1) 
          tag("r") mask2d_chamfer(6, mask_angle=110, excess=1);
        }
      }
    }
  }

  ycopies(cubetruss_dist(1,0,cs), n=2)
  cubetruss_uclip(size=cs);

}

module spoiler() {
}

module rc_car() {
  wheel_l=40;

  ycopies(pin_dist_l)
  xcopies(pin_dist_w)
  tube(or=pin_r+1, ir=pin_r, h=56, anchor=BOT);

  cuboid(
    size=[subf_w, subf_l, subf_h],
    chamfer=25,
    edges=[FRONT+LEFT, FRONT+RIGHT, BACK+LEFT, BACK+RIGHT]
  );

  xcopies(wheel_dist_w + wheel_l)
  ycopies(wheel_dist_l)
  yrot(90)
  cyl(r=wheel_r -1, h=40, rounding=2);

  ycopies(wheel_dist_l)
  down(subf_h/2)
  prismoid(size1=[120,36], size2=[60,10], h=pin_subf_z);
}
