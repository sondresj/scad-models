include <BOSL2/gears.scad>
include <BOSL2/joiners.scad>
include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$slop = 0.1;
$fn = 90;
magnet_d = 10;
magnet_h = 2.2;
clamp_width = 25;
clamp_height = 50;
clamp_depth = 40;
clamp_thickness = 10;
clamp_bolt_d = 15;
spline_bolt_d = 10;
thickness = 10;
padding = 5;
chamfer = 1;

c_clamp_unit() attach(BACK, FRONT) move([ 0, -20, 4 ]) keyboard_plate();

{
    PEG_RADIUS = 1.15;
    PEG_HEIGHT = 1.3;
    PEG_TL = [ 48.1, 96.9, 0 ];
    PEG_TR = [ 78.1, 96.9, 0 ];
    PEG_BR = [ 78.1, 66.9, 0 ];
    PEG_BL = [ 48.1, 66.9, 0 ];
    MAG_TL = [ 38.1, 96.9, 0 ];
    MAG_TR = [ 88.1, 96.9, 0 ];
    MAG_BR = [ 88.1, 66.9, 0 ];
    MAG_BL = [ 38.1, 66.9, 0 ];

    module keyboard_plate()
    {
        pos_pegs = [ [ -15, -15, 0 ], [ 15, -15, 0 ], [ -15, 15, 0 ], [ 15, 15, 0 ] ];
        pos_mags = [ [ -13, -28, 0 ], [ 13, -28, 0 ], [ -13, 28, 0 ], [ 13, 28, 0 ] ];

        // backplate serving as root
        cuboid([ 40, 8, clamp_height + 2 ], chamfer = chamfer)
        {
            // plate under the keyboard
            attach(FRONT, BACK, align = BOT) zmove(-8) cuboid([ 40, 70, 10 ], chamfer = chamfer)
            {
                // cutout for rotational plate
                attach(BOT, BOT, inside = true)
                    tube(h = 5, id = 38 - 4 * $slop, od = 46 + 4 * $slop, rounding1 = -0.25);
                // cutout for dovetail
                attach(BOT, BOT, inside = true, spin = 90) move_copies([ [ 0, 14, 0 ], [ 0, -14, 0 ] ])
                    dovetail("female", w = 10, h = 2, slide = 10);

                // dovetails
                attach(BOT, TOP, spin = 90) move_copies([ [ 0, 34, 0 ], [ 0, -34, 0 ] ])
                    dovetail("male", w = 10, h = 2, slide = 12);

                // rotational tube/plate
                attach(BOT, BOT) zmove(10) tube(h = 5, id = 38, od = 46, rounding = 0.25)
                {
                    // pegs
                    attach(TOP, BOT) move_copies(pos_pegs) cyl(h = PEG_HEIGHT, r = PEG_RADIUS);
                    // cutout for dovetail locks
                    attach(TOP, TOP, inside = true, shiftout = 0.05)
                        cuboid([ 50, 26, 2.2 ], edges = TOP, rounding = -0.25);
                }
                // magnets cutout
                attach(BOT, BOT, inside = true) move_copies(pos_mags)
                    cyl(h = magnet_h, d = magnet_d + 2 * $slop, rounding1 = -0.25);
            }

            // spline thingy that locks the plate at an angle
            attach(FRONT, BOT) ymove(14) hirth(n = 32, rot = true, id = spline_bolt_d, od = clamp_width - 2);

            // hand-nut
            attach(BACK, BOT) move([ 0, -10, 10 ]) cyl(h = 4, d = clamp_width, rounding = chamfer) attach(BOT, TOP)
                cyl(h = 4, d = 18, rounding2 = -2) attach(BOT, TOP, inside = true)
                    threaded_rod(d = spline_bolt_d, l = 8, pitch = 2, internal = true);
        }

        // width = MAG_TR[0] - MAG_TL[0] + padding;
        // height = MAG_TL[1] - MAG_BL[1] + padding;
        // color("teal") translate([ MAG_BL[0] - padding / 2, MAG_BL[1] - padding / 2, 0 ])
        // {
        //     linear_extrude(height = thickness) offset(r = padding) square([ width, height ]);
        // }
    }

    // module keyboard_unit()
    // {
    //     union()
    //     {
    //         pegs();
    //         difference()
    //         {
    //             translate([ 0, 0, -thickness ]) body();
    //             translate([ 0, 0, -magnet_h ]) magnets();
    //         }
    //     }

    //     if ($preview)
    //         keyboard_plate();
    // }

    module c_clamp_unit()
    {

        diff() cuboid([ clamp_width, clamp_thickness, clamp_height ], chamfer = chamfer, orient = DOWN)
        {
            zmove(-6) clamp_spline();
            attach(FRONT, BOT, align = BOT) zmove(-2)
                cuboid([ clamp_width, clamp_thickness, clamp_depth + 2 ], chamfer = chamfer);
            attach(FRONT, TOP, align = TOP) zmove(-2)
                cuboid([ clamp_width, clamp_thickness, clamp_depth + 2 ], chamfer = chamfer)
            {
                zmove(-10) clamp_bolt();
            }
            children();
        }
    }

    module clamp_spline()
    {
        attach(BACK, BOT) hirth(n = 32, id = spline_bolt_d, od = clamp_width - 2);

        attach(FRONT, TOP, inside = true) cyl(d = spline_bolt_d + 2 * $slop, l = 60, spin = -90)
            attach(TOP, TOP, inside = true) cyl(d = 16 + 2 * $slop, h = 3, $fn = 6, spin = 90);

        ymove(-10) attach(FRONT, BOT) threaded_rod(d = spline_bolt_d, bevel1 = true, end_len2 = clamp_thickness * 2,
                                                   l = clamp_thickness * 3, pitch = 2) attach(TOP, BOT)
            cyl(d = 16, h = 3, $fn = 6);
    }

    module clamp_bolt()
    {
        attach(FRONT, TOP, inside = true)
            threaded_rod(d = clamp_bolt_d, l = clamp_thickness, spin = 90, pitch = 2, internal = true);

        attach(BACK, BOT) zmove(10) threaded_rod(d = clamp_bolt_d, l = clamp_height, spin = 90, pitch = 2,
                                                 bevel1 = true, end_len2 = 2, anchor = BOT) position(TOP)
            cyl(d = clamp_bolt_d * 1.5, h = 10, chamfer = 2, anchor = TOP, $fn = 6);

        attach(FRONT, TOP) zmove(3) cyl(d = clamp_width, chamfer = 1, h = 8) attach(TOP, TOP, inside = true)
            threaded_rod(d = clamp_bolt_d, l = 6, pitch = 2, internal = true);
    }

    module voyager_plate()
    {
        color("grey", .3) import("bottom_plate_left.STL");
    }

    module pegs()
    {
        color("green")
        {
            translate(PEG_TL) cylinder(r = PEG_RADIUS, h = PEG_HEIGHT);
            translate(PEG_TR) cylinder(r = PEG_RADIUS, h = PEG_HEIGHT);
            translate(PEG_BR) cylinder(r = PEG_RADIUS, h = PEG_HEIGHT);
            translate(PEG_BL) cylinder(r = PEG_RADIUS, h = PEG_HEIGHT);
        }
    }

    module body()
    {
        width = MAG_TR[0] - MAG_TL[0] + padding;
        height = MAG_TL[1] - MAG_BL[1] + padding;
        color("teal") translate([ MAG_BL[0] - padding / 2, MAG_BL[1] - padding / 2, 0 ])
        {
            linear_extrude(height = thickness) offset(r = padding) square([ width, height ]);
        }
    }

    module magnets()
    {
        color("magenta")
        {
            translate(MAG_TL) cylinder(d = magnet_d, h = magnet_h);
            translate(MAG_TR) cylinder(d = magnet_d, h = magnet_h);
            translate(MAG_BR) cylinder(d = magnet_d, h = magnet_h);
            translate(MAG_BL) cylinder(d = magnet_d, h = magnet_h);
        }
    }
}
