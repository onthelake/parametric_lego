# LEGO .stl model batch render
param (
	[Int]$x = 1,
	[Int]$y = 1,
	[Int]$z = 1,
	[Float]$top = 1,
	[Float]$bottom = 0.0,
	[Int]$fn = 64,
	[Int]$airhole_fn = 6,
    	[String]$filename = "lego"
 )
#----------------- Logo

Get-Date
echo "Render " $filename

openscad -o $filename".stl" -D 'mode="""block"""; x=$x; y=$y; z=$z; top_tweak=$top; bottom_tweak=$bottom; fn=$fn; airhole_fn=$airhole_fn' command-line-parametric-lego.scad
