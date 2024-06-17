height = 10;
radius = 20;
bolt_radius = 4.5;
$fn = 90;

difference()
{
    cylinder(h = height, r = radius);
    cylinder(h = height, r = bolt_radius);
}
