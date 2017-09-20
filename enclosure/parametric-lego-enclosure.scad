/*
Parametric LEGO End Cap Enclosure Generator

Create 2 symmetric end pieces which can support a solid object with LEGO-compatible attachment points on top and bottom. By printing only the end pieces instead of a complele enclosure, the print is minimized

Published at
    https://www.thingiverse.com/thing:2544197
Based on
    https://www.thingiverse.com/thing:2303714
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

// How many Lego units wide the enclosure is
blocks_x = 23;

// How many Lego units long the enclosure is
blocks_y = 10;

// How many Lego units long is the enclosure holder
blocks_x_end_cap = 4;

// How many Lego units high the enclosure is
blocks_z = 4;

// Length of the object to be enclosed
enclosed_length = 173;

// Width of the object to be enclosed
enclosed_width = 68;

// Height of the object to be enclosed
enclosed_height = 28;

// Top connector size tweak => + = more tight fit, 0 for ABS, 0.04 for PLA, 0.08 for NGEN
top_connector_tweak = 0;

// Bottom connector size tweak => - = more loose fit, 0 for ABS, -0.04 for PLA, -0.08 NGEN
bottom_connector_tweak = 0;

// Number of facets to form a circle (big numbers are more round which affects fit, but may take a long time to render)
rounding=64;

// The size of the step in each corner which supports the enclosed part while providing ventilation holes to remove heat
support_shoulder = 3;

/////////////////////////////////////

// Test display
rotate([0,-90,0])
    lego_enclosure();

///////////////////////////////////


// A Lego brick with a hole inside to contain something of the specified dimensions
module lego_enclosure(l=enclosed_length, w=enclosed_width, h=enclosed_height, x=blocks_x, x_cap=blocks_x_end_cap, y=blocks_y, z=blocks_z, shoulder=support_shoulder, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=bottom_connector_tweak, fn=rounding) {
    
    // Add some margin to give space to fit the part
    skinned_l = l + 2*lego_skin_width();
    skinned_w = w + 2*lego_skin_width();
    skinned_h = h + 2*lego_skin_width();
    
    // Inner box dimensions
    dl=(lego_width(x)-skinned_l)/2;
    dw=(lego_width(y)-skinned_w)/2;
    dh=(lego_height(z)-skinned_h+lego_socket_height()/2)/2;
    
    difference() {
        lego(x_cap, y, z, bottom_size_tweak, top_size_tweak, fn);
        translate([dl, dw, dh])
            enclosure_negative_space(skinned_l, skinned_w, skinned_h, shoulder);
    }
}

// Where to remove material to privide access for attachments and air ventilation
module enclosure_negative_space(l=enclosed_length, w=enclosed_width, h=enclosed_height, shoulder=support_shoulder) {
    ls = l - 2*shoulder;
    ws = w - 2*shoulder;
    hs = h - 2*shoulder;
    ls2 = ls+l;
    ws2 = ws+w;
    hs2 = hs+h;
    
    // Primary enclosure hole
    cube([l, w, h]);
    // Right air hole
    translate([l, shoulder, shoulder])
        cube([ls2, ws, hs]);
    // Left air hole
    translate([-ls2, shoulder, shoulder])
        cube([ls2, ws, hs]);
    // Back air hole
    translate([shoulder, w, shoulder])
        cube([ls, ws2, hs]);
    // Front air hole
    translate([shoulder, -ws2, shoulder])
        cube([ls, ws2, hs]);
    // Top air hole
    translate([shoulder, shoulder, h])
        cube([ls, ws, hs2]);
    // Bottom air hole
    translate([shoulder, shoulder, -hs2])
        cube([ls, ws, hs2]);
}
