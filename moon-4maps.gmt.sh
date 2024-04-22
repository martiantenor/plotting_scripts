#!/bin/bash

#Define some input/output stuff
datadir="./gmt" # on Mangala
#datadir="." # on Taylor
#OLDER fa_data="$datadir/data_GRAIL/jgrail_420c1a_410_sale_300.grd"
#fa_data="$datadir/data_GRAIL/LDAM_JGGRAIL_420C1A_007_420_4PPD.GRD"
#fa_data="$datadir/data_GRAIL/LDAM_JGGRAIL_420C1A_007_320_4PPD.GRD"
fa_data="$datadir/data_GRAIL/LDAM_JGGRAIL_420C1A_007_320_4PPD_resampled16ppd.GRD"
#OLDER boug_data="$datadir/data_GRAIL/GRAIL_16ppd_L360_bouguer.grd"
#boug_data="$datadir/data_GRAIL/LDBM_JGGRAIL_420C1A_007_320_4PPD.GRD"
boug_data="$datadir/data_GRAIL/LDBM_JGGRAIL_420C1A_007_320_4PPD_resampled16ppd.GRD"
topo_data="$datadir/data_LOLA/LOLA_16ppd_topo.grd"
#mw_data="$datadir/data_MW/Data/Model4_thick.dat.grd" #"mw" for Mark Wieczorek
mw_data="$datadir/data_MW/Data/Model2_thick.dat.grd" #"mw" for Mark Wieczorek
circlesfile="smallcircles_moon_5km.txt"
circles_outname='mw_model2_circles'
tracksfile="greatcircle_arcs_moon.txt"
tracks_outname="mw_model2_tracks"
outname="ori_LMIV" #suffixes _fa, _boug, _topo and .ps and .csv get added

#As a reminder, to get PDS .JP2 files into GMT-plottable .grd files, do e.g.:
# gdal_translate -of GMT -unscale LDEM_16.JP2 LOLA_16ppd_topo.grd

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

# Colors
fontcolor=white

# Spacing
xstart=0.75
ystart=3
xspacing=2.5
yspacing=-2.4

#Choose/create a color scale with defined interval and high/low values
cptname='colors' #[_fa,_boug,_topo,_crust].cpt added later
fa_low='-400'; fa_high='400'; fa_int='100'; fa_scale_int='200' #For FA gravity data
#fa_low='-600'; fa_high='600'; fa_int='50'; fa_scale_int='100' #For FA gravity data
boug_low='-600'; boug_high='600'; boug_int='100'; boug_scale_int='200'  #For Bouguer gravity data
#topo_low='-10000'; topo_high='15000'; topo_int='1000'; topo_scale_int='1' #For F-S topo data
#topo_low='-5'; topo_high='5'; topo_int='1'; topo_scale_int='1' #For F-S topo data
#topo_low='-10'; topo_high='5'; topo_int='1'; topo_scale_int='1' #For Humorum topo data
topo_low='-4'; topo_high='6'; topo_int='1'; topo_scale_int='1' #For Orientale topo data
mw_low='0'; mw_high='60'; mw_int='5'; mw_scale_int='10' #For crustal thickness data

#Create the color scales for Free-Air, Bouguer, Topo, and Crustal Thickness
#(Mark Wieczorek = "mw")
# -Z option makes it a "continuous" color scale (i.e. smoothly varying)
#makecpt -Cpolar -T-300/300/20 > $colorfile #red-blue
#makecpt -Crainbow -T$lowvalue/$highvalue/$interval > $colorfile #rainbow
makecpt -Cno_green -T$fa_low/$fa_high/$fa_int > "$cptname"_fa.cpt
makecpt -Cno_green -T$boug_low/$boug_high/$boug_int > "$cptname"_boug.cpt
makecpt -Chot -I -T$mw_low/$mw_high/$mw_int > "$cptname"_mw.cpt
makecpt -Crainbow -T$topo_low/$topo_high/$topo_int > "$cptname"_topo.cpt

#Define the projection and range
#Humorum: 321.4E, 24.4S
#projection='JM2i' #Mercator
#projection='JQ2i' #Cylindrical Equidistant
#projection='JI2i' #Sinusoidal
#projection='JA320/-24/2i' #Lambert Azimuthal Equal-Area
#projection='JB300/-40/340/-5/2i' #Albers
#projection='JE320/-24/2i' #Azimuthal Equidistant
#projection='JY2i' #Cylindrical Equal-Area
#range='R300/-40/340/-5r'
#scalebar='Lf315/-35/-34.5/500k:"km":'

