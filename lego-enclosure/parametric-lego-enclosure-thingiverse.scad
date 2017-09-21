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

/* [LEGO Options plus Plastic and Printer Variance Adjustments] */

// How many Lego units wide the enclosure is
blocks_x = 23;

// How many Lego units long the enclosure is
blocks_y = 10;

// How many Lego units long is the enclosure holder which caps around each end of an object? If this equals blocks_x/2, then the object will be completely enclosed
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
rounding = 64;

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
    dh=(lego_height(z)-skinned_h)/2;
    
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


////// Partial copy of file lego.scad to make this a single file for use in thingiverse.com online generator

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


/////////////////////////////////////

// The round bit on top of a lego block
module knob(top_size_tweak=0, fn=rounding) {
    $fn = fn;
    cylinder(r=knob_radius+top_size_tweak,h=knob_height-knob_bevel);
    translate([0,0,knob_height-knob_bevel]) 
        intersection() {
            cylinder(r=knob_radius+top_size_tweak,h=knob_bevel);
            cylinder(r1=knob_radius+top_size_tweak,r2=0,h=knob_radius+top_size_tweak);
        }
}

// The rectangular part of the the lego plus the knob
module block(z=1, top_size_tweak=0, fn=rounding) {
    cube([block_width,block_width,z*block_height]);
    translate([block_width/2,block_width/2,z*block_height])
        knob(top_size_tweak, fn);
}

// Several blocks in a grid, one knob per block
module block_set(x=2, y=2, z=2, top_size_tweak=0, fn=rounding) {
    for (i = [0:1:x-1]) {
        for (j = [0:1:y-1]) {
            translate([i*block_width,j*block_width,0])
                block(z, top_size_tweak, fn);
        }
    }
}

// That solid outer skin of the block set
module block_shell(x=2, y=2, z=2) {
    cube([block_shell,y*block_width,z*block_height]);
    translate([x*block_width-block_shell,0,0]) 
        cube([block_shell,y*block_width,z*block_height]);
    
    cube([x*block_width,block_shell,z*block_height]);
    translate([0,y*block_width-block_shell,0])
        cube([x*block_width,block_shell,z*block_height]);
    
    translate([0,0,z*block_height-block_shell])
        cube([x*block_width,y*block_width,block_shell]);
}

// Bottom connector- negative space for one block
module socket(bottom_size_tweak=0, fn=rounding) {
    difference() {
        cube([block_width, block_width, socket_height]);
        union() {
            socket_ring(bottom_size_tweak, fn);
            translate([block_width, 0, 0])
                socket_ring(bottom_size_tweak, fn);
            translate([0, block_width, 0]) 
                socket_ring(bottom_size_tweak, fn);
            translate([block_width, block_width, 0])
                socket_ring(bottom_size_tweak, fn);
        }
    }
}

// The circular bottom insert for attaching knobs
module socket_ring(bottom_size_tweak=bottom_connector_tweak, fn=rounding) {
    $fn = fn;
    difference() {
        cylinder(r=ring_radius+bottom_size_tweak, h=socket_height);
        cylinder(r=ring_radius+bottom_size_tweak-ring_thickness, h=socket_height);
    }
}

// Bottom connector- negative space for multiple blocks
module socket_set(x=blocks_x, y=blocks_y, bottom_size_tweak=bottom_connector_tweak, fn=rounding) {
    for (i = [0:1:x-1]) {
        for (j = [0:1:y-1]) {
            translate([i*block_width,j*block_width,0])
                socket(bottom_size_tweak, fn);
        }
    }
}

module skin(x=blocks_x, y=blocks_y, z=blocks_z) {
    difference() {
        cube([block_width*x, block_width*y, z*block_height]);
        translate([skin, skin, 0])
            cube([block_width*x-2*skin, block_width*y-2*skin, z*block_height]);
    }
}

// A complete LEGO block, standard size, specify number of layers in X Y and Z
module lego(x=blocks_x, y=blocks_y, z=blocks_z, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=top_connector_tweak, fn=rounding) {
    difference() {
        union() {
            block_shell(x, y, z, fn);
            difference() {
                block_set(x, y, z, top_size_tweak, fn);
                socket_set(x, y, bottom_size_tweak, fn);
            }
        }
        skin(x, y, z);
    }
}

// Function for access to horizontal size from other modules
function lego_width(x=1) = x*block_width;

// Function for access to vertical size from other modules
function lego_height(z=1) = z*block_height;

// Function for access to outside shell size from other modules
function lego_shell_width() = block_shell;

// Function for access to clearance space from other modules
function lego_skin_width() = skin;

function lego_socket_height() = socket_height;


