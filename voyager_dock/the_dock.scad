lateral_tilt = 15;
palm_rest_length = 105;
magnet_diameter = 10;

if ($preview)
    keyboard_plate();

difference()
{
    union()
    {
        pegs();
        frame();
        palm_rest();
        magnet_padding();
    }
    cable_cutouts();
    foot_cutouts();
    magnet_cutouts();
}

{
    CORNER_DIAMETER = 6;
    DOCK_HEIGHT = 3;
    PADDING = 3.5;

    CABLE_DIAMETER = 4.3;

    PEG_DIAMETER = 1.70;
    PEG_HEIGHT = 1.3;
    PEG_TL = [ 10.4, 94, 0 ];
    PEG_BL = [ 10.4, 59, 0 ];
    PEG_TR = [ 105.4, 94, 0 ];
    PEG_BR = [ 105.4, 29, 0 ];

    FOOT_DIAMETER = 16.3;
    FOOT_DEPTH = 11.5;
    FOOT_TR = [ 105.4, 114.4, -FOOT_DEPTH + .1 ];
    FOOT_BR = [ 119.25, 13.65, -FOOT_DEPTH + .1 ];

    FRAME_OFFSET = (FOOT_DIAMETER - CORNER_DIAMETER) / 2;
    FRAME_TL = [ PEG_TL[0], FOOT_TR[1] + FRAME_OFFSET, -1 ];
    FRAME_TR = [ FOOT_TR[0] + FRAME_OFFSET, FOOT_TR[1] + FRAME_OFFSET, -1 ];
    FRAME_BR = [ PEG_BR[0] + FRAME_OFFSET, FOOT_BR[1] - FRAME_OFFSET, -1 ];
    FRAME_BL = [ PEG_BL[0], FOOT_BR[1] - FRAME_OFFSET, -1 ];

    // -1.8 results in .8mm distance between magnet and plate.
    MAGNET_R = [ FRAME_TR[0] - PADDING, (FRAME_TR[1] - FRAME_BR[1]) / 2 + FRAME_BR[1], -1.8 ];
    MAGNET_L = [ PEG_TL[0] + CORNER_DIAMETER / 2 + PADDING, (PEG_TL[1] - PEG_BL[1]) / 2 + PEG_BL[1], -1.8 ];

    CABLE_TL = [ (PEG_TR[0] - PEG_TL[0]) / 2 + PEG_TL[0], FOOT_TR[1] ];
    CABLE_TR = [ FOOT_TR[0] - FOOT_DIAMETER - PADDING, FOOT_TR[1] ];

    function calculate_tilted_position(xyz) = [
        // thanks copilot
        xyz[0] * cos(lateral_tilt) - (xyz[2] + DOCK_HEIGHT) * sin(lateral_tilt), xyz[1],
        -xyz[0] * sin(lateral_tilt) + (xyz[2] + DOCK_HEIGHT) * cos(lateral_tilt)
    ];

    $fn = 90;

    module tilt_lift(height)
    {
        translate([ 0, 0, height ]) rotate([ 0, -lateral_tilt, 0 ]) children();
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
        tilt_lift(DOCK_HEIGHT) color("grey", .3) import("bottom_plate_left.STL");
    }

    module rounded_cylinder(xyz, diameter, padding = 0)
    {
        translate(xyz) cylinder(r1 = diameter / 2 + padding, r2 = diameter / 2 + padding - 1.5, h = 1);
    }

    module pegs()
    {
        color("green") tilt_lift(DOCK_HEIGHT)
        {
            translate(PEG_TL) cylinder(r = PEG_DIAMETER, h = PEG_HEIGHT);
            translate(PEG_BL) cylinder(r = PEG_DIAMETER, h = PEG_HEIGHT);

            translate([ PEG_BR[0], PEG_BR[1], -PEG_HEIGHT * 2 ]) cylinder(r = PEG_DIAMETER, h = PEG_HEIGHT * 3);
            translate([ PEG_TR[0], PEG_TR[1], -PEG_HEIGHT * 2 ]) cylinder(r = PEG_DIAMETER, h = PEG_HEIGHT * 3);
        }
    }

    module foot_cutouts()
    {
        color("red") tilt_lift(DOCK_HEIGHT)
        {
            translate(FOOT_TR) cylinder(d = FOOT_DIAMETER, h = FOOT_DEPTH);
            translate(FOOT_BR) cylinder(d = FOOT_DIAMETER, h = FOOT_DEPTH);
        }
    }

    module magnet_cutouts()
    {
        diameter_adjusted_for_tilt = magnet_diameter / cos(lateral_tilt);
        color("blue")
        {
            extrude_projection() tilt_lift(DOCK_HEIGHT) translate(MAGNET_R)
                cylinder(d = diameter_adjusted_for_tilt, h = .01);
            extrude_projection() tilt_lift(DOCK_HEIGHT) translate(MAGNET_L)
                cylinder(d = diameter_adjusted_for_tilt, h = .01);
        }
    }

    module magnet_padding()
    {
        color("blue")
        {
            extrude_projection() tilt_lift(DOCK_HEIGHT)
                rounded_cylinder([ MAGNET_L[0], MAGNET_L[1], -1 ], magnet_diameter, PADDING);
            extrude_projection() tilt_lift(DOCK_HEIGHT)
                rounded_cylinder([ MAGNET_R[0], MAGNET_R[1], -1 ], magnet_diameter, PADDING);
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

    module frame()
    {
        color("yellow")
        {
            extrude_projection() hull() tilt_lift(DOCK_HEIGHT)
            {
                rounded_cylinder(FRAME_TL, CORNER_DIAMETER, PADDING);
                rounded_cylinder(FRAME_TR, CORNER_DIAMETER, PADDING);
            }
            extrude_projection() hull() tilt_lift(DOCK_HEIGHT)
            {
                rounded_cylinder(FRAME_TR, CORNER_DIAMETER, PADDING);
                rounded_cylinder(FRAME_BR, CORNER_DIAMETER, PADDING);
            }
            extrude_projection() hull() tilt_lift(DOCK_HEIGHT)
            {
                rounded_cylinder(FRAME_BR, CORNER_DIAMETER, PADDING);
                rounded_cylinder(FRAME_BL, CORNER_DIAMETER, PADDING);
            }
            extrude_projection() hull() tilt_lift(DOCK_HEIGHT)
            {
                rounded_cylinder(FRAME_BL, CORNER_DIAMETER, PADDING);
                rounded_cylinder(FRAME_TL, CORNER_DIAMETER, PADDING);
            }
            extrude_projection() hull() tilt_lift(DOCK_HEIGHT)
                rounded_cylinder([ FOOT_TR[0], FOOT_TR[1], -1 ], FOOT_DIAMETER, PADDING);
            extrude_projection() hull() tilt_lift(DOCK_HEIGHT)
                rounded_cylinder([ FOOT_BR[0], FOOT_BR[1], -1 ], FOOT_DIAMETER, PADDING);
        }
    }

    module palm_rest()
    {

        middle = (FRAME_BR[0] - FRAME_BL[0]) / 2;
        radius = middle / 1.5 + PADDING;

        palm_tl = FRAME_BL;
        palm_tr = FRAME_BR;
        palm_b = [ palm_tl[0], FOOT_BR[1] - palm_rest_length, DOCK_HEIGHT ];

        module rounded_tip()
        {

            tilted_bl = calculate_tilted_position([ palm_b[0], palm_b[1], palm_b[2] ]);
            tilted_b = [
                // for the life of me, I can't figure out how to calculate this
                // value correctly without some manual tweaking
                tilted_bl[0] + radius - PADDING - .926, tilted_bl[1] + radius, tilted_bl[2]
            ];

            hull()
            {
                translate(tilted_b) cylinder(r1 = radius, r2 = radius - 1.5, h = 1, $fn = 180);
                translate([ tilted_b[0], tilted_b[1], 0 ]) cylinder(r = radius, h = 1, $fn = 180);
            }
        }

        color("magenta") union()
        {

            hull()
            {
                extrude_projection() hull() tilt_lift(DOCK_HEIGHT)
                {
                    rounded_cylinder(palm_tl, CORNER_DIAMETER, PADDING);
                    rounded_cylinder([ palm_tr[0] + (CORNER_DIAMETER) / 2 + PADDING, palm_tr[1], -1 ], CORNER_DIAMETER,
                                     PADDING);
                }
                rounded_tip();
            }
            difference()
            {
                hull()
                {
                    extrude_projection() hull() tilt_lift(DOCK_HEIGHT)
                        rounded_cylinder([ FOOT_BR[0], FOOT_BR[1], -1 ], FOOT_DIAMETER, PADDING);
                    rounded_tip();
                }
                // cutting off overlap going into the frame rectangle
                extrude_projection() hull() tilt_lift(DOCK_HEIGHT)
                    rounded_cylinder([ FRAME_BR[0] - FOOT_DIAMETER / 2, FOOT_BR[1], -1 ], FOOT_DIAMETER, PADDING);
            }
        }
    }
}
