include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

$fn = 45;
$slop = 0.175;

rail_h=4;
rail_w=12;
mag_h=rail_h;
mag_r=5 + $slop;
plate_z=6;

// rail to connect keyboard
fwd(100)
dovetail("female", slide=200, w=rail_w, h=rail_h, spin=90);

// edge rail to connect keyboard
fwd(120)
dovetail("female", slide=20, w=rail_w, h=rail_h, spin=90)
attach(BACK, FRONT, align=BOT, overlap=rail_h)
cuboid([rail_w-2, rail_h, 10], chamfer=1, except=[FRONT]);

diff()
left_plate() {
    // pegs
    attach(["peg_tr", "peg_br", "peg_bl", "peg_tl"], BOT)
    peg();

    // z plate thingy
    down(plate_z/2 - .5)
    attach(BOT, TOP)
    chain_hull()
    {
        move(PEG_TL) cyl(h=plate_z, r=mag_r+1, chamfer2=1);
        move(PEG_BL) cyl(h=plate_z, r=rail_w+2, chamfer2=1);
        move(PEG_TR) cyl(h=plate_z, r=rail_w*2, chamfer2=1);
        move(PEG_BR) cyl(h=plate_z, r=mag_r+1, chamfer2=1);
    }

    // magnet slots 
    #down(2)
    tag("remove")
    attach(["peg_br",  "peg_tl"], BOT, inside=true)
    mag_slot();
    
    // rail cutout
    attach("peg_bl", BOT, inside=true, overlap=-1, spin=90+20.3)
    fwd(55)
    dovetail("female", slide=144, w=rail_w + 2*$slop, h=rail_h + 2*$slop);

}

module peg() {
    cyl(h=PEG_HEIGHT, r= PEG_DIAMETER)
    children();
}

module mag_slot() {
    cyl(h=mag_h, r=mag_r, chamfer2=-.2, chamfang2=60)
    children();
}

//left_plate(spin=-20.3) {
//    color("green") {
//        attach(["peg_tr", "peg_br", "peg_bl", "peg_tl"], BOT)
//        cyl(h=PEG_HEIGHT, r= PEG_DIAMETER);
//
//        zrot(20.3)
//        move([-10,0,-4])
//        diff()
//        cuboid( size=[120, 30, 8]) {
//            edge_profile(edges=[BACK+RIGHT])
//            mask2d_roundover(r=20);
//            edge_profile(edges=[FRONT+RIGHT])
//            mask2d_chamfer(7.3, 20.3);
//
//            // edge slot to accept the edges that holds the laptop
//            align(LEFT, inside=true, overlap=2)
//            fwd(8)
//            down(1-$slop)
//            rail(l=30, w=6 + 2*$slop, h=6 + 2*$slop, chamfer=0)
//            attach(BOT, BOT)
//            rail(l=30, w=6 + 2*$slop, h=6 + 2*$slop, chamfer=0);
//
//            // edge slider to hold the edges onto the laptop
//            align(LEFT, shiftout=4)
//            fwd(8)
//            down(1-$slop)
//            rail(l=20, w=6, h=6 + $slop)
//            attach(BOT, BOT)
//            cuboid(size=[6,20,4], chamfer=1.1, except=[TOP, BOT]);
//
//            // plate down to thumb-cluster
//            right(55)
//            zrot(-20.3)
//            attach(FRONT, BACK, align=BOT, overlap=3)
//            cuboid(size=[15, 65, 8])
//            edge_profile(edges=[FRONT+RIGHT, FRONT+LEFT])
//            mask2d_roundover(r=15/2);
//
//            // plate up to TL pin
//            left(46)
//            zrot(-20.3)
//            attach(BACK, BACK, align=BOT, overlap=3)
//            cuboid(size=[15, 25, 8])
//            edge_profile(edges=[FRONT+RIGHT, FRONT+LEFT])
//            mask2d_roundover(r=15/2);
//
//            // rail slot accepting rail from other keyboard
//            tag("remove")
//            align(BOT, overlap=6)
//            move([55, 0, 2*$slop])
//            ycopies(spacing=12)
//            rail(l=200, w=6 + 2*$slop, h=6 + 2*$slop, spin=90, anchor=BACK, chamfer=0); 
//        }
//    }
//}

{
    PEG_DIAMETER = 1.7;
    PEG_HEIGHT = 1.3;

    x_move = -63.1;
    y_move = -81.9;

    // these are relative to the stl imported with no movement
    PEG_TL = [ 10.4 + x_move, 94 + y_move, 0 ];
    PEG_BL = [ 10.4 + x_move, 59 + y_move, 0 ];
    PEG_TR = [ 105.4 + x_move, 94 + y_move, 0 ];
    PEG_BR = [ 105.4 + x_move, 29 + y_move, 0 ];

    module left_plate(anchor=CENTER, spin=0, orient=UP)
    {

        anchors = [
            named_anchor("peg_tl", PEG_TL, UP, 0),
            named_anchor("peg_tr", PEG_TR, UP, 0),
            named_anchor("peg_br", PEG_BR, UP, 0),
            named_anchor("peg_bl", PEG_BL, UP, 0)
        ];
        attachable(
            size=[130,114, 1],
            anchors=anchors,
            anchor=anchor,
            spin=spin,
            orient=orient
        ) {
            if ($preview) {
                color("grey", 0.2)
                ymove(y_move)
                xmove(x_move)
                import("bottom_plate_left.STL");
            } else {{}}
            children();
        }
    }

    module right_plate(anchor=CENTER, spin=0, orient=UP)
    {
        mirror([1,0,0]) left_plate(anchor=anchor, spin=spin, orient=orient) children();
    }
}
