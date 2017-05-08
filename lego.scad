/*
Parametric LEGO Block

Published at
    http://www.thingiverse.com/thing:2303714
Maintained at
    https://github.com/paulirotta/parametric_lego

By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution ShareAlike License
https://creativecommons.org/licenses/by-sa/4.0/legalcode

Import this into other design files:
    use <lego.scad>
*/

/* [LEGO Options] */

// Top connector size tweak => 0 for ABS, -0.05 for PLA/ NGEN/less tight
top_connector_tweak = 0;

// Bottom connector size tweak => 0 for ABS, -0.05 for PLA/NGEN/less tight
bottom_connector_tweak = 0;

// Number of facets to form a circle
$fn=32;

// Clearance space on the outer surface of bricks
skin = 0.1;

// Size of the connectors
knob_radius=2.4;

// Height of the connectors
knob_height=1.8;

// Depth which connectors may press into part bottom
socket_height=3;

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



// Test display
lego(4,2,1,top_connector_tweak,bottom_connector_tweak);




// The round bit on top of a lego block
module knob(top_size_tweak=0) {
    cylinder(r=knob_radius+top_size_tweak,h=knob_height);
}

// The rectangular part of the the lego plus the knob
module block(z=1,top_size_tweak=0) {
    cube([block_width,block_width,z*block_height]);
    translate([block_width/2,block_width/2,z*block_height])
        knob(top_size_tweak);
}

// Several blocks in a grid, one knob per block
module block_set(x=2,y=2,z=2,top_size_tweak=0) {
    for (i = [0:1:x-1]) {
        for (j = [0:1:y-1]) {
            translate([i*block_width,j*block_width,0])
                block(z,top_size_tweak);
        }
    }
}

// That solid outer skin of the block set
module block_shell(x=2,y=2,z=2) {
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
module socket(bottom_size_tweak=0) {
    difference() {
        cube([block_width,block_width,socket_height]);
        union() {
            translate([0,0,0])
                socket_ring(bottom_size_tweak);
            translate([block_width,0,0])
                socket_ring(bottom_size_tweak);
            translate([0,block_width,0]) 
                socket_ring(bottom_size_tweak);
            translate([block_width,block_width,0])
                socket_ring(bottom_size_tweak);
        }
    }
}

// The circular bottom insert for attaching knobs
module socket_ring(bottom_size_tweak=0) {
    difference() {
        cylinder(r=ring_radius+bottom_size_tweak,h=socket_height);
        cylinder(r=ring_radius+bottom_size_tweak-ring_thickness,h=socket_height);
    }
}

// Bottom connector- negative space for multiple blocks
module socket_set(x=2,y=2,bottom_size_tweak=0) {
    for (i = [0:1:x-1]) {
        for (j = [0:1:y-1]) {
            translate([i*block_width,j*block_width,0])
                socket(bottom_size_tweak);
        }
    }
}

module skin(x=2,y=2,z=2) {
    difference() {
        cube([block_width*x,block_width*y,z*block_height]);
        translate([skin,skin,0])
            cube([block_width*x - 2*skin,block_width*y - 2*skin,z*block_height]);
    }
}

// A complete LEGO block, standard size, specify number of layers in X Y and Z
module lego(x=2,y=2,z=2,bottom_size_tweak=0,top_size_tweak=0) {
    difference() {
        union() {
            block_shell(x,y,z);
            difference() {
                block_set(x,y,z,top_size_tweak);
                socket_set(x,y,bottom_size_tweak);
            }
        }
        skin(x,y,z);
    }
}

// Function for access to horizontal size from other modules
function lego_width(x=1) = x*block_width;

// Function for access to vertical size from other modules
function lego_height(z=1) = z*block_height + knob_height;

// Function for access to outside shell size from other modules
function lego_shell_width() = block_shell;

// Function for access to clearance space from other modules
function lego_skin_width() = skin;
