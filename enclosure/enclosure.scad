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

// Inset from block edge for text (vertical and horizontal)
text_margin = 1;

support_shoulder = 3;

/////////////////////////////////////

// Test display
//lego(fn=16);
lego_enclosure(l=173, w=68, h=28, x=23, x2=2, y=10, z=4, shoulder=support_shoulder, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=top_connector_tweak);

///////////////////////////////////


// A Lego brick with a hole inside to contain something of the specified dimensions
module lego_enclosure(l=20, w=10, h=5, x=3, xb=4, y=2, z=2, shoulder=3, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=bottom_connector_tweak, fn=rounding) {
    
    // Add some margin to give space to fit the part
    skinned_l = l + 2*lego_skin_width();
    skinned_w = w + 2*lego_skin_width();
    skinned_h = h + 2*lego_skin_width();
    
    // Inner box dimensions
    dl=(lego_width(x)-skinned_l)/2;
    dw=(lego_width(y)-skinned_w)/2;
    dh=(lego_height(z)-skinned_h+lego_socket_height()/2)/2;
    
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
