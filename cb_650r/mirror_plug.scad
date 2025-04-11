include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screws.scad>

$slop = 0.075;
$fn = 90;

// mirror_plug();
module mirror_plug() {
  diff()
  screw(
    "M10x1.25", 
    length=14,
    thread_len=11,
    head="none",
    drive="hex",
    drive_size=5 + $slop*2,
    bevel1=1,
    undersize=2*$slop
  ) {
    attach(TOP, TOP, overlap=3)
    tube(h=3, ir=3, or=8, rounding=0.5);

    // for 3d-printing horizontally, add supports in this slot
    tag("remove")
    attach(FRONT, BACK, align=BOT, overlap=1)
    cuboid([5,5,11], chamfer=1, except=[TOP, BOT]) ;
  };
}
