# LEGO .stl model batch render
 param (
    [Float]$top = 1,
    [Float]$bottom = 0.0,
    [String]$file_extension = "stl"
 )
#----------------- Logo

Get-Date
echo "Render 2x2 ABS"

openscad -o lego-abs-2x2x1.$file_extension -D 'mode="""block"""; blocks_x=1; blocks_y=1; blocks_z=1; top_tweak=$top;' lego.scad
