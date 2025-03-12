include <BOSL2/std.scad>

$fn=45;

pin_dist_y = 187;
pin_dist_x = 25;
pin_radius = 6/2;

body_thickness = 2;
body_w = 110;
body_l = pin_dist_y + 46;
body_h = 52;

wheel_dist = 177;
wheel_radius = 43;


// main body
diff() zmove(20) cuboid(size = [body_w, body_l, body_h], chamfer = 15, except=[BOTTOM, FRONT + TOP]) {
  body_hull();
  front();
  back();
  attach(TOP, BOTTOM, overlap=2) roof();
  attach(LEFT, BOTTOM, overlap=24) wheel_arches();
  attach(RIGHT, BOTTOM, overlap=24) wheel_arches();
  attach(LEFT, BOTTOM, overlap=16) side();
  attach(RIGHT, BOTTOM, overlap=16) side();
}

module body_hull() {
  tag("remove") {
    zmove(-body_thickness) cuboid(size = [body_w-body_thickness, body_l-body_thickness, body_h], rounding = 30, except=[BOTTOM]);
    zmove(body_h/2-body_thickness) cuboid(size = [body_w/2,body_l/4, body_thickness*3], chamfer = 15, except=[TOP, BOTTOM]);
    
    // pin cutouts
    recolor("green") {
      x = pin_dist_x / 2;
      y = pin_dist_y / 2;
      z = body_h / 2 - 1;
      h = body_h;
      move([x,y,z]) cyl(h=h, r = pin_radius);
      move([-x,y,z]) cyl(h=h, r = pin_radius);
      move([x,-y,z]) cyl(h=h, r = pin_radius);
      move([-x,-y,z]) cyl(h=h, r = pin_radius);
    }
    // roof connections cutouts
    recolor("yellow") {
      x = body_w / 4;
      y = pin_dist_y / 3;
      z = body_h / 2 - 1;
      h = body_thickness;
      move([x,y,z]) zrot(90) accessory_cutout(h = h);
      move([-x,y,z]) zrot(90) accessory_cutout(h = h);
      move([x,-y,z]) zrot(90) accessory_cutout(h = h); 
      move([-x,-y,z]) zrot(90) accessory_cutout(h = h); 
    }
  }
}

module accessory_cutout(h) {
  w = 5;
  l = 10;
  cuboid([l, w, h]) {
    //attach(TOP, BOTTOM) cuboid([l,w,5]);
    xmove(-l/3) attach(BOTTOM, TOP) cuboid([l*2,w + 1,5]);
  };
}

// grill?
module front(){
  attach(FRONT) {
    ymove(18) text3d("TKJ", orient=UP, center=true);
    ymove(18) rect_tube(h=1, wall=1, size=[30,14], rounding=2);
    tag("remove") ymove(-18) cuboid([body_w, body_h, 20]);
  }
}
// enumber plate?
module back(){
  tag("remove") attach(BACK + TOP, overlap=12) {
    ymove(-body_w/4) accessory_cutout(body_thickness*2.5);
    ymove(body_w/4) accessory_cutout(body_thickness*2.5);
  }
  attach(BACK) ymove(3) {
    text3d("CYA", orient=UP, center=true);
    rect_tube(h=1, wall=1, size=[30,14], rounding=2);
    tag("remove") ymove(-body_h/2.5) cuboid([body_w, body_h/2, 10]);
  }
}
// doors?

module side() {
  rect_tube(h=20, wall=body_thickness*2, size=[80,body_h], chamfer2=14);
}

module wheel_arches() {
  xmove(-wheel_dist/2) cuboid(size=[wheel_radius*2,body_h, 30], chamfer=20, except=[TOP, BOTTOM, FRONT, LEFT]);
  tag("remove") move([-wheel_dist/2 - body_thickness/2, -body_thickness, 0]) cuboid(size=[wheel_radius*2-body_thickness,body_h, 31], chamfer=20, except=[TOP, BOTTOM, FRONT, LEFT]);
  tag("remove") move(v=[-body_l/2-4, body_h/2 + 8, body_w/2 + 20 ]) xrot(90) zrot(-22) chamfer_edge_mask(l=100,chamfer=100);

  xmove(wheel_dist/2) cuboid(size=[wheel_radius*2,body_h, 30], chamfer=20, except=[TOP, BOTTOM, FRONT, RIGHT]);
  tag("remove") move([wheel_dist/2 + body_thickness/2, -body_thickness, 0]) cuboid(size=[wheel_radius*2-body_thickness,body_h, 31], chamfer=20, except=[TOP, BOTTOM, FRONT, RIGHT]);
  tag("remove") move(v=[body_l/2+4, body_h/2 + 8, body_w/2 + 20 ]) xrot(90) zrot(22) chamfer_edge_mask(l=100,chamfer=100);
}
// cutout for switch?
module roof() {}
