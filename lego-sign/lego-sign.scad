/*
Parametric LEGO End Cap Enclosure Generator

Create 2 symmetric end pieces which can support a solid object with LEGO-compatible attachment points on top and bottom. By printing only the end pieces instead of a complele enclosure, the print is minimized

Published at
    https://www.thingiverse.com/thing:2546028
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

Work sponsored by
    http://futurice.com

Import this into other design files:
    use <parametric-lego-sign.scad>
*/

use <../lego.scad>

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
text_extrusion_height = 0.5;

// Text is pushing out from the LEGO block. Set false to etch text into the block
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

// Top connector size tweak => + = more tight fit, -0.04 for PLA, 0 for ABS, 0.08 for NGEN
top_connector_tweak = 0;

// Bottom connector size tweak => + = more tight fit, 0.02 for PLA, 0 for ABS, -0.01 NGEN
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

