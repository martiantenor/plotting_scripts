#!/bin/bash

#Define some input/output stuff
datadir="/project/taylor/a/dave/GIS/Moon"
#boug_e="eval_bo_avg_SBC_2.grd"
boug="$datadir/LDAM_JGGRAIL_420C1A_007_420_4PPD.GRD"
boug_e="eval_loic_20141114.grd"
circlesfile="smallcircles_SBC_1km.txt"
#tracksfile="greatcircle_arcs_moon.txt"
outname="SBC1" #suffixes _fa, _boug, _topo and .ps and .csv get added
circles_outname='SBC1_circles'
#tracks_outname="mw_model2_tracks"

#As a reminder, to get PDS .JP2 files into GMT-plottable .grd files, do e.g.:
# gdal_translate -of GMT -unscale LDEM_16.JP2 LOLA_16ppd_topo.grd
#And for ASCII files, something like
# xyz2grd ascii_file.txt -I.1/.1 -Rlonmin/lonmax/latmin/latmax -Goutput_name.grd

#General settings & environment variables
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
gmtset HEADER_FONT 1 #Helvetica (0 = normal, 1 = bold, 2 = oblique)
gmtset ANNOT_FONT_PRIMARY 0
gmtset LABEL_FONT 0

#Colors
fontcolor=black

#Color scales
# -Z option makes it a "continuous" color scale (i.e. smoothly varying)
cptname='colors' #[_fa,_boug,_topo,_crust].cpt added later
##Bouguer Eigenvalues
###SBC2
#boug_e_low='-30'; boug_e_high='30'; boug_e_int='5'; boug_e_scale_int='10'
###Loic 20141114
boug_low='-300'; boug_high='300'; boug_int='50'; boug_scale_int='50'
boug_e_low='-80'; boug_e_high='80'; boug_e_int='20'; boug_e_scale_int='10'
makecpt -Cpolar -T$boug_low/$boug_high/$boug_int > "$cptname"_boug.cpt
makecpt -Cpolar -T$boug_e_low/$boug_e_high/$boug_e_int > "$cptname"_boug_e.cpt

#Define the projection and range
projection='JM2.5i'
scaledimensions='D1.25i/-.5i/2.5i/.2ih'
##SBC2
#range='R15/30/35/45'
#latlonscale='B1a5'
##Loic 20141114
range='R22/40/0/18'
latlonscale='B1a5'

#Spacing
##Whole page
xstart=1.0
ystart=3
xspacing=3.125
yspacing=0

#Overrides for sizing for a figure (6.5" wide)
#gmtset PAGE_ORIENTATION PORTRAIT
#projection='JM1.875i'
#xspacing=2.125
#latlonscale='B5a10'
#boug_e_scale_int='10'
#scaledimensions='D.9375i/-.5i/1.75i/.2ih'

#Plot up an empty file to get the plot started and the borders/title/etc drawn
touch baz
psxy baz -$range -$projection -$latlonscale:.:WSNe \
    -X"$xstart"i -Y"$ystart"i -K > "$outname".ps
rm baz

#Data of interest
grdimage $boug -$range -$projection -$latlonscale:."Bouguer Anomaly":WSNE \
    -C$"$cptname"_boug.cpt -Q -K -O >> "$outname".ps
    #-C$"$cptname"_boug_e.cpt --BASEMAP_FRAME_RGB=+$fontcolor -Q -K -O >> "$outname".ps
grdimage $boug_e -$range -$projection -$latlonscale:."Bouguer E-Vals":wSNe \
    -C$"$cptname"_boug_e.cpt -Xa$(echo "$xspacing" | bc)i \
    -Ya0i -Q -K -O >> "$outname".ps
    #-Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -Q -K -O >> "$outname".ps
#grdimage $boug_e -$range -$projection -$latlonscale:."Bouguer E-Vals":WSNE \
#    -C$"$cptname"_boug_e.cpt -Xa$(echo "2*$xspacing" | bc)i \
#    -Ya0i -Q -K -O >> "$outname".ps
#    #-Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -Q -K -O >> "$outname".ps

#Draw small circle tracks on the map?
#psxy $circlesfile -$range -$projection -m -Wblack \
#    -L -K -O >> "$outname".ps
#psxy $circlesfile -$range -$projection -m -Wblack \
#    -Xa$(echo "$xspacing" | bc)i -Ya0i -L -K -O >> "$outname".ps
#psxy $circlesfile -$range -$projection -m -Wblack \
#    -Xa$(echo "2*$xspacing" | bc)i -Ya0i -L -K -O >> "$outname".ps

#Also write out data along these tracks?
grdtrack $circlesfile -G$boug -m -fg > "$circles_outname"_boug.csv
grdtrack $circlesfile -G$boug_e -m -fg > "$circles_outname"_boug_e.csv

#Draw profile tracks on the map?
#psxy $tracksfile -$range -$projection -m -Wfat,forestgreen \
#    -L -K -O >> "$outname".ps
#psxy $tracksfile -$range -$projection -m -Wfat,forestgreen \
#    -Xa$(echo "$xspacing" | bc)i -Ya0i -L -K -O >> "$outname".ps
#psxy $tracksfile -$range -$projection -m -Wfat,forestgreen \
#    -Xa$(echo "2*$xspacing" | bc)i -Ya0i -L -K -O >> "$outname".ps
#psxy $tracksfile -$range -$projection -m -Wfat,forestgreen \
#    -Xa$(echo "3*$xspacing" | bc)i -Ya0i -L -K -O >> "$outname".ps

#Also write out data along these profiles?
#grdtrack $tracksfile -G$fa_data -m -fg > "$tracks_outname"_fa.csv
#grdtrack $tracksfile -G$boug_data -m -fg > "$tracks_outname"_boug.csv
#grdtrack $tracksfile -G$mw_data -m -fg > "$tracks_outname"_mw.csv
#grdtrack $tracksfile -G$topo_data -m -fg > "$tracks_outname"_topo.csv
#Scale bar
#psbasemap -J -R -X-4i -$scalebar  -K -O >> "$outname"_fa.ps

#Legend (horizontal)
psscale -$scaledimensions -B"$boug_int"a"$boug_scale_int":"mGal": -C"$cptname"_boug.cpt \
    --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps
psscale -$scaledimensions -B"$boug_e_int"a"$boug_e_scale_int":"Eotvos": -C"$cptname"_boug_e.cpt \
    -Xa$(echo "$xspacing" | bc)i -Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps
#psscale -$scaledimensions -B"$boug_e_int"a"$boug_e_scale_int":"[?]": -C"$cptname"_boug_e.cpt \
#    -Xa$(echo "2*$xspacing" | bc)i -Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps

#Open the file for viewing
ps2pdf "$outname".ps "$outname".pdf
rm "$outname".ps
#open "$outname".pdf
evince "$outname".pdf &
