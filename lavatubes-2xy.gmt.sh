#!/bin/bash

# Data sources and range/scale information

# SBC1
outfilename="foo"
boug_data=$1
boug_range="R0/300/-100/100"
boug_scale='Ba50g50:Distance from center (km):/a10g10:Bouguer Anomaly (mGal):WS'
bougE_data=$2
bougE_range="R0/300/-70/30"
bougE_scale='Ba50g50:Distance from center (km):/a10g10:Bouguer Eigenvalue (Eotvos):WS'
data_pen='thickest,blue'
error_pen='thinnest,blue'

# General settings & environment variables
gmtset HEADER_FONT_SIZE 12p
gmtset ANNOT_FONT_SIZE_PRIMARY 10p
gmtset LABEL_FONT_SIZE 10p
gmtset GRID_PEN_PRIMARY .1p,grey
gmtset PAGE_ORIENTATION LANDSCAPE
#gmtset DOTS_PR_INCH 600
#xstart=2 #portrait
xstart=1.5 #landscape
ystart=1

# Set up for 2 plots
projection='JX3i/6i'
xspacing=5

# Create an empty file, and a file that's just a horizontal line at 0
touch baz
echo "0 0"    > foo_straightline.xy
echo "999999 0" >> foo_straightline.xy

# First plot
psxy $boug_data -$projection -$boug_range -"$boug_scale" -W$data_pen \
    -X"$xstart"i -Y"$ystart"i \
    -Ey2p/$error_pen \
    -K >> $outfilename.ps
psxy $boug_data -J -R -W$data_pen \
    -K -O >> $outfilename.ps

# Second plot
psxy $bougE_data -$projection -$bougE_range -"$bougE_scale" -W$data_pen \
    -X"$xspacing"i -Y0i \
    -Ey2p/$error_pen \
    -K -O >> $outfilename.ps
psxy $bougE_data -J -R -W$data_pen \
    -K -O >> $outfilename.ps

# Create a PDF and open it for viewing
ps2pdf $outfilename.ps $outfilename.pdf
rm $outfilename.ps
evince $outfilename.pdf
