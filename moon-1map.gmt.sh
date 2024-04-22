#!/bin/bash

# Define some input/output stuff
#datadir="./gmt"
#datadir="."
datadir="./observations"

#Last working:
#data_file="$datadir/data_GRAIL/jgrail_420c1a_410_sale_300.grd" #Free-air data

###TESTING
#data_file="$datadir/LDAM_JGGRAIL_420C1A_007_320_4PPD_resampled16ppd.GRD"

#data_file="$datadir/data_GRAIL/LDAM_JGGRAIL_420C1A_007_320_4PPD_resampled16ppd.GRD"
#data_file="$datadir/moon_bouguer_JGGRAIL_420C1A_resampled16ppd.grd" #Bouguer data
#data_file="$datadir/GRAIL_16ppd_L360_bouguer.grd"
data_file="$datadir/moon_topo_LOLA_16ppd.grd" #Topo data
#data_file="$datadir/data_MW/Data/Model4_thick.dat.grd" #"mw" for Mark Wieczorek

circlesfile="smallcircles_moon_5km.txt"
circles_outname="smallcircles_moon"
tracksfile="greatcircle_arcs_moon.txt"
tracks_outname="SPA_bouguer_tracks"

outname='foo' #.ps and .csv get added later

# As a reminder, to get PDS .JP2 files into GMT-plottable .grd files, do e.g.:
# gdal_translate -of GMT -unscale LDEM_16.JP2 LOLA_16ppd_topo.grd

# General settings & environment variables
#gmtset HEADER_FONT_SIZE 12p
#gmtset ANNOT_FONT_SIZE_PRIMARY 10p
#gmtset LABEL_FONT_SIZE 10p
#gmtset GRID_PEN_PRIMARY .1p,grey
#gmtset ELLIPSOID Moon
#gmtset PAGE_ORIENTATION landscape
##gmtset BASEMAP_TYPE FANCY
##gmtset DOTS_PR_INCH 600
#gmtset BASEMAP_FRAME_RGB +Black  #Use "+Black" to reset everything to black!

# Colors
fontcolor="black"

# Spacing
xstart=2
ystart=1

# Choose/create a color scale with defined interval and high/low values
cptname='colors' #.cpt gets added later
#lowvalue='-400'; highvalue='400'; interval='100'; unit="mGal" #For FA gravity data
lowvalue='-500'; highvalue='500'; interval='25'; unit="mGal" #For Bouguer gravity data
#lowvalue='-10000'; highvalue='15000'; interval='1000'; unit="km" #For F-S topo data
#lowvalue='-10000'; highvalue='5000'; interval='1000'; unit="km" #For Humorum topo data
#lowvalue='-10000'; highvalue='5000'; interval='1000'; unit="km" #For Orientale topo data
#lowvalue='-9000'; highvalue='9000'; interval='1000'; unit="km" #For SPA topo data
#lowvalue='0'; highvalue='60'; interval='5'; unit="km" #For crustal thickness data

# Create the color scale
#makecpt -Crainbow -Z -T$lowvalue/$highvalue/$interval > $cptname.cpt #topo
makecpt -Cno_green -T$lowvalue/$highvalue/$interval > $cptname.cpt #gravity

# Or use a pre-gen one
#cptname = "gravity_anomalies"

# Define the projection and range
## Humorum: 321.4E, 24.4S
#projection='JM4i'
#range='R300/-40/340/-5r'

## Freundlich-Sharanov: 175E, 18.5N
projection='JM4i'
range='R155/0/195/35r'

## Orientale: 267.2°E, 19.4°S
#projection='JM4i'
#range='R-120/-40/-70/0r'

## Global (Molleweide):
#projection='JW4i'
#projection='JW9i'
#range='Rd'
#range='Rg'
#range='R90/450/-90/90'
#range='R-90/270/-90/90'

## Global (Equirectangular)
#projection='JX8i/4i'
#range='Rg' #0/360
#range='Rd' #-180/180

## Global (perspective view)
## Centered on Orientale
#projection='JG-80/-35/3i'
#range='Rg'
## Centered on South Pole-Aitken
#projection='JG180/-56/4i' #(from the-moon.wikispaces.com)
#projection='JG191/-54/6i' #(tweaked)
#range='Rg'

#Lat/lon lines: B[Marked lons]g[lon lines]/[Marked lats]g[lat lines]
#latlonscale='B10g10/10g10' #for regional plots
latlonscale='B30g/30g' #for global plots

#Scalebar:
#Humorum:
#scalebar='Lf315/-35/-34.5/500k:"km":'
#Freundlich-Sharanov:
#scalebar='Lf170/5/5.5/500k:"km":'

#Plot up an empty file to get the plot started and the borders/title/etc drawn
touch baz
#psxy baz -$range -$projection -$latlonscale:.:WSNE -Gblack \
psxy baz -$range -$projection \
    -X"$xstart"i -Y"$ystart"i -K > $outname.ps
rm baz

#Data of interest
grdimage $data_file -$range -$projection -$latlonscale -C$cptname.cpt \
    -Q -K -O >> "$outname".ps

#Small circles & basin centers
#psxy $circlesfile -$range -$projection -m -Wblack -L -K -O >> $outname.ps

#Also write out data along these tracks?
#grdtrack $circlesfile -G$data_file -m -fg > "$circles_outname".csv

#Draw profile tracks on the map?
#psxy $tracksfile -$range -$projection -m -Wthick,green \
#    -L -K -O >> $outname.ps

#Also write out data along these profiles?
#grdtrack $tracksfile -G$data_file -m -fg > "$tracks_outname".csv

#Scale bar
#psbasemap -J -R -X-4i -$scalebar  -K -O >> $outname.ps

#Legend (vertical)
# -D[xpos/ypos/length/width]
#psscale -D7i/3i/6i/.5i -B"$interval"a"$interval":.Topography: -C$cptname.cpt \
#    --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> $outname.ps
#Legend (horizontal)
#psscale -D1i/-.5i/2i/.2ih -B"$interval"a"$interval":"$unit": -C$cptname.cpt \
#    --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps


#Create a .eps version, and open the file for viewing
#ps2raster -A -Te $outname.ps  #makes .eps file
#evince $outname.ps & # on Linux

#ps2pdf $outname.ps
#rm $outname.ps
#open $outname.pdf # on OS X

open $outname.ps # on OS X
