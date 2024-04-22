#!/bin/bash

# Input/output file names
#model="ori60km30Kk_Qvisco"
#outfilename="flat_initial_only"
#model="oriC03_visco_ps7"
#model=$1
outfilename="results"
#echo "" > "$outfilename.ps"

# Create an empty file, and a file that's just a horizontal line at 0
touch baz
echo "0 0"    > foo_straightline.xy
echo "999999 0" >> foo_straightline.xy

# General settings & environment variables
gmtset HEADER_FONT_SIZE 8p
gmtset ANNOT_FONT_SIZE_PRIMARY 10p
gmtset LABEL_FONT_SIZE 10p
gmtset GRID_PEN_PRIMARY .1p,grey
gmtset ELLIPSOID Moon
gmtset PAGE_ORIENTATION LANDSCAPE
#gmtset DOTS_PR_INCH 600
#gmtset BASEMAP_FRAME_RGB +Black  #Use "+Black" to reset everything to black!

# Colors
fontcolor="black"
c_zeroline="black"
#c_rings="#CCFF00"
#c_obs="#CCFF00"
c_rings="gray"
c_obs="gray"
c_initial="cyan"
c_final=( red orange yellow )
c_mw="purple"

# Spacing
#xstart=1
#ystart=4.5
#xspacing=4.5
#yspacing=0
#ymove=-3.25

# For portrait layout
#projection='JX4i/1.5i'
#xstart=2
#ystart=9
#xspacing=0
#yspacing=-2.4

# For landscape layout
projection='JX3.5i/2i'
xstart=1.25
ystart=4.3
xspacing=4.75
yspacing=0
ymove=-3.25

# Define the ranges, scales, and titles
fa_range='R0/800/-1800/400'
#fa_scale='Ba100g50:Radius (km):/a200g50f50:Free-Air Anomaly (mGal):WS:.Free_Air:'
#fa_scale='Ba100g50:Radius (km):/a200g50f50:Free-Air Anomaly (mGal):WS'
fa_scale="Ba100:Distance from Basin Center (km):/a200:Free-Air Anomaly (mGal):WS"
#fa_scale='Ba100g50/a200g50f50:mGal:WS'
boug_range='R0/800/-1000/1000'
#boug_scale='Ba100g50:Radius (km):/a200g50f50:Bouguer Anomaly (mGal):WS:.Bouguer:'
#boug_scale='Ba100g50:Radius (km):/a200g50f50:Bouguer Anomaly (mGal):WS'
boug_scale='Ba100:Distance from Basin Center (km):/a200:Bouguer Anomaly (mGal):WS'
#boug_scale='Ba100g50/a200g50f50:mGal:WS'
topo_range='R0/800/-10/5'
#topo_scale='Ba100g50:Radius (km):/a2g0.5f0.5:Relief (km):WS:.Topographic_Relief:'
#topo_scale='Ba100g50:Radius (km):/a2g0.5f0.5:Relief (km):WS'
topo_scale='Ba100:Distance from Basin Center (km):/a2:Relief (km):WS'
#topo_scale='Ba100g50/a2g0.5f0.5:km:WS'
mw_range='R0/800/0/60'
#mw_scale='Ba100g50:Radius (km):/a10g5f5:Crustal Thickness (km):WS:.Crustal_Thickness:'
#mw_scale='Ba100g50:Radius (km):/a10g5f5:Crustal Thickness (km):WS'
mw_scale='Ba100:Distance from Basin Center (km):/a10:Crustal Thickness (km):WS'
#mw_scale='Ba100g50/a10g5f5:km:WS'

