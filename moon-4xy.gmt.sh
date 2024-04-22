#!/bin/bash

# Input/output file names
model="oriC01_visco_ps7"
outfilename="$model"
#outfilename="just_observations"

# Data sources
#fa_model_initial="$model"_ff_fa.xy
#fa_model_final="$model"_fa.xy
fa_obs_circles="orientale_fa_circles_5km.csv"
#boug_model_initial="$model"_ff_boug.xy
#boug_model_final="$model"_boug.xy
boug_obs_circles="orientale_boug_circles_5km.csv"
#topo_model_initial="$model"_ff_surfacecoords.csv
topo_model_final="$model"_surfacecoords.csv
topo_obs_circles="orientale_topo_circles_5km_adjusted.csv"
#mw_model_initial=baz #"$model"_ff_crustalthickness.csv
#mw_model="$model"_crustalthickness.csv
#mw_model2="$model2"_crustalthickness.csv
mw_obs_circles="orientale_mw2_circles.csv"
basin_rings="ring_positions.xy"

#As a reminder, to get PDS .JP2 files into GMT-plottable .grd files, do e.g.:
# gdal_translate -of GMT -unscale LDEM_16.JP2 LOLA_16ppd_topo.grd

# General settings & environment variables
gmtset HEADER_FONT_SIZE 12p
gmtset ANNOT_FONT_SIZE_PRIMARY 10p
gmtset LABEL_FONT_SIZE 10p
gmtset GRID_PEN_PRIMARY .1p,grey
gmtset ELLIPSOID Moon
gmtset PAGE_ORIENTATION PORTRAIT
#gmtset DOTS_PR_INCH 600
#gmtset BASEMAP_FRAME_RGB +Black  #Use "+Black" to reset everything to black!

# Colors
fontcolor=white
c_zeroline="white"
#c_rings="#CCFF00"
#c_obs="#CCFF00"
c_rings="gray"
c_obs="gray"
c_initial="cyan"
c_final="red"
c_mw="purple"

# Spacing
xspacing=2.5
xstart=2
ystart=9
yspacing=-2.4

#Define the projection, ranges, and scales
projection='JX4i/1.5i'
#fa_range='R0/1000/-800/400'
fa_range='R0/800/-800/400'
fa_scale='Ba100g50/a200g50f50:mGal:WS:.Free-Air:'
#boug_range='R0/1000/-300/700'
boug_range='R0/800/-300/700'
boug_scale='Ba100g50/a200g50f50:mGal:WS:.Bouguer:'
#topo_range='R0/1000/-8/5'
topo_range='R0/800/-8/5'
topo_scale='Ba100g50/a2g0.5f0.5:km:WS:.Topographic-Relief:'
#mw_range='R0/1000/0/60'
mw_range='R0/800/0/60'
mw_scale='Ba100g50/a10g5f5:km:WS:.Crustal-Thickness:'

# Create an empty file, and a file that's just a horizontal line at 0
touch baz
echo "0 0"    > foo_straightline.xy
echo "999999 0" >> foo_straightline.xy

# Free-Air Gravity Anomaly
psxy baz -$projection -$fa_range -$fa_scale -X"$xstart"i -Y"$ystart"i \
    -P -K > $outfilename.ps
psxy foo_straightline.xy -J -R -W1p,$c_zeroline \
    -P -K -O >> $outfilename.ps
psxy $basin_rings -m -J -R -W.1p,$c_rings \
    -P -K -O >> $outfilename.ps
psxy $fa_obs_circles -J -R -W0.1p,$c_obs -G$c_obs -Ey1p -SC0.5p \
    -P -K -O >> $outfilename.ps
#psxy $fa_model_initial -J -R -Wthickest,$c_initial \
#    -P -K -O >> $outfilename.ps
#    -P -K -O >> $outfilename.ps
#psxy $fa_model_final -J -$fa_range -Wthickest,$c_final \
#    -P -K -O >> $outfilename.ps
#    -P -K -O >> $outfilename.ps

# Bouguer Gravity Anomaly
psxy baz -$projection -$boug_range -$boug_scale -Y"$yspacing"i \
    -P -K -O >> $outfilename.ps
psxy foo_straightline.xy -J -R -W1p,$c_zeroline \
    -P -K -O >> $outfilename.ps
psxy $basin_rings -m -J -R -W.1p,$c_rings \
    -P -K -O >> $outfilename.ps
psxy $boug_obs_circles -J -R -W0.1p,$c_obs -G$c_obs -Ey1p -SC0.5p \
    -P -K -O >> $outfilename.ps
#psxy $boug_model_initial -J -R -Wthickest,$c_initial \
#    -P -K -O >> $outfilename.ps
#    -P -K -O >> $outfilename.ps
#psxy $boug_model_final -J -R -Wthickest,$c_final \
#    -P -K -O >> $outfilename.ps
#    -P -K -O >> $outfilename.ps

# Topography
psxy baz -$projection -$topo_range -$topo_scale -Y"$yspacing"i \
    -P -K -O >> $outfilename.ps
psxy foo_straightline.xy -J -R -W1p,$c_zeroline \
    -P -K -O >> $outfilename.ps
psxy $basin_rings -m -J -R -W.1p,$c_rings \
    -P -K -O >> $outfilename.ps
psxy $topo_obs_circles -J -R -W0.1p,$c_obs -G$c_obs -Ey1p -SC0.5p \
    -P -K -O >> $outfilename.ps
#psxy $topo_model_initial -J -R -Wthickest,$c_initial \
#    -P -K -O >> $outfilename.ps
#    -P -K -O >> $outfilename.ps
psxy $topo_model_final -J -R -Wthickest,$c_final \
    -P -K -O >> $outfilename.ps
    -P -K -O >> $outfilename.ps

# Crustal thickness
psxy baz -$projection -$mw_range -$mw_scale \
    -Y"$yspacing"i -P -K -O >> $outfilename.ps
psxy foo_straightline.xy -J -R -W1p,$c_zeroline \
    -P -K -O >> $outfilename.ps
psxy $basin_rings -m -J -R -W.1p,$c_rings \
    -P -K -O >> $outfilename.ps
psxy $mw_obs_circles -J -R -W0.1p,$c_obs -G$c_obs -Ey1p -SC0.5p \
    -P -K -O >> $outfilename.ps
#psxy $mw_model2 -J -R -Wthickest,$c_initial
#    -P -K -O >> $outfilename.ps

## Create a PDF and open it for viewing
ps2pdf $outfilename.ps $outfilename.pdf
open $outfilename.pdf
#evince $outfilename.ps

# Clean up
rm baz foo_straightline.xy
rm $outfilename.ps
