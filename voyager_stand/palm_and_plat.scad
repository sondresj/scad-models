lateral_tilt = 15;
forward_tilt = 0;
palm_rest_length = 95;

// if ($preview)
//     keyboard_plate();

difference()
{
    union()
    {
        pegs();
        frame();
        palm_rest();
    }
    cable_cutouts();
    magnet_cutouts();
}

{
    CORNER_DIAMETER = 6;
    MAGNET_DIAMETER = 16.3;
    MAGNET_DEPTH = 12.5;
    PADDING = 3.5;

    CABLE_DIAMETER = 4.3;

    PEG_TL = [ 10.4, 94 ];
    PEG_BL = [ 10.4, 59 ];
    PEG_TR = [ 105.4, 94 ];
    PEG_BR = [ 105.4, 29 ];
    PEG_DIAMETER = 1.70;
    PEG_HEIGHT = 1.3;

    MAG_TR = [ 105.4, 114.4 ];
    MAG_BR = [ 119.25, 13.65 ];

    FRAME_OFFSET = (MAGNET_DIAMETER - CORNER_DIAMETER) / 2;
    FRAME_TL = [ PEG_TL[0], MAG_TR[1] + FRAME_OFFSET ];
    FRAME_TR = [ MAG_TR[0] + FRAME_OFFSET, MAG_TR[1] + FRAME_OFFSET ];
    FRAME_BR = [ PEG_BR[0] + FRAME_OFFSET, MAG_BR[1] - FRAME_OFFSET ];
    FRAME_BL = [ PEG_BL[0], MAG_BR[1] - FRAME_OFFSET ];

    CABLE_TL = [ (PEG_TR[0] - PEG_TL[0]) / 2 + PEG_TL[0], MAG_TR[1] ];
    CABLE_TR = [ MAG_TR[0] - MAGNET_DIAMETER - PADDING, MAG_TR[1] ];

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

    module pegs()
    {
        color("green") tilt()
        {
            translate([ PEG_TL[0], PEG_TL[1], 0 ]) cylinder(r = PEG_DIAMETER, h = PEG_HEIGHT);
            translate([ PEG_BL[0], PEG_BL[1], 0 ]) cylinder(r = PEG_DIAMETER, h = PEG_HEIGHT);

            // translate([ PEG_BR[0], PEG_BR[1], -PEG_HEIGHT * 2 ]) cylinder(r = PEG_DIAMETER, h = PEG_HEIGHT * 3);
            // translate([ PEG_TR[0], PEG_TR[1], -PEG_HEIGHT * 2 ]) cylinder(r = PEG_DIAMETER, h = PEG_HEIGHT * 3);
        }
    }

    module magnet_cutouts()
    {
        color("red") tilt()
        {
            translate([ MAG_TR[0], MAG_TR[1], -MAGNET_DEPTH + .1 ]) cylinder(d = MAGNET_DIAMETER, h = MAGNET_DEPTH);
            translate([ MAG_BR[0], MAG_BR[1], -MAGNET_DEPTH + .1 ]) cylinder(d = MAGNET_DIAMETER, h = MAGNET_DEPTH);
        }
    }

    module cable_cutouts()
    {
        $fn = 18;
        DEPTH = MAGNET_DIAMETER * 2;
        module cable()
        {
            hull()
            {
                translate([ CABLE_TL[0], CABLE_TL[1] + DEPTH / 2, -1 ]) rotate([ 90, 0, 0 ])
                    cylinder(d = CABLE_DIAMETER, h = DEPTH);
                translate([ CABLE_TL[0], CABLE_TL[1] + DEPTH / 2, CABLE_DIAMETER / 2 - 1 ]) rotate([ 90, 0, 0 ])
                    cylinder(d = CABLE_DIAMETER, h = DEPTH);
            }
            hull()
            {
                translate([ CABLE_TR[0], CABLE_TR[1] + DEPTH / 2, -1 ]) rotate([ 90, 0, 0 ])
                    cylinder(d = CABLE_DIAMETER, h = DEPTH);
                translate([ CABLE_TR[0], CABLE_TR[1] + DEPTH / 2, CABLE_DIAMETER / 2 - 1 ]) rotate([ 90, 0, 0 ])
                    cylinder(d = CABLE_DIAMETER, h = DEPTH);
            }
        }

        module clamps(x, y)
        {
            translate([ x - CABLE_DIAMETER / 2, y, .05 ]) minkowski()
            {
                cube([ .20, 2, .3 ]);
                sphere(d = .1);
            }
            translate([ x - CABLE_DIAMETER / 2, y + CABLE_DIAMETER * 2, .05 ]) minkowski()
            {
                cube([ .20, 2, .3 ]);
                sphere(d = .1);
            }
            translate([ x + CABLE_DIAMETER / 2 - .2, y + CABLE_DIAMETER, .05 ]) minkowski()
            {
                cube([ .20, 2, .3 ]);
                sphere(d = .1);
            }
        }
        difference()
        {
            cable();
            clamps(CABLE_TL[0], CABLE_TL[1]);
            clamps(CABLE_TR[0], CABLE_TR[1]);
        }
    }

    module rounded_cylinder(xyz, diameter, padding = 0)
    {
        translate(xyz) cylinder(r1 = diameter / 2 + padding, r2 = diameter / 2 + padding - 1.5, h = 1);
    }

    module frame()
    {
        color("yellow")
        {
            extrude_projection() hull() tilt()
            {
                rounded_cylinder([ FRAME_TL[0], FRAME_TL[1], -1 ], CORNER_DIAMETER, PADDING);
                rounded_cylinder([ FRAME_TR[0], FRAME_TR[1], -1 ], CORNER_DIAMETER, PADDING);
            }
            extrude_projection() hull() tilt()
            {
                rounded_cylinder([ FRAME_TR[0], FRAME_TR[1], -1 ], CORNER_DIAMETER, PADDING);
                rounded_cylinder([ FRAME_BR[0], FRAME_BR[1], -1 ], CORNER_DIAMETER, PADDING);
            }
            extrude_projection() hull() tilt()
            {
                rounded_cylinder([ FRAME_BR[0], FRAME_BR[1], -1 ], CORNER_DIAMETER, PADDING);
                rounded_cylinder([ FRAME_BL[0], FRAME_BL[1], -1 ], CORNER_DIAMETER, PADDING);
            }
            extrude_projection() hull() tilt()
            {
                rounded_cylinder([ FRAME_BL[0], FRAME_BL[1], -1 ], CORNER_DIAMETER, PADDING);
                rounded_cylinder([ FRAME_TL[0], FRAME_TL[1], -1 ], CORNER_DIAMETER, PADDING);
            }
            extrude_projection() hull() tilt() rounded_cylinder([ MAG_TR[0], MAG_TR[1], -1 ], MAGNET_DIAMETER, PADDING);
            // this one is repeated in the palm rest module
            // extrude_projection() hull() tilt() rounded_cylinder([ MAG_BR[0], MAG_BR[1], -1 ], MAGNET_DIAMETER,
            // PADDING);
        }
    }

    PALM_TL = FRAME_BL;
    PALM_TR = FRAME_BR;
    PALM_BL = [ PALM_TL[0], PALM_TL[1] - palm_rest_length ];
    PALM_BR = [ PALM_TR[0] - (PALM_TR[0] * tan(lateral_tilt)), PALM_TR[1] - palm_rest_length ];

    module palm_rest()
    {
        module tip()
        {
            hull()
            {
                translate([ 0, PALM_BL[1] - PALM_TL[1], 0 ]) extrude_projection() hull() tilt()
                    rounded_cylinder([ PALM_TL[0], PALM_TL[1], -1 ], CORNER_DIAMETER, PADDING);
                translate([ PALM_BR[0], PALM_BR[1] - PALM_TL[1], 0 ]) extrude_projection() hull() tilt()
                    rounded_cylinder([ PALM_TL[0], PALM_TL[1], -1 ], CORNER_DIAMETER, PADDING);
            }
        }

        module rounded_tip()
        {
            PALM_OFFSET = (PALM_TR[0] - PALM_TL[0]) / 2 - PALM_TL[0] + tan(lateral_tilt) * lateral_tilt;
            PALM_DIAMETER = PALM_BR[0] - PALM_BL[0];

            hull()
            {
                translate([ PALM_OFFSET, PALM_BL[1] + PALM_DIAMETER / 2, sin(lateral_tilt) * lateral_tilt ]) cylinder(
                    r1 = PALM_DIAMETER / 2 + PADDING, r2 = PALM_DIAMETER / 2 + PADDING - 1.5, h = 1, $fn = 360);
                translate([ PALM_OFFSET, PALM_BL[1] + PALM_DIAMETER / 2, 0 ])
                    cylinder(r = PALM_DIAMETER / 2 + PADDING, h = 1, $fn = 360);
            }
        }

        color("magenta") union()
        {
            hull()
            {
                extrude_projection() hull() tilt()
                {
                    rounded_cylinder([ PALM_TL[0], PALM_TL[1], -1 ], CORNER_DIAMETER, PADDING);
                    rounded_cylinder([ PALM_TR[0] + (CORNER_DIAMETER) / 2 + PADDING, PALM_TR[1], -1 ], CORNER_DIAMETER,
                                     PADDING);
                }
                rounded_tip();
            }
            difference()
            {
                hull()
                {
                    extrude_projection() hull() tilt()
                        rounded_cylinder([ MAG_BR[0], MAG_BR[1], -1 ], MAGNET_DIAMETER, PADDING);
                    rounded_tip();
                }
                extrude_projection() hull() tilt() rounded_cylinder(
                    [ PEG_BR[0] - CORNER_DIAMETER / 2 - PADDING / 2 + 2, MAG_BR[1], -1 ], MAGNET_DIAMETER, PADDING);
            }
        }
    }
}
