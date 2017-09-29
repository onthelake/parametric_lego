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

Design work kindly sponsored by
    http://futurice.com

Import this into other design files:
    use <lego-sign.scad>
*/

use <../lego.scad>

/* [LEGO Options plus Plastic and Printer Variance Adjustments] */

// The top line of text. Set to "" to not have any top line
line_1 = "LEGO Robotics";

// The second line of text
line_2 = "Rapid Prototyping";

// Language of the text
lang = "en";

// The font to use for text on the top line
f1 = "Liberation Sans:style=Bold Italic";

// The font to use for text on the bottom line
f2 = "Arial";

// The font size (points) of the top line
fs1 = 5.8;

// The font size (points) of the bottom line
fs2 = 5;

// How deeply into the LEGO block to etch/extrude the text
extrusion_height = 0.5;

// "true" means text is pushing outward from the LEGO block. Set "false" to etch text into the block
extrude = "false";

// Place the text on both sides
copy_to_back = "false";

// How many LEGO units wide the sign is
x = 8;

// How many LEGO units deep the sign is
y = 1;

// How many LEGO units high the sign is
z = 2;

// Top connector size tweak => + = more tight fit, -0.04 for PLA, 0 for ABS, 0.07 for NGEN
top_tweak = 0;

// Bottom connector size tweak => + = more tight fit, 0.02 for PLA, 0 for ABS, -0.01 NGEN
bottom_tweak = 0;

// Left text margin (mm)
left_margin = 3;

// Top and bottom text margin (mm)
vertical_margin = 3;

// Number of facets to form a circle (big numbers are more round which affects fit, but may take a long time to render)
fn=64;

// Number of side to simulate a circle in the air hole and (smaller numbers render faster and are usually sufficient)
airhole_fn=16;

// Height of the connectors including any bevel (1.8 is Lego standard, longer gives a stronger hold which helps since 3D prints are less precise)
knob_height=2.4;

// Size of the small cavity inside the connectors
knob_cutout_radius=1.25;

// Height of the cutout beneath each knob
knob_cutout_height=4.55;

// Size of the top hole in each knob to keep the cutout as part of the outside surface for slicer-friendliness. Use a larger number if you need to drain resin from the cutout. If z height of the block is 1, no airhole is added to the model since the cutout is open from below.
knob_cutout_airhole_radius=0.01;

// Place holes in the corners of the panel for mountings screws (set "true" or "false")
bolt_holes="false";


/////////////////////////////////////
// Sign Display

lego_sign();

///////////////////////////////////

// A LEGO brick with text on the side
module lego_sign(line_1=line_1, line_2=line_2, lang=lang, extrude=extrude,  extrusion_height=extrusion_height, f1=f1, f2=f2, fs1=fs1, fs2=fs2, left_margin=left_margin, vertical_margin=vertical_margin, x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, knob_height=knob_height, knob_cutout_height=knob_cutout_height, knob_cutout_radius=knob_cutout_radius, knob_cutout_airhole_radius=knob_cutout_airhole_radius, bolt_holes=bolt_holes, fn=fn, airhole_fn=airhole_fn) {
    if (is_true(extrude)) {
        lego(x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, knob_height=knob_height, knob_cutout_height=knob_cutout_height, knob_cutout_radius=knob_cutout_radius, knob_cutout_airhole_radius=knob_cutout_airhole_radius, bolt_holes=bolt_holes, fn=fn, airhole_fn=airhole_fn);
        translate([lego_skin_width(), lego_skin_width(), lego_skin_width()])
            lego_sign_extruded_text(line_1=line_1, line_2=line_2, lang=lang, extrusion_height=extrusion_height, f1=f1, f2=f2, fs1=fs1, fs2=fs2, left_margin=left_margin, vertical_margin=vertical_margin, x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, fn=fn);

        if (is_true(copy_to_back)) {
            translate([lego_skin_width()+lego_width(xb), lego_width(yb), lego_skin_width()])
                rotate([0, 0, 180])
                    lego_sign_extruded_text(line_1=line_1, line_2=line_2, lang=lang, extrusion_height=extrusion_height, f1=f1, f2=f2, fs1=fs1, fs2=fs2, left_margin=left_margin, vertical_margin=vertical_margin, x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, fn=fn);
        }
    } else {
        difference() {
            lego(x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, knob_height=knob_height, knob_cutout_height=knob_cutout_height, knob_cutout_radius=knob_cutout_radius, knob_cutout_airhole_radius=knob_cutout_airhole_radius, bolt_holes=bolt_holes, fn=fn, airhole_fn=airhole_fn);
            union() {
                translate([lego_skin_width(), 0, lego_skin_width()])
                    lego_sign_etched_text(line_1=line_1, line_2=line_2, lang=lang, extrusion_height=extrusion_height+lego_skin_width(), f1=f1, f2=f2, fs1=fs1, fs2=fs2, left_margin=left_margin, vertical_margin=vertical_margin, x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, fn=fn);

                if (is_true(copy_to_back)) {
                    translate([lego_skin_width()+lego_width(x), lego_skin_width()+lego_width(y), lego_skin_width()])
                        rotate([0, 0, 180])
                            lego_sign_etched_text(line_1=line_1, line_2=line_2, lang=lang, extrusion_height=extrusion_height+lego_skin_width(), f1=f1, f2=f2, fs1=fs1, fs2=fs2, left_margin=left_margin, vertical_margin=vertical_margin, x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, fn=fn);
                }
            }
        }
    }
}


// Two lines of text extruded out from the surface
module lego_sign_extruded_text(line_1=line_1, line_2=line_2, lang=lang, extrusion_height=extrusion_height, f1=f1, f2=f2, fs1=fs1, fs2=fs2, left_margin=left_margin, vertical_margin=vertical_margin, x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, fn=fn) {
    translate([left_margin, 0, lego_height(z)-vertical_margin])
        lego_text(txt=line_1, lang=lang, font=f1, font_size=fs1, vertical_alignment="top");
    translate([left_margin, 0, vertical_margin])
        lego_text(txt=line_2, lang=lang, font=f2, font_size=fs2, vertical_alignment="bottom");
}


// Two lines of text etched into the surface
module lego_sign_etched_text(line_1=line_1, line_2=line_2, lang=lang,  extrusion_height=extrusion_height, f1=f1, f2=f2, fs1=fs1, fs2=fs2, left_margin=left_margin, vertical_margin=vertical_margin, x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, fn=fn) {
    translate([left_margin, extrusion_height, lego_height(z)-vertical_margin])
        lego_text(text=line_1, lang=lang, extrusion_height=extrusion_height, font=f1, font_size=fs1, vertical_alignment="top");
    translate([left_margin, extrusion_height, vertical_margin])
        lego_text(text=line_2, lang=lang, extrusion_height=extrusion_height, font=f2, font_size=fs2, vertical_alignment="baseline");
}


// Text for the side of calibration block prints
module lego_text(text=line_1, lang=lang, extrusion_height=text_extrusion_height, font=f1, font_size=fs1, vertical_alignment="bottom") {
    rotate([90,0,0])
        linear_extrude(height=extrusion_height)
            text(text=text, language=lang, font=font, size=font_size, halign="left", valign=vertical_alignment);
}
