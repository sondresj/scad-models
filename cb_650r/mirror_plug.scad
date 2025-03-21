include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screws.scad>

$slop = 0.075;
$fn = 90;

screw("M10x1.25",  length=14, thread_len=12, head="none", drive="hex", drive_size=5, bevel1=1) {
  attach(TOP, TOP, overlap=2) tube(h=2, ir=3, or1=6, or2=7, rounding=0.5);
};