#Freundlich-Sharanov: 175E, 18.5N
#projection='JM2i' #Mercator
#projection='JY2i' #Cylindrical Equal-Area
#range='R155/0/195/35r'
#scalebar='Lf170/5/5.5/500k:"km":'

#Orientale: 267.2°E, 19.4°S
projection='JM2i'
range='R-120/-40/-70/0r'

#Global (Molleweide):
#projection='JW4i'
#projection='JW9i'
#range='Rd'
#range='Rg'
#range='R90/450/-90/90'
#range='R-90/270/-90/90'

#Global (Equirectangular)
#projection='JX8i/4i'
#range='Rg' #0/360
#range='Rd' #-180/180

#Lat/lon lines: B[Marked lons]g[lon lines]/[Marked lats]g[lat lines]
#latlonscale='B10a10/10a10' #for regional plots
latlonscale='B30a30' #for global plots

#Plot up an empty file to get the plot started and the borders/title/etc drawn
touch baz
psxy baz -$range -$projection -$latlonscale:.:WSNe \
    -X"$xstart"i -Y"$ystart"i -K > "$outname".ps
rm baz

#Data of interest
grdimage $fa_data -$range -$projection -$latlonscale:."Free-air anomaly":WSNe \
    -C$"$cptname"_fa.cpt --BASEMAP_FRAME_RGB=+$fontcolor -Q -K -O >> "$outname".ps
grdimage $boug_data -$range -$projection -$latlonscale:."Bouguer anomaly":WSNe \
    -C$"$cptname"_boug.cpt -Xa$(echo "$xspacing" | bc)i \
    -Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -Q -K -O >> "$outname".ps
grdimage $mw_data -$range -$projection -$latlonscale:."Crustal Thickness":WSNe \
    -C$"$cptname"_mw.cpt -Xa$(echo "2*$xspacing" | bc)i \
    -Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -Q -K -O >> "$outname".ps
grdimage $topo_data=cs/0.0005 -$range -$projection -$latlonscale:."Topography":WSNE \
    -C$"$cptname"_topo.cpt -Xa$(echo "3*$xspacing" | bc)i \
    -Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -Q -K -O >> "$outname".ps

#Draw small circle tracks on the map?
#psxy $circlesfile -$range -$projection -m -Wblack \
#    -L -K -O >> "$outname".ps
#psxy $circlesfile -$range -$projection -m -Wblack \
#    -Xa$(echo "$xspacing" | bc)i -Ya0i -L -K -O >> "$outname".ps
#psxy $circlesfile -$range -$projection -m -Wblack \
#    -Xa$(echo "2*$xspacing" | bc)i -Ya0i -L -K -O >> "$outname".ps
#psxy $circlesfile -$range -$projection -m -Wblack \
#    -Xa$(echo "3*$xspacing" | bc)i -Ya0i -L -K -O >> "$outname".ps

#Also write out data along these tracks?
#grdtrack $circlesfile -G$fa_data -m -fg > "$circles_outname"_fa.csv
#grdtrack $circlesfile -G$boug_data -m -fg > "$circles_outname"_boug.csv
#grdtrack $circlesfile -G$mw_data -m -fg > "$circles_outname"_mw.csv
#grdtrack $circlesfile -G$topo_data -m -fg > "$circles_outname"_topo.csv

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

#Legend (vertical): -D[xpos/ypos/length/width]
#psscale -D9.5i/2i/4i/.25i -B"$fa_int"a"$fa_int" -C"$cptname"_fa.cpt \
#    -X-$((4 * $xspacing)) -K -O >> "$outname".ps
#psscale -D9.5i/2i/4i/.25i -B"$fa_int"a"$fa_int" -C"$cptname"_boug.cpt \
#    -X+$xspacing -K -O >> "$outname".ps
#psscale -D9.5i/2i/4i/.25i -B"$fa_int"a"$fa_int" -C"$cptname"_mw.cpt \
#    -X+$xspacing -K -O >> "$outname".ps
#psscale -D9.5i/2i/4i/.25i -B"$fa_int"a"$fa_int" -C"$cptname"_topo.cpt \
#    -X+$xspacing -K -O >> "$outname".ps
#Legend (horizontal)
psscale -D1i/-.5i/2i/.2ih -B"$fa_int"a"$fa_scale_int":"mGal": -C"$cptname"_fa.cpt \
    --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps
