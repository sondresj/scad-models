include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screws.scad>

$slop = 0.075;
$fn = 90;
diff() cyl(3, 7, chamfer=0.5) {
  attach(BOT, TOP, overlap=3) screw("M10x1.25", head="none", length=14, thread_len=11);
  attach(TOP, TOP, inside=true) #tag("remove") hex_drive_mask(size=5, length=5);
}

