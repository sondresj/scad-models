include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$slop = 0.075;
$fn = 90;
magnet_d = 10;
magnet_h = 5;
thickness = 10;
padding = 5;
ball_d = 25;

keyboard_unit();
connector_unit();
c_clamp_unit();
if ($preview)
    keyboard_plate();

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
    MOUNT_CENTER = [ PEG_BL[0] + 15, PEG_BL[1] + 15, 0 ];

    module keyboard_unit()
    {
        union()
        {
            pegs();
            ball();
            difference()
            {
                translate([ 0, 0, -thickness ]) body();
                translate([ 0, 0, -magnet_h ]) magnets();
            }
        }
    }

    module connector_unit()
    {
        difference()
        {

            union()
            {
                center() connector_ball_shell();
                center() translate([ 50 + ball_d / 2.6, 0, 0 ]) connector_ball_shell();
                center() connector_shaft();
            }

            center() translate([ 10, 0, -thickness * 3 ]) sphere(r = ball_d / 2 + 0.1);
            center() translate([ 50 + ball_d / 2.6, 0, 0 ]) translate([ 10, 0, -thickness * 3 ])
                sphere(r = ball_d / 2 + 0.1);
        }
    }

    module c_clamp_unit()
    {
        chamfer = 1;

        difference()
        {
            diff() cuboid([ 15, 10, 40 ], chamfer = chamfer)
            {
                attach(BACK, TOP, inside = true) threaded_rod(d = 6, l = 6, pitch = 1.25, internal = true)
                    attach(TOP, TOP, overlap = 3) cyl(r = padding, h = 6, chamfer = 3);
                // TODO: Replace fillet with cube/wedge with chamfers
                // recolor("teal") attach(FRONT, FRONT) move([ 0, -5, 0 ]) fillet(13, r = 10, spin = 270);
                recolor("teal") attach(FRONT, BOT) move([ 0, -2, -6 ]) xrot(45, cp = BOTTOM)
                    cuboid([ 15, 10, 20 ], chamfer = chamfer);
                recolor("green") attach(FRONT, BOT, align = BOT) move([ 0, 0, -2 ])
                    cuboid([ 15, 10, 40 ], chamfer = chamfer)
                {
                    attach(FRONT, TOP, inside = true) threaded_rod(d = 6, l = 6, pitch = 1.25, internal = true)
                        attach(TOP, TOP, overlap = 3) cyl(r = padding, h = 6, chamfer = 3);
                    attach(BACK, BOT, align = TOP) move([ 0, 0, -2 ]) cuboid([ 15, 20, 5 ], chamfer = chamfer);
                }
                recolor("blue") position(TOP + BACK) move([ 0, 1, -1 ]) xrot(45, cp = BOTTOM)
                    cuboid([ 15, 10, 30 ], anchor = BOTTOM + BACK, chamfer = chamfer)
                {
                    attach(BACK, TOP, inside = true) threaded_rod(d = 6, l = 6, pitch = 1.25, internal = true)
                        attach(TOP, TOP, overlap = 3) cyl(r = padding, h = 6, chamfer = 3);

                    recolor("yellow") position(TOP + BACK) move([ 0, 1, -1 ]) xrot(45, cp = BOTTOM)
                        cuboid([ 15, 10, 30 ], anchor = BOTTOM + BACK, chamfer = chamfer);

                    recolor("orange") attach(BACK, BOT, overlap = -10)
                        threaded_rod(d = 6, l = 20, bevel = true, pitch = 1.25)
                    {
                        attach(TOP, BOT, overlap = 3) spheroid(d = ball_d);
                        attach(TOP, TOP, overlap = 17) cyl(r = padding, h = 20, chamfer = 3);
                    }
                }
            }

            move([ 0, -35, 34.3 ]) threaded_rod(d = 6, l = 10.2, pitch = 1.25, internal = true);
        }
        move([ 0, -35, 60 ]) threaded_rod(d = 6, l = 40, pitch = 1.25, bevel = true)
        {
            position(TOP) cyl(d = 25, chamfer = chamfer, h = 6, $fn = 6);
        }
        move([ 0, -35, 20 ]) diff()
        {
            cyl(d = 25, chamfer = chamfer, h = 6) attach(TOP, TOP, inside = true)
                threaded_rod(d = 6, l = 4, pitch = 1.25, internal = true);
        }
    }

    module center()
    {
        translate(MOUNT_CENTER) children();
    }

    module keyboard_plate()
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
            // minkowski()
            //{
            //     cube([ width, height, thickness ]);
            //     cylinder(h = 1, r1 = 0.9, 1.0);
            // }
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

    module ball()
    {
        color("yellow") center() union()
        {
            translate([ 10, 0, -thickness * 1.5 ]) cylinder(h = thickness, r = padding, center = true);
            translate([ 10, 0, -thickness * 3 ]) sphere(r = ball_d / 2);
        }
    }

    module connector_ball_shell()
    {
        color("orange") difference()
        {
            translate([ 10, 0, -thickness * 3 ]) sphere(r = ball_d / 2 + padding);
            translate([ -ball_d / 2, -padding - 0.1, -thickness * 3 - ball_d / 2 - padding ])
                cube([ 200, padding * 2 + 0.2, ball_d + padding * 2 ]);
        }
    }

    module connector_shaft()
    {
        screw_d = 10;
        union()
        {
            color("green") difference()
            {
                translate([ ball_d / 1.7, 0, -thickness * 3 ]) rotate([ 0, 90, 0 ]) cylinder(h = 50, d = ball_d);
                translate([ 40, 0, -thickness * 3 ]) rotate([ 90, 0, 0 ]) cylinder(h = 50, d = screw_d + 4 * $slop);
                translate([ ball_d / 1.7, -padding / 6, -thickness * 3 - ball_d / 2 - padding ])
                    cube([ 200, padding / 3, ball_d + padding * 2 ]);
                translate([ 40, -ball_d / 5 - padding, -thickness * 3 ]) rotate([ 90, 0, 0 ])
                    cylinder(d2 = screw_d * 4, d1 = screw_d * 2.8, h = screw_d);
                translate([ 12, 0, -thickness * 1.5 ]) cylinder(h = thickness * 7, r = padding + 1, center = true);
                translate([ 68, 0, -thickness * 1.5 ]) cylinder(h = thickness * 7, r = padding + 1, center = true);
            }

            color("indigo")
            {
                translate([ 40, -ball_d / 2 + padding, -thickness * 3 ]) rotate([ 90, 0, 0 ])
                    threaded_rod(d = screw_d, l = 25, end_len1 = 10, pitch = 1.25, bevel2 = true, $fa = 1, $fs = 1);
                translate([ 40, -40, -thickness * 3 ]) rotate([ 90, 0, 0 ])
                    threaded_nut(nutwidth = screw_d * 2, id = screw_d, pitch = 1.25, h = 10);
            }
        }
    }
}
