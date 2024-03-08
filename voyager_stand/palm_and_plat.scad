magnet_diameter = 10;
magnet_depth = 5;
screw_size = 1;
screw_depth = 7;
lateral_tilt = 15;
forward_tilt = 0;
palm_rest_length = 95;
hex_radius = 3;

if ($preview)
    keyboard_plate();

difference()
{
    union()
    {
        pegs();
        interconnects();
        palm_rest();
    }
    magnet_cutouts();
    // inner_support_cutout();
    // hex_cutouts();
}

{
    $fn = 90;

    module tilt()
    {
        rotate([ -forward_tilt, -lateral_tilt, 0 ]) translate([ 0, 0, forward_tilt * 2 + 4 ]) children();
    }

    module extrude_projection()
    {
        hull()
        {
            children();
            linear_extrude(height = 1) projection(cut = false) children();
        }
    }

    module keyboard_plate()
    {
        tilt() color("grey", .3) import("bottom_plate_left.STL");
    }

    PEG_TL = [ 10.4, 94 ];
    PEG_BL = [ 10.4, 59 ];
    PEG_TR = [ 105.4, 94 ];
    PEG_BR = [ 105.4, 29 ];
    MAG_TR = [ 105.4, 114.4 ];
    MAG_BR = [ 119.25, 13.65 ];

    module pegs()
    {
        color("green") tilt()
        {
            translate([ PEG_TL[0], PEG_TL[1], 0 ]) cylinder(r = 1.65, h = 1.3);
            translate([ PEG_BL[0], PEG_BL[1], 0 ]) cylinder(r = 1.65, h = 1.3);
            translate([ PEG_BR[0], PEG_BR[1], 0 ]) cylinder(r = 1.65, h = 1.3);
            translate([ PEG_TR[0], PEG_TR[1], 0 ]) cylinder(r = 1.65, h = 1.3);
        }
    }

    module magnet_cutouts()
    {
        color("red") tilt()
        {
            translate([ MAG_TR[0], MAG_TR[1], -magnet_depth + .1 ]) cylinder(d = magnet_diameter, h = magnet_depth);
            translate([ MAG_TR[0], MAG_TR[1], -magnet_depth - screw_depth + .1 ])
                cylinder(d = screw_size, h = screw_depth);
            translate([ MAG_BR[0], MAG_BR[1], -magnet_depth + .1 ]) cylinder(d = magnet_diameter, h = magnet_depth);
            translate([ MAG_BR[0], MAG_BR[1], -magnet_depth - screw_depth + .1 ])
                cylinder(d = screw_size, h = screw_depth);
        }
    }

    module inner_support_cutout()
    {
        color("orange") hull()
        {
            translate([ PEG_TR[0] - magnet_diameter * 1.5, PEG_TR[1] - 10, 5 ]) cube([ magnet_diameter * 2, 1, 30 ]);
            translate([ PEG_BR[0] - magnet_diameter * 1.5, PEG_BR[1] + 10, 5 ]) cube([ magnet_diameter * 2, 1, 30 ]);
        }
    }

    module rounded_cylinder(xyz, diameter, padding = 0)
    {
        translate(xyz) cylinder(r1 = diameter / 2 + padding, r2 = diameter / 2 + padding - 1.5, h = 1);
    }

    module interconnects()
    {
        color("cyan")
        {
            extrude_projection() hull() tilt()
            {
                rounded_cylinder([ PEG_TL[0], MAG_TR[1], -1 ], magnet_diameter, 2);
                rounded_cylinder([ MAG_TR[0], MAG_TR[1], -1 ], magnet_diameter, 2);
            }
            extrude_projection() hull() tilt()
            {
                rounded_cylinder([ PEG_TL[0], MAG_TR[1], -1 ], magnet_diameter, 2);
                rounded_cylinder([ PEG_BL[0], PEG_BL[1], -1 ], magnet_diameter, 2);
            }
            extrude_projection() hull() tilt()
            {
                rounded_cylinder([ PEG_BR[0], MAG_BR[1] + magnet_diameter / 2, -1 ], magnet_diameter, 2);
                rounded_cylinder([ MAG_TR[0], MAG_TR[1], -1 ], magnet_diameter, 2);
            }
            // thumb connect to square
            extrude_projection() hull() tilt()
            {
                rounded_cylinder([ MAG_BR[0], MAG_BR[1], -1 ], magnet_diameter, 2);
                rounded_cylinder([ PEG_BR[0], PEG_BR[1], -1 ], magnet_diameter, 2);
            }
        }
    }

    PALM_TL = PEG_BL;
    PALM_TR = [ MAG_BR[0], MAG_BR[1] ];
    PALM_BL = [ PALM_TL[0] - magnet_diameter / 2, PALM_TL[1] - palm_rest_length - (PEG_BL[1] - MAG_BR[1]) ];
    PALM_BR = [
        PALM_TR[0] - PALM_TR[0] * tan(lateral_tilt) + ((PALM_TR[1] - PALM_TL[1]) / 3), PALM_TR[1] - palm_rest_length
    ];

    module palm_rest()
    {
        module tip()
        {
            hull()
            {
                translate([ 0, PALM_BL[1] - PALM_TL[1], 0 ]) extrude_projection() hull() tilt()
                    rounded_cylinder([ PALM_TL[0], PALM_TL[1], -1 ], magnet_diameter, 2);
                translate([ PALM_BR[0], PALM_BR[1] - PALM_TL[1], 0 ]) extrude_projection() hull() tilt()
                    rounded_cylinder([ PALM_TL[0], PALM_TL[1], 2 ], magnet_diameter);
            }
        }

        color("magenta")
        {
            // connection from left support to palm_rest
            extrude_projection() hull() tilt()
            {
                rounded_cylinder([ PALM_TL[0], PALM_TL[1], -1 ], magnet_diameter, 2);
                rounded_cylinder([ PALM_TL[0], PALM_TR[1], -1 ], magnet_diameter, 2);
            }
            hull()
            {
                extrude_projection() hull() tilt()
                {
                    rounded_cylinder([ PALM_TL[0], PALM_TR[1], -1 ], magnet_diameter, 2);
                    rounded_cylinder([ PALM_TR[0], PALM_TR[1], -1 ], magnet_diameter, 2);
                    // rounded_cylinder([ PALM_TR[0], PALM_TR[1] - 25, -1 ], magnet_diameter, 0);
                }
                tip();
            }
        }
    }

    module hex_cutouts()
    {
        $fn = 6;
        MARGIN = hex_radius * 2 + 2;
        HEX_TL = [ PALM_TL[0] + MARGIN, PALM_TR[1] - MARGIN ];
        HEX_TR = [ PALM_TR[0] - MARGIN, PALM_TR[1] + MARGIN ];
        HEX_BL_Y = PALM_BL[1];
        color("yellow")
        {
            for (y = [HEX_BL_Y:MARGIN:HEX_TL[1]])
            {
                for (x = [HEX_TL[0]:MARGIN:HEX_TR[0]])
                {
                    translate([ x, y, -1 ]) linear_extrude(height = 90) circle(r = hex_radius);
                }
            }
        }
    }
}
