lateral_tilt = 15;
forward_tilt = 0;
palm_rest_length = 95;

if ($preview)
    keyboard_plate();

difference()
{
    union()
    {
        pegs();
        frame();
        palm_rest();
        voyager_badge_clipons();
    }
    cable_cutouts();
    foot_cutouts();
    magnet_cutout();
}

{
    CORNER_DIAMETER = 6;
    PADDING = 3.5;

    CABLE_DIAMETER = 4.3;

    PEG_TL = [ 10.4, 94 ];
    PEG_BL = [ 10.4, 59 ];
    // TR and BR are unused since we use the feet to hold the keyboard in place on this side
    // They however used for other positions (e.g for the frame)
    PEG_TR = [ 105.4, 94 ];
    PEG_BR = [ 105.4, 29 ];
    PEG_DIAMETER = 1.70;
    PEG_HEIGHT = 1.3;

    FOOT_TR = [ 105.4, 114.4 ];
    FOOT_BR = [ 119.25, 13.65 ];
    FOOT_DIAMETER = 16.3;
    FOOT_DEPTH = 12.5;

    FRAME_OFFSET = (FOOT_DIAMETER - CORNER_DIAMETER) / 2;
    FRAME_TL = [ PEG_TL[0], FOOT_TR[1] + FRAME_OFFSET ];
    FRAME_TR = [ FOOT_TR[0] + FRAME_OFFSET, FOOT_TR[1] + FRAME_OFFSET ];
    FRAME_BR = [ PEG_BR[0] + FRAME_OFFSET, FOOT_BR[1] - FRAME_OFFSET ];
    FRAME_BL = [ PEG_BL[0], FOOT_BR[1] - FRAME_OFFSET ];

    MAGNET_POS = [ FRAME_TR[0], (FRAME_TR[1] - FRAME_BR[1])/2 + FRAME_BR[1]];
    MAGNET_DIAMETER = 10;
    MAGNET_HEIGHT = 4;

    CABLE_TL = [ (PEG_TR[0] - PEG_TL[0]) / 2 + PEG_TL[0], FOOT_TR[1] ];
    CABLE_TR = [ FOOT_TR[0] - FOOT_DIAMETER - PADDING, FOOT_TR[1] ];

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

    module foot_cutouts()
    {
        color("red") tilt()
        {
            translate([ FOOT_TR[0], FOOT_TR[1], -FOOT_DEPTH + .1 ]) cylinder(d = FOOT_DIAMETER, h = FOOT_DEPTH);
            translate([ FOOT_BR[0], FOOT_BR[1], -FOOT_DEPTH + .1 ]) cylinder(d = FOOT_DIAMETER, h = FOOT_DEPTH);
        }
    }

    module magnet_cutout()
    {
        color("blue") tilt()
        {
            translate([ MAGNET_POS[0], MAGNET_POS[1], -MAGNET_HEIGHT + .1]) cylinder(d = MAGNET_DIAMETER, h = MAGNET_HEIGHT);
        }
    }
    
    module voyager_badge_clipons()
    {
        // todo: get correct measurements on the badge
        outer_frame_x = FRAME_TR[0] + CORNER_DIAMETER + PADDING;
        outer_frame_y = FRAME_TR[1] - CORNER_DIAMETER - PADDING; // should be before the curve of the frame

        color("yellow") tilt()
        {

            extrude_projection() hull() tilt()
            {
                translate([outer_frame_x, outer_frame_y, -5]) square([10, 10]);
            }

        }
    }

    module cable_cutouts()
    {
        $fn = 18;
        DEPTH = FOOT_DIAMETER * 2;
        module cable(xy)
        {
            difference()
            {
                hull()
                {
                    translate([ xy[0], xy[1] + DEPTH / 2, -1 ]) rotate([ 90, 0, 0 ])
                        cylinder(d = CABLE_DIAMETER, h = DEPTH);
                    translate([ xy[0], xy[1] + DEPTH / 2, CABLE_DIAMETER / 2 - .8 ]) rotate([ 90, 0, 0 ])
                        cylinder(d = CABLE_DIAMETER, h = DEPTH);
                }
                translate([ xy[0] - CABLE_DIAMETER / 2, xy[1], .05 ]) minkowski()
                {
                    cube([ .20, 2, .3 ]);
                    sphere(d = .1);
                }
                translate([ xy[0] - CABLE_DIAMETER / 2, xy[1] + CABLE_DIAMETER * 2, .05 ]) minkowski()
                {
                    cube([ .20, 2, .3 ]);
                    sphere(d = .1);
                }
                translate([ xy[0] + CABLE_DIAMETER / 2 - .2, xy[1] + CABLE_DIAMETER, .05 ]) minkowski()
                {
                    cube([ .20, 2, .3 ]);
                    sphere(d = .1);
                }
            }
        }
        cable(CABLE_TL);
        cable(CABLE_TR);
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
            extrude_projection() hull() tilt() rounded_cylinder([ FOOT_TR[0], FOOT_TR[1], -1 ], FOOT_DIAMETER, PADDING);
            // this one is repeated in the palm rest module
            // extrude_projection() hull() tilt() rounded_cylinder([ FOOT_BR[0], FOOT_BR[1], -1 ], FOOT_DIAMETER,
            // PADDING);
        }
    }

    PALM_TL = FRAME_BL;
    PALM_TR = FRAME_BR;
    PALM_BL = [ PALM_TL[0], PALM_TL[1] - palm_rest_length ];
    PALM_BR = [ PALM_TR[0], PALM_TR[1] - palm_rest_length ];

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
            // this .1 should probably be a trig function calculation, but teh math provess is a lackin
            // the goal is to get a straight line on the left side
            PALM_OFFSET = (PALM_TR[0] - PALM_TL[0]) / 2 - PALM_TL[0] + .1;
            PALM_DIAMETER = (PALM_BR[0] - PALM_BL[0]) / 1.5;

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
                        rounded_cylinder([ FOOT_BR[0], FOOT_BR[1], -1 ], FOOT_DIAMETER, PADDING);
                    rounded_tip();
                }
                // cutting off overlap going into the frame rectangle
                extrude_projection() hull() tilt() rounded_cylinder(
                    [ PEG_BR[0] - CORNER_DIAMETER / 2 - PADDING / 2 + 2, FOOT_BR[1], -1 ], FOOT_DIAMETER, PADDING);
            }
        }
    }
}
