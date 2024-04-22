#!/bin/bash


# Files
##SBC2
bouguer_e="eval_bo_avg_SBC_2.grd"
##Output file (without extension or suffixes)
outname="foo"


# General settings & environment variables
gmtset HEADER_FONT_SIZE 12p
gmtset ANNOT_FONT_SIZE_PRIMARY 10p
gmtset LABEL_FONT_SIZE 10p
gmtset GRID_PEN_PRIMARY .1p,grey
gmtset ELLIPSOID Moon
gmtset PAGE_ORIENTATION LANDSCAPE
gmtset BASEMAP_TYPE FANCY
#gmtset DOTS_PR_INCH 600
#gmtset BASEMAP_FRAME_RGB +Black  #Use "+Black" to reset everything to black!
#gmtset BASEMAP_FRAME_RGB Red
fontcolor=white


# Projection and range

##SBC2
projection='JM4i'
range='R13/30/35/46r'
latlonscale='B5a1'


# Make the color scale
##Auto
grd2cpt $bouguer_e -Cpolar > foo.cpt
##SBC2 bouguer eigenvalues
#low='-30'; high='30'; interval='5'
#makecpt -Cpolar -T$low/$high/$interval > foo.cpt


# Plot up an empty file to get the plot started and the borders/title/etc drawn
touch baz
psxy baz -$range -$projection -$latlonscale:.:WSNe \
    -X"$xstart"i -Y"$ystart"i -K > "$outname".ps
rm baz


# Plot the data
grdimage $bouguer_e -$range -$projection -$latlonscale \
    -Cfoo.cpt -Q -K -O >> "$outname".ps
