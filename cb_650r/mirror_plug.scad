include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screws.scad>

$slop = 0.075;
$fn = 90;
difference() {
     cyl(4, 7, chamfer=0.8) attach(BOT, TOP, overlap=4) 
    screw("M10x1.25", head="none", length= 14, thread_len=12);
     hex_drive_mask(size=6, length=5);
}

