/*
Parametric LEGO Block

Published at
    http://www.thingiverse.com/thing:2303714
Maintained at
    https://github.com/paulirotta/parametric_lego
See also the related files
    LEGO Sign Generator - https://www.thingiverse.com/thing:2546028
    LEGO Enclosure Generator - https://www.thingiverse.com/thing:2544197


By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution ShareAlike NonCommercial License
    https://creativecommons.org/licenses/by-sa/4.0/legalcode

Work sponsored by
    http://futurice.com

Import this into other design files:
    use <lego.scad>
*/

/* [LEGO Options plus Plastic and Printer Variance Adjustments] */

// What type of object to generate: "lego", "calibration", "panel"
mode="panel";

// How many Lego units wide the brick is
blocks_x = 15;

// How many Lego units long the brick is
blocks_y = 11;

// How many Lego units high the brick is
blocks_z = 1;


// Top connector size tweak => + = more tight fit, -0.04 for PLA, 0 for ABS, 0.07 for NGEN
top_tweak = 0.07;

// Bottom connector size tweak => + = more tight fit, 0.02 for PLA, 0 for ABS, -0.01 NGEN
bottom_tweak = -0.01;

// Number of facets to form a circle (big numbers are more round which affects fit, but may take a long time to render)
fn=64;

// Clearance space on the outer surface of bricks
skin = 0.1;

// Size of the connectors
knob_radius=2.4;

// Height of the connectors including any bevel (1.8 is Lego standard, longer gives a stronger hold which helps since 3D prints are less precise)
knob_height=2.4;

// Height of the easy connect slope near connector top (0 to disable is standard a slightly faster to generate the model, a bigger value such as 0.3 may help if you adjust a tight fit but most printers' slicers will simplify away most usable bevels)
knob_bevel=0;

// Size of the small cavity inside the connectors
knob_cutout_radius=1.25;

// Distance below knob top surface and the internal cutout
knob_top_thickness=1.25;

// Height of the cutout beneatch each knob
knob_cutout_height=4.35;

// Size of the hole to keep the cutout as part of the outside surface for slicer-friendliness. Enlarge this if you need to drain resin from the cutout.
knob_cutout_airhole_radius=0.01;

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
cut_line=6.4;

// Font for calibration block text labels
font = "Arial";

// Text size on calibration blocks
font_size = 3.8;

// Depth of text labels on calibration blocks
text_extrusion_height = 0.5;

// Inset from block edge for text (vertical and horizontal)
text_margin = 1;

// Size between calibration block tweak test steps
calibration_block_increment = 0.01;

/////////////////////////////////////
// Test display, uncomment only one of the following lines at a time
/////////////////////////////////////

if (mode=="calibration") {
    lego_calibration_set(); // A set of blocks for testing which tweak parameters to use on your printer and plastic
} else if (mode=="panel") {
    lego_panel(); // A thin panel of knobs with a flat back and mounting screw holes in the corners, suitable for organizing projects
} else {
    lego(); // A single block
}

/////////////////////////////////////
// FUNCTIONS
/////////////////////////////////////

// Function for access to horizontal size from other modules
function lego_width(x=1) = x*block_width;

// Function for access to vertical size from other modules
function lego_height(z=1) = z*block_height;

// Function for access to outside shell size from other modules
function lego_shell_width() = block_shell;

// Function for access to clearance space from other modules
function lego_skin_width(i=1) = skin*i;

// Function for access to socket height from other modules
function lego_socket_height() = socket_height;

/////////////////////////////////////
// MODULES
/////////////////////////////////////

// A complete LEGO block, standard size, specify number of layers in X Y and Z
module lego(x=blocks_x, y=blocks_y, z=blocks_z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, fn=fn) {
    difference() {
        union() {
            block_shell(x, y, z, fn);
            difference() {
                block_set(x, y, z, top_tweak, fn);
                socket_set(x, y, bottom_tweak, fn);
            }
        }
        skin(x, y, z);
    }
}


