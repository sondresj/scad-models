{

    $fn = 360;
    BOLT_LENGTH = 20;
    BOLT_DIAMETER = 4;
    BOLT_TAPPING_LENGTH = 8;

    // HEX_NUT_DIAMETER = 13.8; // or 12 if measured on the flat sides
    // HEX_NUT_HEIGHT = 6;
    LOCK_PIN_DIAMETER = 1.5;
    LOCK_PIN_HOUSING_DISTANCE = 7;

    AXLE_HOUSE_HEIGHT1 = 3;
    AXLE_HOUSE_HEIGHT2 = 6;
    AXLE_HOUSE_OUTER_DIAMETER1 = 10;
    AXLE_HOUSE_OUTER_DIAMETER2 = 8;
    AXLE_HOUSE_INNER_DIAMETER = 6;
    AXLE_HOUSE_INNER_HEIGHT = 7;
    AXLE_HOUSE_BALL_DIAMETER = 5.5;
    AXLE_HOUSE_GROOVE_DEPTH = 6;    // for the pegs on the ball to fit in
    AXLE_HOUSE_GROOVE_WIDTH = 1.75; // for the pegs on the ball to fit in

    TOTAL_HEIGHT = AXLE_HOUSE_HEIGHT1 + AXLE_HOUSE_HEIGHT2 + BOLT_LENGTH;

    union()
    {
        axle_house();
        bolt();
    }

    module axle_house()
    {
        difference()
        {
            union()
            {
                translate([ 0, 0, 0 ]) cylinder(h = AXLE_HOUSE_HEIGHT1, d = AXLE_HOUSE_OUTER_DIAMETER1);
                translate([ 0, 0, AXLE_HOUSE_HEIGHT1 ])
                    cylinder(h = AXLE_HOUSE_HEIGHT2, d = AXLE_HOUSE_OUTER_DIAMETER2);
            }
            color("red")
            {
                translate([ -AXLE_HOUSE_OUTER_DIAMETER1 / 2, -AXLE_HOUSE_GROOVE_WIDTH / 2, 0 ])
                    cube([ AXLE_HOUSE_OUTER_DIAMETER1, AXLE_HOUSE_GROOVE_WIDTH, AXLE_HOUSE_GROOVE_DEPTH ]);
                translate([ 0, 0, 0 ]) cylinder(h = AXLE_HOUSE_INNER_HEIGHT, d = AXLE_HOUSE_INNER_DIAMETER);
                translate([ 0, 0, AXLE_HOUSE_INNER_HEIGHT - (AXLE_HOUSE_BALL_DIAMETER / 4) ])
                    sphere(AXLE_HOUSE_BALL_DIAMETER / 2, $fn = 90);
            }
        }
    }

    module bolt()
    {
        z_offset = AXLE_HOUSE_HEIGHT1 + AXLE_HOUSE_HEIGHT2;
        house_nut_distance = 5;
        thread_lead = .4;
        difference()
        {
            union()
            {
                translate([ 0, 0, z_offset ]) cylinder(h = BOLT_LENGTH - BOLT_TAPPING_LENGTH, d = BOLT_DIAMETER);
                translate([ 0, 0, z_offset + BOLT_LENGTH - BOLT_TAPPING_LENGTH ])
                    cylinder(h = BOLT_TAPPING_LENGTH, d = BOLT_DIAMETER - 1);
                translate([ 0, 0, z_offset + BOLT_LENGTH - BOLT_TAPPING_LENGTH ])
                    thread(BOLT_DIAMETER / 2, BOLT_TAPPING_LENGTH, thread_lead * 2);
                // translate([ 0, 0, z_offset + house_nut_distance ])
                //     cylinder(h = HEX_NUT_HEIGHT, d = HEX_NUT_DIAMETER, $fn = 6);
            }
            color("red")
            {
                translate([ 0, 0, TOTAL_HEIGHT - 1 ]) taper(BOLT_DIAMETER, BOLT_DIAMETER + 2, 1.5, 3);
                translate([ 0, 0, z_offset + LOCK_PIN_HOUSING_DISTANCE ]) rotate([ 0, 90, 0 ])
                    cylinder(h = BOLT_DIAMETER * 2, d = LOCK_PIN_DIAMETER, center = true);
            }
        }
        module taper(di, do, hi, ho)
        {
            difference()
            {
                cylinder(d1 = do, d2 = do / 2, h = ho);
                cylinder(d1 = di, d2 = di / 2, h = hi);
            }
        }

        // from https://github.com/JohK/nutsnbolts/blob/master/cyl_head_bolt.scad#L262
        // the thread is extruded with a twisted linear extrusion
        module thread(orad, // outer diameter of thread
                      tl,   // thread length
                      p)    // lead of thread
        {

            // radius' for the spiral
            r = [
                orad - 0 / 18 * p, orad - 1 / 18 * p, orad - 2 / 18 * p, orad - 3 / 18 * p, orad - 4 / 18 * p,
                orad - 5 / 18 * p, orad - 6 / 18 * p, orad - 7 / 18 * p, orad - 8 / 18 * p, orad - 9 / 18 * p,
                orad - 10 / 18 * p, orad - 11 / 18 * p, orad - 12 / 18 * p, orad - 13 / 18 * p, orad - 14 / 18 * p,
                orad - 15 / 18 * p, orad - 16 / 18 * p, orad - 17 / 18 * p, orad -
                p
            ];
            difference()
            {

                // extrude 2d shape with twist
                translate([ 0, 0, tl / 2 ])
                    linear_extrude(height = tl, convexity = 10, twist = -360.0 * tl / p, center = true, $fn = 22.5)
                    // mirrored spiral (2d poly) -> triangular thread when extruded
                    polygon([[r [0] * cos(0), r [0] * sin(0)], [r [1] * cos(10), r [1] * sin(10)],
                             [r [2] * cos(20), r [2] * sin(20)], [r [3] * cos(30), r [3] * sin(30)],
                             [r [4] * cos(40), r [4] * sin(40)], [r [5] * cos(50), r [5] * sin(50)],
                             [r [6] * cos(60), r [6] * sin(60)], [r [7] * cos(70), r [7] * sin(70)],
                             [r [8] * cos(80), r [8] * sin(80)], [r [9] * cos(90), r [9] * sin(90)],
                             [r [10] * cos(100), r [10] * sin(100)], [r [11] * cos(110), r [11] * sin(110)],
                             [r [12] * cos(120), r [12] * sin(120)], [r [13] * cos(130), r [13] * sin(130)],
                             [r [14] * cos(140), r [14] * sin(140)], [r [15] * cos(150), r [15] * sin(150)],
                             [r [16] * cos(160), r [16] * sin(160)], [r [17] * cos(170), r [17] * sin(170)],
                             [r [18] * cos(180), r [18] * sin(180)], [r [17] * cos(190), r [17] * sin(190)],
                             [r [16] * cos(200), r [16] * sin(200)], [r [15] * cos(210), r [15] * sin(210)],
                             [r [14] * cos(220), r [14] * sin(220)], [r [13] * cos(230), r [13] * sin(230)],
                             [r [12] * cos(240), r [12] * sin(240)], [r [11] * cos(250), r [11] * sin(250)],
                             [r [10] * cos(260), r [10] * sin(260)], [r [9] * cos(270), r [9] * sin(270)],
                             [r [8] * cos(280), r [8] * sin(280)], [r [7] * cos(290), r [7] * sin(290)],
                             [r [6] * cos(300), r [6] * sin(300)], [r [5] * cos(310), r [5] * sin(310)],
                             [r [4] * cos(320), r [4] * sin(320)], [r [3] * cos(330), r [3] * sin(330)],
                             [r [2] * cos(340), r [2] * sin(340)], [r [1] * cos(350), r [1] * sin(350)]]);
            }
        }
    }
}
