
// trygve();
// mario();
// sanna();
lilli_otonie();

{
    $fn = 45;
    width = 30;
    height = 40;
    corner_radius = 4;
    spacing = 0;
    hanger_length = 10;
    hanger_z = 15;
    screw_head_diameter = 9;
    screw_diameter = 4;

    _ = [[0, 0, 0], [width, 0, 0]];
    sp = [];
    A = [
        [ 0, 0, 0 ],
        [ width / 6, height / 3, 0 ],
        [ width - width / 4, height / 3, 0 ],
        [ width / 6, height / 3, 0 ],
        [ width / 2, height, 0 ],
        [ width, 0, 0 ],
        [ width, hanger_length, hanger_z ],
    ];
    E = [[width, height, 0], [0, height, 0], [0, height / 2, 0], [width / 2, height / 2, 0], [0, height / 2, 0],
         [0, 0, 0], [width, 0, 0, ], [0, 0, 0], [width / 2, 0, 0], [width / 2, hanger_length, hanger_z]];
    G = [
        [ width, height - height / 3, 0 ],
        [ width / 2, height, 0 ],
        [ 0, height / 2, 0 ],
        [ width / 2, 0, 0 ],
        [ width / 2, hanger_length, hanger_z ],
        [ width / 2, 0, 0 ],
        [ width, height / 3, 0 ],
        [ width - width / 3, height / 3, 0 ],
        [ width, height / 3, 0 ],
        [ width, 0, 0 ],

    ];
    I = [
        [ width / 2, height, 0 ],
        [ width / 2, 0, 0 ],
    ];
    L = [
        [ 0, height, 0 ],
        [ 0, 0, 0 ],
        [ width, 0, 0 ],
        [ width, hanger_length, hanger_z ],
    ];
    M = [
        [ 0, hanger_length, hanger_z ],
        [ 0, 0, 0 ],
        [ 0, height, 0 ],
        [ width / 2, height / 2, 0 ],
        [ width, height, 0 ],
        [ width, 0, 0 ],
        [ width, hanger_length, hanger_z ],
    ];
    N = [
        [ 0, 0, 0 ],
        [ 0, height, 0 ],
        [ width, 0, 0 ],
        [ width, height, 0 ],
        [ width, 0, 0 ],
        [ width, hanger_length, hanger_z ],
    ];
    O = [
        [ width / 2, 0, 0 ],
        [ 0, height / 2, 0 ],
        [ width / 2, height, 0 ],
        [ width, height / 2, 0 ],
        [ width / 2, 0, 0 ],
        [ width / 2, hanger_length, hanger_z ],
    ];
    R = [
        [ 0, 0, 0 ],
        [ 0, height, 0 ],
        [ width - width / 4, height - height / 3, 0 ],
        [ 0, height / 3, 0 ],
        [ width, 0, 0 ],
        // hanger
        [ width, hanger_length, hanger_z ],
    ];
    RI = [
        [ 0, 0, 0 ],
        [ 0, height, 0 ],
        [ width - width / 4, height - height / 3, 0 ],
        [ 0, height / 3, 0 ],
        [ width, 0, 0 ],
        [ width, height, 0 ],
        [ width, 0, 0 ],
        // hanger
        [ width, hanger_length, hanger_z ],
    ];
    S = [
        [ width, height - height / 6, 0 ],
        [ width / 2, height, 0 ],
        [ 0, height - height / 3, 0 ],
        [ width, height / 3, 0 ],
        [ width / 2, 0, 0 ],
        [ 0, height / 6, 0 ],
        [ width / 2, 0, 0 ],
        [ width / 2, hanger_length, hanger_z ],
    ];
    T = [
        [ 0, height, 0 ], [ width, height, 0 ], [ width / 2, height, 0 ], [ width / 2, 0, 0 ],

        [ width / 2, hanger_length, hanger_z ]
    ];
    V = [
        [ 0, height, 0 ],
        [ width / 2, 0, 0 ],
        [ width, height, 0 ],
        [ width / 2, 0, 0 ],

        [ width / 2, hanger_length, hanger_z ],
    ];
    Y = [
        [ 0, 0, 0 ],
        [ width, height, 0 ],
        [ width / 2, height / 2, 0 ],
        [ 0, height, 0 ],
    ];

    function get_x_offset(idx) = idx * (width + spacing);

    module render_name(letters, y = 0)
    {
        for (i = [0:len(letters) - 1])
        {
            l = letters[i];
            xo = get_x_offset(i); // x offset
            
            if (len(l) > 1)
            {
            for (p_i = [1:len(l) - 1])
            {
                pp = l[p_i - 1]; // previous point
                pc = l[p_i];     // current point

                if (pc.z != 0 || pp.z != 0)
                {
                    pp_r = pp.z != 0 ? corner_radius / 2 : corner_radius;
                    pc_r = pc.z != 0 ? corner_radius / 2 : corner_radius;
                    hull()
                    {

                        translate([ xo + pp.x, y + pp.y, max(pp.z, corner_radius) ]) sphere(r = pp_r);
                        translate([ xo + pc.x, y + pc.y, max(pc.z, corner_radius) ]) sphere(r = pc_r);
                    }
                }
                else
                {
                    hull()
                    {
                        translate([ xo + pp.x,y +  pp.y, pp.z ]) cylinder(r = corner_radius, h = 1);
                        translate([ xo + pp.x, y + pp.y, corner_radius ]) sphere(r = corner_radius);
                        translate([ xo + pc.x, y + pc.y, pc.z ]) cylinder(r = corner_radius, h = 1);
                        translate([ xo + pc.x, y + pc.y, corner_radius ]) sphere(r = corner_radius);
                    }
                }
            }
            }
        }
    }

    module backplate(xy, length)
    {
        union()
        {
            // hull()
            //{
            //     translate([ xy.x, 0, 0 ])
            //         cylinder(h = corner_radius / 2, r1 = corner_radius, r2 = corner_radius - corner_radius / 4);
            //     translate([ length - width / 2, 0, 0 ])
            //         cylinder(h = corner_radius / 2, r1 = corner_radius, r2 = corner_radius - corner_radius / 4);
            // }
            hull()
            {
                translate([ xy.x, xy.y, 0 ])
                    cylinder(h = corner_radius / 2, r1 = corner_radius, r2 = corner_radius - corner_radius / 4);
                translate([ length - width / 2, xy.y, 0 ])
                    cylinder(h = corner_radius / 2, r1 = corner_radius, r2 = corner_radius - corner_radius / 4);
            }
        }
    }

    module screw_cutouts(points)
    {
        for (i = [0:len(points) - 1])
        {
            translate([ points[i].x, points[i].y, -1 ]) cylinder(d = screw_diameter, h = corner_radius * 4);
            translate([ points[i].x, points[i].y, points[i].z - 2 ]) cylinder(d = screw_head_diameter, h = 4);
        }
    }

    module trygve()
    {
        letters = [ T, R, Y, G, V, E ];
        length = get_x_offset(len(letters));

        difference()
        {

            union()
            {
                render_name(letters);
                backplate([width / 2, height], length);
            }
            screw_cutouts([
                [ width / 2, height, corner_radius * 2.1 ],
                [ length - width / 2, height, corner_radius * 2.1 ],
                [ length / 2, height, corner_radius * 2 ],
            ]);
        }
    }

    module mario()
    {
        letters = [ M, A, RI, O ];
        length = get_x_offset(len(letters));

        difference()
        {
            union()
            {
                render_name(letters);
                backplate([0, height], length);
            }
            screw_cutouts([
                [ 0, height, corner_radius * 2.1 ],
                [ length - width / 2, height, corner_radius * 2.1 ],
                [ length / 2 - width / 4, height, corner_radius - .1 ],
            ]);
        }
    }

    module sanna()
    {
        letters = [ S, A, N, N, A ];
        length = get_x_offset(len(letters));

        difference()
        {
            union()
            {
                render_name(letters);
                backplate([width / 2, height], length);
            }
            screw_cutouts([
                [ width / 2, height, corner_radius * 2.1 ],
                [ length / 2, height, corner_radius - .1 ],
                [ length - width / 2, height, corner_radius * 2.1 ],
            ]);
        }
    }

    module lilli_otonie()
    {

        lilli = [ L, I, L, L, I,];
        otonie = [ O, T, O, N, I, E ];
        length1 = get_x_offset(len(lilli));
        length2 = get_x_offset(len(otonie));


        difference()
        {
            union()
            {
                render_name(lilli);
                render_name(otonie, -height - corner_radius*3);
                backplate([0, height], length1);
                backplate([width/2, -corner_radius*3], length2);
            }
            screw_cutouts([
                [ 0, height, corner_radius * 2.1 ],
                [ length1 / 2, height, corner_radius - .1 ],
                [ length1 - width / 2, height, corner_radius * 2.1 ],
                [ width/2, -corner_radius*3, corner_radius * 2.1 ],
                [ length2 - width / 2, -corner_radius*3, corner_radius * 2.1 ],
                [ length2 / 2, -corner_radius*3, corner_radius * 2 ],
            ]);
        }
    }
}