psscale -D1i/-.5i/2i/.2ih -B"$boug_int"a"$boug_scale_int":"mGal": -C"$cptname"_boug.cpt \
    -Xa$(echo "$xspacing" | bc)i -Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps
psscale -D1i/-.5i/2i/.2ih -B"$mw_int"a"$mw_scale_int":"km": -C"$cptname"_mw.cpt \
    -Xa$(echo "2*$xspacing" | bc)i -Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps
psscale -D1i/-.5i/2i/.2ih -B"$topo_int"a"$topo_scale_int":"km": -C"$cptname"_topo.cpt \
    -Xa$(echo "3*$xspacing" | bc)i -Ya0i --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps

#Four Crustal Thickness models
#mw_data1="$datadir/data_MW/Data/Model1_thick.dat.grd"
#mw_data2="$datadir/data_MW/Data/Model2_thick.dat.grd"
#mw_data3="$datadir/data_MW/Data/Model3_thick.dat.grd"
#mw_data4="$datadir/data_MW/Data/Model4_thick.dat.grd"
#mw_low='0'; mw_high='60'; mw_int='5' #For crustal thickness data
##makecpt -Cpanoply -I -T$mw_low/$mw_high/$mw_int > "$cptname"_mw.cpt #no green
#makecpt -Chot -I -T$mw_low/$mw_high/$mw_int > "$cptname"_mw.cpt #no green
#grdimage $mw_data1 -$range -$projection -$latlonscale:."Model 1":WSNe \
#    -C$"$cptname"_mw.cpt -Q -K -O >> "$outname".ps
#grdimage $mw_data2 -$range -$projection -$latlonscale:."Model 2":WSNe \
#    -C$"$cptname"_mw.cpt -Xa$(echo "1*$xspacing" | bc)i \
#    -Ya0i -Q -K -O >> "$outname".ps
#grdimage $mw_data3 -$range -$projection -$latlonscale:."Model 3":WSNe \
#    -C$"$cptname"_mw.cpt -Xa$(echo "2*$xspacing" | bc)i \
#    -Ya0i -Q -K -O >> "$outname".ps
#grdimage $mw_data4 -$range -$projection -$latlonscale:."Model 4":WSNE \
#    -C$"$cptname"_mw.cpt -Xa$(echo "3*$xspacing" | bc)i \
#    -Ya0i -Q -K -O >> "$outname".ps
#psscale -D1i/-.5i/2i/.2ih -B"$mw_int"a"$mw_int" -C"$cptname"_mw.cpt \
#    -K -O >> "$outname".ps
#psscale -D1i/-.5i/2i/.2ih -B"$mw_int"a"$mw_int" -C"$cptname"_mw.cpt \
#    -Xa$(echo "1*$xspacing" | bc)i -Ya0i -K -O >> "$outname".ps
#psscale -D1i/-.5i/2i/.2ih -B"$mw_int"a"$mw_int" -C"$cptname"_mw.cpt \
#    -Xa$(echo "2*$xspacing" | bc)i -Ya0i -K -O >> "$outname".ps
#psscale -D1i/-.5i/2i/.2ih -B"$mw_int"a"$mw_int" -C"$cptname"_mw.cpt \
#    -Xa$(echo "3*$xspacing" | bc)i -Ya0i -K -O >> "$outname".ps
#grdtrack $circlesfile -G$mw_data1 -m -fg > "$outname"_mw1.csv
#grdtrack $circlesfile -G$mw_data2 -m -fg > "$outname"_mw2.csv
#grdtrack $circlesfile -G$mw_data3 -m -fg > "$outname"_mw3.csv
#grdtrack $circlesfile -G$mw_data4 -m -fg > "$outname"_mw4.csv

#Create a .eps version
#ps2raster -A -Te "$outname"_fa.ps  #makes .eps file

#Open the file for viewing
ps2pdf "$outname".ps "$outname".pdf
rm "$outname".ps
open "$outname".pdf
#evince "$outname"_fa.ps &