// Several blocks in a grid, one knob per block
module block_set(x=blocks_x, y=blocks_y, z=blocks_z, top_tweak=top_tweak, fn=fn) {
    for (i = [0:1:x-1]) {
        for (j = [0:1:y-1]) {
            translate([lego_width(i), lego_width(j), 0])
                block(z=z, top_size_tweak=top_tweak, knob_height=knob_height,knob_cutout_height=knob_cutout_height, knob_cutout_radius=knob_cutout_radius, knob_cutout_airhole_radius=knob_cutout_airhole_radius, fn=fn);
        }
    }
}


// The rectangular part of the the lego plus the knob
module block(z=bocks_z, top_tweak=top_tweak, knob_height=knob_height, knob_cutout_height=knob_cutout_height, knob_cutout_radius=knob_cutout_radius, knob_cutout_airhole_radius=knob_cutout_airhole_radius, fn=fn) {
    difference() {
        union() {
            cube([lego_width(), lego_width(), lego_height(z)]);
            translate([lego_width(0.5), lego_width(0.5), lego_height(z)])
                knob(top_tweak=top_tweak, knob_bevel=knob_bevel, fn=fn);
        }
        translate([lego_width(0.5), lego_width(0.5), lego_height(z)])
            knob_cutout(knob_height=knob_height, knob_cutout_height=knob_cutout_height, knob_cutout_radius=knob_cutout_radius, knob_cutout_airhole_radius=knob_cutout_airhole_radius, fn=fn);
    }
}


// The cylinder on top of a lego block
module knob(top_tweak=top_tweak, knob_bevel=knob_bevel, fn=fn) {
    cylinder(r=knob_radius+top_tweak, h=knob_height-knob_bevel, $fn=fn);
    if (knob_bevel > 0) {
        // This path is a bit slower, but does the same thing as the bath below for the most common case of knob_bevel==0
        translate([0, 0, knob_height-knob_bevel])
            intersection() {
                cylinder(r=knob_radius+top_tweak,h=knob_bevel, $fn=fn);
                cylinder(r1=knob_radius+top_tweak,r2=0,h=knob_radius+top_tweak, $fn=fn);
            }
    }
}


// The empty cylinder inside a knob
module knob_cutout(knob_height=knob_height, knob_cutout_height=knob_cutout_height, knob_cutout_radius=knob_cutout_radius, knob_cutout_airhole_radius=knob_cutout_airhole_radius, fn=fn) {
    cylinder(r=knob_cutout_airhole_radius, h=knob_height+0.1, $fn=fn);
    translate([0, 0, knob_height-knob_top_thickness-knob_cutout_height])
        cylinder(r=knob_cutout_radius, h=knob_cutout_height, $fn=fn);
}


// That solid outer skin of a block set
module block_shell(x=blocks_x, y=blocks_y, z=blocks_z) {
    cube([block_shell, lego_width(y), lego_height(z)]);
    translate([lego_width(x)-block_shell, 0, 0]) 
        cube([block_shell, lego_width(y), lego_height(z)]);
    
    cube([lego_width(x), block_shell, lego_height(z)]);
    translate([0, lego_width(y)-block_shell, 0])
        cube([lego_width(x), block_shell, lego_height(z)]);
    
    translate([0, 0, lego_height(z)-block_shell])
        cube([lego_width(x), lego_width(y), block_shell]);
}

// Bottom connector- negative space for one block
module socket(bottom_tweak=bottom_tweak, fn=fn) {
    difference() {
        cube([lego_width(), lego_width(), socket_height]);
        union() {
            socket_ring(bottom_tweak, fn);
            translate([lego_width(), 0, 0])
                socket_ring(bottom_tweak, fn);
            translate([0, lego_width(), 0]) 
                socket_ring(bottom_tweak, fn);
            translate([lego_width(), lego_width(), 0])
                socket_ring(bottom_tweak, fn);
        }
    }
}

// The circular bottom insert for attaching knobs
module socket_ring(bottom_tweak=bottom_tweak, fn=fn) {
    difference() {
        cylinder(r=ring_radius+bottom_tweak, h=socket_height, $fn=fn);
        cylinder(r=ring_radius+bottom_tweak-ring_thickness, h=socket_height, $fn=fn);
    }
}

