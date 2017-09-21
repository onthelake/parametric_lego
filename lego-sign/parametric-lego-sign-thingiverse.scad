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
    use <parametric-lego-sign.scad>
*/

/* [LEGO Options plus Plastic and Printer Variance Adjustments] */

// The top line of text. Set to "" to not have any top line
text_line_1 = "LEGO Robotics";

// The second line of text
text_line_2 = "Rapid Prototyping";

// Language of the text
text_language = "en";

// The font to use for text on the top line
font_line_1 = "Liberation Sans:style=Bold Italic";

// The font to use for text on the bottom line
font_line_2 = "Arial";

// The font size (points) of the top line
font_size_line_1 = 5.8;

// The font size (points) of the top line
font_size_line_2 = 5;

// How deeply into the LEGO block to etch/extrude the text
text_extrusion_height = 0.7;

// Text is pushing out from the LEGO block. Set false to etch the text into the block
extrude = false;

// Place the text on both sides
copy_to_back = false;

// How many LEGO units wide the enclosure is
blocks_x = 8;

// How many LEGO units long the enclosure is
blocks_y = 1;

// How many LEGO units high the enclosure is
blocks_z = 2;

// Left corner horizontal position of the text
text_x_inset = 3;

// Bottom / top corner vertical position of the text
text_z_inset = 3;

// Top connector size tweak => + = more tight fit, 0 for ABS, 0.04 for PLA, 0.08 for NGEN
top_connector_tweak = 0;

// Bottom connector size tweak => - = more loose fit, 0 for ABS, -0.04 for PLA, -0.08 NGEN
bottom_connector_tweak = 0;

// Number of facets to form a circle (big numbers are more round which affects fit, but may take a long time to render)
rounding=64;

/////////////////////////////////////

// Test display
lego_sign();

///////////////////////////////////

// A LEGO brick with text on the side
module lego_sign(line_1=text_line_1, line_2=text_line_2, lang=text_language, e=extrude,  extrusion_height=text_extrusion_height, f1=font_line_1, f2=font_line_2, fs1=font_size_line_1, fs2=font_size_line_2, tx=text_x_inset, tz=text_z_inset, xb=blocks_x, yb=blocks_y, zb=blocks_z, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=bottom_connector_tweak, fn=rounding) {
    if (e) {
        lego(x=xb, y=yb, z=zb, bottomw_connector_tweak=bottom_size_tweak, top_connector_tweak=top_size_tweak, fn=fn);
        translate([lego_skin_width(), lego_skin_width(), lego_skin_width()])
            lego_sign_extruded_text(line_1, line_2, lang, extrusion_height, f1, f2, fs1, fs2, tx, tz, xb, yb, zb, bottom_size_tweak, top_size_tweak, fn);

        if (copy_to_back) {
            translate([lego_skin_width()+lego_width(xb), lego_width(yb), lego_skin_width()])
                rotate([0, 0, 180])
                    lego_sign_extruded_text(line_1, line_2, lang, extrusion_height, f1, f2, fs1, fs2, tx, tz, xb, yb, zb, bottom_size_tweak, top_size_tweak, fn);
        }
    } else {
        difference() {
            lego(x=xb, y=yb, z=zb, bottom_connector_tweak=bottom_size_tweak, top_connector_tweak=top_size_tweak, fn=fn);
            union() {
                translate([lego_skin_width(), 0, lego_skin_width()])
                    lego_sign_etched_text(line_1, line_2, lang, extrusion_height+lego_skin_width(), f1, f2, fs1, fs2, tx, tz, xb, yb, zb, bottom_size_tweak, top_size_tweak, fn);

 #                   if (copy_to_back) {
                         translate([lego_skin_width()+lego_width(xb), lego_skin_width()+lego_width(yb), lego_skin_width()])
                             rotate([0, 0, 180])
                                 lego_sign_etched_text(line_1, line_2, lang, extrusion_height+lego_skin_width(), f1, f2, fs1, fs2, tx, tz, xb, yb, zb, bottom_size_tweak, top_size_tweak, fn);
                    }
                }
            }
    }
}

// Two lines of text extruded out from the surface
module lego_sign_extruded_text(line_1=text_line_1, line_2=text_line_2, lang=text_language,  extrusion_height=text_extrusion_height, f1=font_line_1, f2=font_line_2, fs1=font_size_line_1, fs2=font_size_line_2, tx=text_x_inset, tz=text_z_inset, xb=blocks_x, yb=blocks_y, zb=blocks_z, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=bottom_connector_tweak, fn=rounding) {
    translate([tx, 0, lego_height(zb)-tz])
        lego_text(txt=line_1, language=lang, font=f1, font_size=fs1, vertical_alignment="top");
    translate([tx, 0, tz])
        lego_text(txt=line_2, language=lang, font=f2, font_size=fs2, vertical_alignment="bottom");
}

// Two lines of text etched into the surface
module lego_sign_etched_text(line_1=text_line_1, line_2=text_line_2, lang=text_language,  extrusion_height=text_extrusion_height, f1=font_line_1, f2=font_line_2, fs1=font_size_line_1, fs2=font_size_line_2, tx=text_x_inset, tz=text_z_inset, xb=blocks_x, yb=blocks_y, zb=blocks_z, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=bottom_connector_tweak, fn=rounding) {
    translate([tx, extrusion_height, lego_height(zb)-tz])
        lego_text(txt=line_1, l=lang, extrusion_height=extrusion_height, font=f1, font_size=fs1, vertical_alignment="top");
    translate([tx, extrusion_height, tz])
        lego_text(txt=line_2, l=lang, extrusion_height=extrusion_height, font=f2, font_size=fs2, vertical_alignment="baseline");
}

// Text for the side of calibration block prints
module lego_text(txt=text_line_1, l=text_language, extrusion_height=text_extrusion_height, font=font_line_1, font_size=font_size_line_1, vertical_alignment="bottom") {
    rotate([90,0,0])
        linear_extrude(height=extrusion_height)
            text(text=txt, language=l, font=font, size=font_size, halign="left", valign=vertical_alignment);
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




