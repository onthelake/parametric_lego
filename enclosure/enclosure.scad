/*
Parametric LEGO Anker USB Enclosure

Published at
    http://www.thingiverse.com/thing:2303714
Maintained at
    https://github.com/paulirotta/parametric_lego

By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution ShareAlike NonCommercial License
https://creativecommons.org/licenses/by-sa/4.0/legalcode

Import this into other design files:
    use <anker-usb-lego-enclosure.scad>
*/

use <../lego.scad>

/* [LEGO Options plus Plastic and Printer Variance Adjustments] */

// How many Lego units wide the brick is
blocks_x = 2;

// How many Lego units long the brick is
blocks_y = 4;

// How many Lego units high the brick is
blocks_z = 1;

// Top connector size tweak => 0 for ABS, 0.04 for tighter, -0.04 for PLA/NGEN/less tight
top_connector_tweak = 0;

// Bottom connector size tweak => 0 for ABS, -0.04 for tighter, 0.04 for bigger/PLA/NGEN/less tight
bottom_connector_tweak = 0;

// Number of facets to form a circle (big numbers are more round which affects fit, but may take a long time to render)
rounding=64;

// Clearance space on the outer surface of bricks
skin = 0.1;

// Size of the connectors
knob_radius=2.4;

// Total height of the connectors (1.8 is Lego standard, longer gives a stronger hold which helps since 3D prints are less precise)
knob_height=2.4;

// Height of the easy connect slope near connector top (0 to disable, helps if you adjust a tight fit)
knob_bevel=0.3;

// Depth which connectors may press into part bottom
socket_height=6;

// Bottom connector assistance ring size
ring_radius=3.25;

// Bottom connector assistance ring thickness
ring_thickness=0.8;

// Basic unit horizonal size of LEGO
block_width=8;

// Basic unit vertial size of LEGO
block_height=9.6;

// Thickness of the solid outside surface of LEGO
block_shell=1.3; // thickness

// Lego panel height (flat back panel with screw holes in corners
cut_line_height=7.6;

// Font for calibration block text labels
font = "Arial";

// Text size on calibration blocks
font_size = 4;

// Depth of text labels on calibration blocks
text_extrusion_height = 0.7;

// Inset from block edge for text (vertical and horizontal)
text_margin = 1;



/////////////////////////////////////

// Test display
//lego(fn=16);
lego_enclosure(l=173, w=68, h=28, x=23, x2=2, y=10, z=4, shoulder=3, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=top_connector_tweak);

///////////////////////////////////


// A Lego brick with a hole inside to contain something of the specified dimensions
module lego_enclosure(l=20, w=10, h=5, x=3, xb=2, y=2, z=2, shoulder=3, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=bottom_connector_tweak, fn=rounding) {
    
    // Add some margin to give space to fit the part
    skinned_l = l + 2*skin;
    skinned_w = w + 2*skin;
    skinned_h = h + 2*skin;
    
    // Inner box dimensions
    x2=x*block_width;
    y2=y*block_width;
    z2=z*block_height;
    dl=(x2-skinned_l)/2;
    dw=(y2-skinned_w)/2;
    dh=(z2-skinned_h)/2;
    
    difference() {
        lego(xb, y, z, bottom_size_tweak, top_size_tweak, fn);
        translate([dl, dw, dh])
            enclosure_negative_space(skinned_l, skinned_w, skinned_h, shoulder);
    }
}

// Where to remove material
module enclosure_negative_space(l=20, w=10, h=5, shoulder=1) {
    ls = l - 2*shoulder;
    ws = w - 2*shoulder;
    hs = h - 2*shoulder;
    ls2 = ls+l;
    ws2 = ws+w;
    hs2 = hs+h;
    
    // Primary enclosure hole
    cube([l,w,h]);
    // Right air hole
    translate([l,shoulder,shoulder])
        cube([ls2,ws,hs]);
    // Left air hole
    translate([-ls2,shoulder,shoulder])
        cube([ls2,ws,hs]);
    // Back air hole
    translate([shoulder,w,shoulder])
        cube([ls,ws2,hs]);
    // Front air hole
    translate([shoulder,-ws2,shoulder])
        cube([ls,ws2,hs]);
    // Top air hole
    translate([shoulder,shoulder,h])
        cube([ls,ws,hs2]);
    // Bottom air hole
    translate([shoulder,shoulder,-hs2])
        cube([ls,ws,hs2]);
}