// Bottom connector- negative space for multiple blocks
module socket_set(x=blocks_x, y=blocks_y, bottom_tweak=bottom_tweak, fn=fn) {
    for (i = [0:1:x-1]) {
        for (j = [0:1:y-1]) {
            translate([lego_width(i), lego_width(j), 0])
                socket(bottom_tweak, fn);
        }
    }
}

// The thin negative space surrounding a LEGO block so that two blocks can fit next to each other easily in a tight grid
module skin(x=blocks_x, y=blocks_y, z=blocks_z) {
    difference() {
        cube([lego_width(x), lego_width(y), lego_height(z)]);
        translate([lego_skin_width(), lego_skin_width(), 0])
            cube([lego_width(x)-lego_skin_width(2), lego_width(y)-lego_skin_width(2), lego_height(z)]);
    }
}

// A set of blocks with different tweak parameters written on the side
module lego_calibration_set(x=blocks_x, y=blocks_y, fn=fn) {
    for (i = [0:5]) {
        translate([i*lego_width(x+0.5), 0, 0])
            lego_calibration_block(x=x, y=y, top_tweak=i*calibration_block_increment, bottom_tweak=-i*calibration_block_increment, fn=fn);
    }
    
    for (i = [6:10]) {
        translate([(i-5)*lego_width(x+0.5), -lego_width(y+0.5), 0])
            lego_calibration_block(x=x, y=y, top_tweak=i*calibration_block_increment, bottom_tweak=-i*calibration_block_increment, fn=fn);
    }
    
    for (i = [1:5]) {
        translate([i*lego_width(x + 0.5), lego_width(y+0.5), 0])
            lego_calibration_block(x=x, y=y, top_tweak=-i*calibration_block_increment, bottom_tweak=i*calibration_block_increment, fn=fn);
    }
}

// A block with the tweak parameters written on the side
module lego_calibration_block(x=blocks_x, y=blocks_y, top_tweak=0, bottom_tweak=0, fn=fn) {
    difference() {
        lego(x=x, y=y, z=1, top_tweak=top_tweak, bottom_tweak=bottom_tweak, fn=fn);

        union() {
            translate([text_extrusion_height, lego_skin_width()+lego_width(y)-text_margin, lego_skin_width()+lego_height()-text_margin])
                rotate([90,0,-90]) 
                    lego_calibration_top_text(str("^", top_size_tweak));
            
            translate([lego_skin_width()+text_margin, lego_width(y)-text_extrusion_height, lego_skin_width()+text_margin])
                rotate([90, 0, 180])
                    lego_calibration_bottom_text(str(bottom_size_tweak, "v"));
        }
    }
}

// Text for the left side of calibration block prints
module lego_calibration_top_text(txt="Text") {
    linear_extrude(height=text_extrusion_height) {
    text(text=txt, font=font, size=font_size, halign="left", valign="top");
     }
}

// Text for the back side of calibration block prints
module lego_calibration_bottom_text(txt="Text") {
    linear_extrude(height=text_extrusion_height) {
       text(text=txt, font=font, size=font_size, halign="right");
     }
}


/////////////////////////////////////
// LEGO PANEL
//
// LEGO knobs on a thin, flat-back panel with holes for mounting screws
// in the corners
/////////////////////////////////////

module lego_panel(x=blocks_x, y=blocks_y, top_size_tweak=top_tweak, cut_line=cut_line, fn=fn) {
    difference() {
        intersection() {
            lego(x=x, y=y, z=1, top_tweak=top_tweak, bottom_tweak=0, fn=fn);
            translate([0, 0, cut_line])
                cube([lego_width(x), lego_width(y), 2*lego_height()]);
        }
        union() {
            screw_hole(1, 1, top_size_tweak, fn);
            screw_hole(1, y, top_size_tweak, fn);
            screw_hole(x, 1, top_size_tweak, fn);
            screw_hole(x, y, top_size_tweak, fn);
        }
    }
}


// A hole for mounting screws in the corners of a panel
module screw_hole(x=1, y=1, top_size_tweak=top_tweak, fn=fn) {
    translate([lego_width(x-0.5), lego_width(y-0.5), 0])
        cylinder(r=knob_radius+top_size_tweak, h=10, $fn=fn);
}
