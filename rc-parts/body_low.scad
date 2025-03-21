include <BOSL2/std.scad>
include <BOSL2/hinges.scad>

$fn=45;
pin_dist_y = 178;
pin_dist_x = 25;
pin_radius = 5/2;

wheel_dist = pin_dist_y;
wheel_radius = 40;

max_l = wheel_dist;
max_w = 235;

w = 100;
w2 = 150;
l = 140;
l2 = 240;
h = wheel_radius;
h2 = 73;
d = 2;

// main frame
zrot(180)
diff()
cuboid(
  size = [w, l2, h],
  chamfer = 10,
  except = [BOT, FRONT, BACK]
) {

  // cutout inners
  tag("remove")
  down(1)
  cuboid(
    size = [w-d, l2+1, h-d],
    chamfer = 10+d,
    except = [BOT, FRONT, BACK]
  );

  // cutout suspension
  tag("remove")
  attach(BOT, BOT, inside=true)
  ycopies(wheel_dist,n=2)
  diff("r")
  prismoid(
    [110,36],
    [60, 32],
    h=h2,
    rounding=16
  )
  tag("r")
  edge_profile(
    edges = [TOP+FRONT, TOP+BACK],
    excess=d
  )
  mask2d_roundover(16, mask_angle=$edge_angle);

  // space for steering servo axle
  attach(LEFT, RIGHT, align=BOT+FRONT, overlap=10+d) {
    cuboid(
      size = [20+d, l2/2, h],
      chamfer = 5,
      edges=[TOP+LEFT, BACK + LEFT]
    );
    
    tag("remove")
    xmove(d)
    cuboid(
      size = [20, l2/2-d, h-d],
      chamfer = 5,
      edges=[TOP+LEFT, BACK + LEFT]
    );
  }

  // engine airduct
  back(50)
  attach(LEFT, RIGHT, overlap=20, align=TOP)
  yrot(-20) {
    cuboid(
      size=[20,50,20],
      chamfer=5,
      edges=[LEFT+TOP, LEFT+BOT]
    );
    
    tag("remove")
    fwd(d/2)
    cuboid(
      size=[20-d/2,50+0.1,20-d],
      chamfer=5,
      edges=[LEFT+TOP, LEFT+BOT]
    );
  }

  // left door stuff
  attach(RIGHT, BOT, overlap=18)
  rect_tube(
    h=20,
    wall=d*2,
    size=[l/2,h],
    chamfer2=14
  );

  // antenna throuhole
  attach(TOP, TOP, inside=true, align=LEFT)
  move([-15,-2,0])
  tag("remove")
  cyl(r=3/2, h=10);

  // skirt
  attach(BOT, TOP, overlap=d)
  cuboid([w2, l, d]);
  
  // back wheel arches
  ycopies(wheel_dist, n=2) {
    r = wheel_radius;
    cuboid(
      size = [w2,r*2,r],
      rounding=r,
      edges=[TOP+FRONT, TOP+BACK]
    );

    tag("remove")
    down(d/2)
    cuboid(
      size = [w2+d,r*2-d,r-d],
      rounding=r-d,
      edges=[TOP+FRONT, TOP+BACK]
    );
  }

  // nametag
  tag("remove")
  fwd(50)
  attach(TOP)
  text3d("TKJ", center=true);

  // roof cutouts
  tag("remove")
  attach(TOP, BOT)
  down(d*2) {
    back(45)
    cuboid(
      size=[32-d*2,40,d*3],
      chamfer=d,
      except=[TOP, BOT]
    );
    
    fwd(10)
    cuboid(
      size=[w-40,w/2,d*3],
      chamfer=d,
      except=[TOP, BOT]
    );
  }

  // attaching points
  tag("remove")
  attach(TOP, TOP)
  ycopies(l-d, n=2)
  xcopies(pin_dist_x)
  snap_lock(thick=0, snapdiam=d, layerheight=0.28);

  // perimeter circuolar cut
  tag("remove")
  back(20)
  yscale(1.4)
  xscale(0.6)
  tube(h=h, ir=l2/2, or=l2);

  tag("remove")
  down(h2/2)
  rect_tube(
    h2,
    [max_w*2, max_l*2],
    [max_w, max_l]
  );
}

// TODO: Slice up the modles into separate parts. eg, roof, hooks, sides
