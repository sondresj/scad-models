include <BOSL2/std.scad>
$slop = .125;
$fn = 45;

spacing = 40;

if ($preview) {
  // get the image completely vertical
  yrot(4)
    color("grey", .8)
      ymove(50)
        yrot(-90)
          xrot(90)
            cb650r();

  color("red")
    zmove(10)
      xmove(-30)
        ymove(47)
          yrot(-21, cp=[0, 0, 25]) // 21 degrees it is
            cyl(50, 1);
}

diff() {
  conv_hull(keep="keep") {
    top_trans()
      clamp(12, 4);

    bot_trans()
      clamp(10, 4);
  }

  tag("remove") {
    top_trans()
      clamp_cutout(12, 4);

    bot_trans()
      clamp_cutout(10, 4);

    zmove(-(30))
      cube(90, center=true);
    zmove(42 * 2)
      cube(90, center=true);
  }
}

{
  module clamp(r, t) {
    circle(r=r + t);
    children();
  }

  module bot_trans() {
    yrot(10.5, cp=[0, 0, 25])
      linear_extrude(50)
        ymove(spacing / 2)
          zrot(270 - 45 / 2)
            children();
  }

  module top_trans() {
    yrot(-10.5, cp=[0, 0, 25])
      linear_extrude(50)
        ymove(-spacing / 2)
          zrot(45 / 2 + 45)
            children();
  }

  module clamp_cutout(r, t) {
    ymove(-3)
      tag("remove")
        hull() {
          circle(r=r + $slop);

          ymove(-r)
            circle(r=r - t + $slop);
        }
    children();
  }

  module cb650r() {
    import("cb_650r.stl");
  }
}
