/*
Parametric LEGO Block, Command line batch invocation entry point

This wrapper helps past some OpenSCAD issues with on-line
customizer requiring one style and command
line parameter passing requiring another style.

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

Design work kindly sponsored by
    http://futurice.com
    
    
Pass in arguments from the command line such as:
 - In Windows powershell script:   
 openscad -o lego-abs-2x2x1.stl -D 'mode="""block"""; blocks_x=1; blocks_y=1; blocks_z=1; top_tweak=0; bottom_tweak=0;' command-line-parametric-lego.scad

*/

use <lego.scad>

if (mode=="calibration") {
    lego_calibration_set(x=x, y=y, fn=fn); // A set of blocks for testing which tweak parameters to use on your printer and plastic
} else if (mode=="panel") {
    lego_panel(x=x, y=y, top_tweak=top_tweak, panel_thickness=panel_thickness, bolt_holes=bolt_holes, fn=fn); // A thin panel of knobs with a flat back and mounting screw holes in the corners, suitable for organizing projects
} else {
    // A single block
    lego(x=x, y=y, z=z, top_tweak=top_tweak, bottom_tweak=bottom_tweak, knob_height=knob_height, knob_cutout_height=knob_cutout_height, knob_cutout_radius=knob_cutout_radius, knob_cutout_airhole_radius=knob_cutout_airhole_radius, bolt_holes=bolt_holes, fn=fn, airhole_fn=airhole_fn);
}
