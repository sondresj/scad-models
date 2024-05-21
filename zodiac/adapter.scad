depth = 20;
inner_diameter_top = 18 + .1;
inner_diameter_bot = 17 + .1;
outer_diameter_top = 25 - .1;
outer_diameter_bot = 24 - .1;
brim_thickness = 4;
$fn = 180;
difference()
{
    union()
    {
        translate([ 0, 0, 0 ]) cylinder(r2 = outer_diameter_top / 2, r1 = outer_diameter_bot / 2, h = depth);
        translate([ 0, 0, depth - brim_thickness ])
            cylinder(r = outer_diameter_top / 2 + brim_thickness, h = brim_thickness);
    }
    translate([ 0, 0, 0 ]) cylinder(r2 = inner_diameter_top / 2, r1 = inner_diameter_bot / 2, h = depth);
}
