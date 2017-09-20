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

use <../lego.scad>

/* [LEGO Options plus Plastic and Printer Variance Adjustments] */

// The top line of text. Set to "" to not have any top line
text_line_1 = "LEGO Robotics";

// The second line of text
text_line_2 = "Rapid Prototyping";

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
module lego_sign(line_1=text_line_1, line_2=text_line_2, e=extrude,  extrusion_height=text_extrusion_height, f1=font_line_1, f2=font_line_2, fs1=font_size_line_1, fs2=font_size_line_2, tx=text_x_inset, tz=text_z_inset, xb=blocks_x, yb=blocks_y, zb=blocks_z, bottom_size_tweak=bottom_connector_tweak, top_size_tweak=bottom_connector_tweak, fn=rounding) {
    if (e) {
        lego(xb, yb, zb, bottom_size_tweak, top_size_tweak, fn);
        translate([tx, 0, lego_height(zb)-tz])
            lego_text(line_1, e, font=f1, font_size=fs1, vertical_alignment="top");
        translate([tx, 0, tz])
            lego_text(line_2, e, font=f2, font_size=fs2, vertical_alignment="bottom");
    } else {
        translate([0,extrusion_height,0])
            difference() {
                lego(xb, yb, zb, bottom_size_tweak, top_size_tweak, fn);
                union() {
                    translate([tx, text_extrusion_height, lego_height(zb)-tz])
                        lego_text(line_1, e, extrusion_height, font=f1, font_size=fs1, vertical_alignment="top");
                    translate([tx, text_extrusion_height, tz])
                        lego_text(line_2, e, extrusion_height, font=f2, font_size=fs2, vertical_alignment="baseline");
                }
            }
    }
}


// Text for the side of calibration block prints
module lego_text(txt=text_line_1, e=extrude,  extrusion_height=text_extrusion_height, font=font_line_1, font_size=font_size_line_1, vertical_alignment="bottom") {
    rotate([90,0,0])
        linear_extrude(height=extrusion_height)
            text(text=txt, font=font, size=font_size, halign="left", valign=vertical_alignment);
}

