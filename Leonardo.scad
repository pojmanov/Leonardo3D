$fn=100;

CharcoalColor = [60/255, 65/255, 66/255];
LightBlackColor = [50/255, 50/255, 50/255];
SignalBlackColor = [40/255, 40/255, 40/255];
GrayBlackColor = [35/255, 40/255, 43/255];

module Board(boardH = 1.5)
{
    holeD = 3.2;
    
    boardPoints = [[0, 0], [0, 53.34], [64.55 ,53.34], [66.05, 51.84], /* скос справа сверху приняли в 1.5*/
    [66.05, 40], [68.59, 37.46], [68.59, 5.08], [66.05, 2.54], [66.05, 0]];

    holesPos = [[66.04, 7.64, -1], [66.04, 35.59, -1], [15.24, 50.8, -1], [13.97, 2.54, -1]];

    difference()
    {
        linear_extrude(height = boardH, center = false) polygon(boardPoints);

        for(hpos = holesPos)
        {
            translate(hpos)
            cylinder(h=boardH + 2, d = holeD);
        }
    }
}

module PowerConnector() // [14, 9, 11]
{
    color("DarkGray")
    difference()
    {
        union()
        {
            cube([3.3, 9.0, 11.0]);
            cube([14.0, 9.0, 6.5]);
            translate([0, 4.5, 6.5])
            rotate([0,90,0])
            cylinder(d=8,h=14);
        }
        translate([-0.1,4.5, 6.5])
        rotate([0,90,0])
        cylinder(d=6.4,h=13);
    }

    translate([1,4.5, 6.5])
    rotate([0,90,0])
    color("Gold") cylinder(d=1.65,h=13-0.1);
}

// [6,6]
module MicroButton()
{
    color("DarkGray") cube([6, 6, 3.4]);
    color("Red") translate([3,3,1]) cylinder(d=3.5, h=3.3);
}

// [5.5, 7.4, 2.4]
module MicroUsb()
{
    usbPoints = [[1.45,0],[0,1],[0,2.40],[7.4, 2.4], [7.4,1],[5.95, 0]];
    rotate([90,0,90])
    linear_extrude(height = 5.5, center = false) polygon(usbPoints);
}

// pin connector - female
module PinF(count = 4, h = 8.5, legH = 10)
{
    unit = 2.54;
    hole = 1;
    legWidth = 0.64;
    holeH = 6.1;
    holeOffset = (unit-hole)/2;
    legOffset = (unit-legWidth)/2;
    
    for(i = [0:count-1])
    {
        translate([i*unit,0,0])
        color(LightBlackColor)
        difference()
        {
            cube([unit,unit,h]);
            translate([holeOffset,holeOffset,h-holeH+0.1])
                cube([hole,hole,holeH]);
        }
        if (legH > 0)
        {
            translate([i*unit+legOffset,legOffset,-legH])
            cube([legWidth,legWidth,legH]);
        }
    }
}

// pin connector - male
module PinM(count = 4, h = 6, legH = 3)
{
    unit = 2.54;
    legWidth = 0.64;
    legOffset = (unit-legWidth)/2;
    
    for(i = [0:count-1])
    {
        translate([i*unit,0,0])
        color(LightBlackColor)
        cube([unit,unit,unit]);
        
        translate([i*unit+legOffset,legOffset,-legH])
        cube([legWidth,legWidth,legH+unit+h]);
    }
}

module Leonardo()
{
    boardH = 1.5;

    color("Teal")
    Board(boardH);

    translate([-3, 8.49 - 4.5, boardH]) PowerConnector();

    translate([3.36, 46.4, boardH]) MicroButton();

    color("Silver")
    translate([0, 35.8, boardH]) MicroUsb();
    
    legsH=boardH + 1.5; //3
    // btm pins
    translate([27.95-2.54/2, 2.54/2, boardH]) PinF(count=8, legH=legsH);
    translate([49.54, 2.54/2, boardH]) PinF(count=6, legH=legsH);
    
    // top pins
    translate([18.80-2.54/2, 53.34-2.54*1.5, boardH]) PinF(count=10, legH=legsH);
    translate([44.45, 53.34-2.54*1.5, boardH]) PinF(count=8, legH=legsH);
    
    // icsp pins
    translate([68.59-2.54*2.5, 25.4-2.54/2, boardH]) PinM(count=2, legH=legsH);
    translate([68.59-2.54*2.5, 25.4+2.54/2, boardH]) PinM(count=2, legH=legsH);
    translate([68.59-2.54*2.5, 25.4+2.54*1.5, boardH]) PinM(count=2, legH=legsH);
    
    // cpu :)
    translate([40, 15, boardH])
    color(SignalBlackColor)
    cube([10,10,1]);
}

Leonardo();