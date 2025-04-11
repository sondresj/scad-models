include <BOSL2/std.scad>

$slop = 0.2;

p = 5;
color_this("blue")
diff()
arthur(){
    recolor("magenta")
    attach(BACK, TOP, overlap=.1, shiftout=10)
    backplate(100, p)
    recolor("cyan")
    attach(BOT, BOT, shiftout=-.05)
    spinner(10,p);
}

module arthur(anchor=CENTER, spin=0, orient=UP) {
    ph=23;
    pw=14;
    pd=6;
    p=5;

    attachable(
        size=[pw*p, pd*p, ph*p],
        anchor=anchor,
        spin=spin,
        orient=orient
    ) {
        back(29*p -.5)
        down(3*p+p/2)
        right(2*p)
        scale([50,50,50])
        import("./Arthur.stl", true);
        children();
    };
}

module backplate(r, h) {
    cyl($fn=6, h, r=r)
    attach(TOP, BOT)
    tube($fn=6, h=h, ir=r-h,or=r)
    children();
}

module spinner(r, h, anchor=CENTER, spin=0, orient=UP) {
    module shape(r, h, rounding){
        cyl($fn=90, h=h/2, r1=r, r2=r - sin(10)*r, rounding1=rounding, anchor=anchor, spin=spin, orient=orient)
        attach(TOP, BOT)
        cyl($fn=90, h=h/2, r2=r, r1=r - sin(10)*r, rounding2=rounding, anchor=anchor, spin=spin, orient=orient);
    }

    tag("remove")
    shape(r+$slop, h+.1, rounding=-h/4);

    tag("keep")
    shape(r, h, rounding=.3);
    children();
}