modelindex=0
for model in $(echo $@); do

    echo $@

    # Data sources
    fa_model_initial="$model"_ff_fa.xy
    fa_model_final="$model"_fa.xy
    fa_obs_circles="orientale_fa_circles_5km.csv"
    boug_model_initial="$model"_ff_boug.xy
    boug_model_final="$model"_boug.xy
    boug_obs_circles="orientale_boug_circles_5km.csv"
    topo_model_initial="$model"_ff_surfacecoords.csv
    topo_model_final="$model"_surfacecoords.csv
    topo_obs_circles="orientale_topo_circles_5km_adjusted.csv"
    #mw_model_initial=baz #"$model"_ff_crustalthickness.csv
    mw_model="$model"_crustalthickness.csv
    #mw_model="oriC02_visco_ps6_crustalthickness.csv"
    mw_obs_circles="orientale_mw2_circles.csv"
    basin_rings="ring_positions.xy"

    #As a reminder, to get PDS .JP2 files into GMT-plottable .grd files, do e.g.:
    # gdal_translate -of GMT -unscale LDEM_16.JP2 LOLA_16ppd_topo.grd

    # Free-Air Gravity Anomaly
    if [ $modelindex -eq 0 ]; then
        psxy baz -$projection -$fa_range -"$fa_scale" -W1p, \
            -X"$xstart"i -Y"$ystart"i \
            -K > $outfilename.ps
        psxy foo_straightline.xy -J -R -W1p,$c_zeroline \
            -K -O >> $outfilename.ps
        psxy $basin_rings -m -J -R -Wthick,$c_rings \
            -K -O >> $outfilename.ps
        psxy $fa_obs_circles -J -R -Wthick,$c_obs -G$c_obs -Ey2p/thin,$c_obs -SC1p \
            -K -O >> $outfilename.ps
        psxy $fa_model_initial -J -R -Wthickest,$c_initial \
            -K -O >> $outfilename.ps
        psxy $fa_model_final -J -$fa_range -Wthickest,${c_final[$modelindex]} \
            -K -O >> $outfilename.ps
    else
        psxy $fa_model_final -J -$fa_range -Wthickest,${c_final[$modelindex]} \
            -K -O >> $outfilename.ps
    fi
#
#    # Plot title
#    # For Reference, text line is [X Y Size Angle Font Justify Text]
#    pstext -R -JX \
#        -Xa0.1i -Ya1i \
#        -N -K -O << END >> $outfilename.ps
#0 0 16 0 Helvetica CM $model
#END
#
#    # Bouguer Gravity Anomaly
#    psxy baz -$projection -$boug_range -"$boug_scale" \
#        -X"$xspacing"i -Y"$yspacing"i \
#        -K -O >> $outfilename.ps
#    psxy foo_straightline.xy -J -R -W1p,$c_zeroline \
#        -K -O >> $outfilename.ps
#    psxy $basin_rings -m -J -R -Wthick,$c_rings \
#        -K -O >> $outfilename.ps
#    psxy $boug_obs_circles -J -R -Wthick,$c_obs -G$c_obs -Ey2p/thin,$c_obs -SC1p \
#        -K -O >> $outfilename.ps
#    psxy $boug_model_initial -J -R -Wthickest,$c_initial \
#        -K -O >> $outfilename.ps
#    psxy $boug_model_final -J -R -Wthickest,$c_final \
#        -K -O >> $outfilename.ps
#
#    # Topography
#    psxy baz -$projection -$topo_range -"$topo_scale" \
#        -X"-$xspacing"i -Y"$ymove"i \
#        -K -O >> $outfilename.ps
#    psxy foo_straightline.xy -J -R -W1p,$c_zeroline \
#        -K -O >> $outfilename.ps
#    psxy $basin_rings -m -J -R -Wthick,$c_rings \
#        -K -O >> $outfilename.ps
#    psxy $topo_obs_circles -J -R -Wthick,$c_obs -G$c_obs -Ey2p/thin,$c_obs -SC1p \
#        -K -O >> $outfilename.ps
#    psxy $topo_model_initial -J -R -Wthickest,$c_initial \
#        -K -O >> $outfilename.ps
#    psxy $topo_model_final -J -R -Wthickest,$c_final \
#        -K -O >> $outfilename.ps
#
#    # Crustal thickness
#    psxy baz -$projection -$mw_range -"$mw_scale" \
#        -X"$xspacing"i -Y"$yspacing"i \
#        -K -O >> $outfilename.ps
#    #psxy foo_straightline.xy -J -R -W1p,$c_zeroline \
#    #    -K -O >> $outfilename.ps
#    psxy $basin_rings -m -J -R -Wthick,$c_rings \
#        -K -O >> $outfilename.ps
#    psxy $mw_obs_circles -J -R -Wthick,$c_obs -G$c_obs -Ey2p/thin,$c_obs -SC1p \
#        -K -O >> $outfilename.ps
#    psxy $mw_model -J -R -Wthickest,$c_mw \
#        -K -O >> $outfilename.ps
#
    modelindex=$[modelindex + 1]
done

# Create a PDF and open it for viewing
ps2pdf $outfilename.ps
#open $outfilename.ps
evince $outfilename.pdf

# Clean up
rm baz foo_straightline.xy
rm $outfilename.ps
