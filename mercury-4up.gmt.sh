#!/bin/bash

# Define some input/output stuff
datadir="./gmt"
#datadir="."
#data="$datadir/data_FA/anomalymap.HGM004.grd"
#gravdata="$datadir/data_Bouguer/HGM002_Bouguer.grd"
#fa_data="$datadir/data_grav/anomalymaps_0KMaltitude/anomalymap.HGM002.grd"
fa_data="$datadir/data_grav/anomalymaps_0KMaltitude/anomalymap.HGM004B.grd"
fa_data_label="Free-Air Anomaly (HGM004B)"

boug_data="$datadir/data_grav_GN/bouguer.grd"
boug_data_label="Bouguer Anomaly (GN 2012-03)"

cthick_data="$datadir/data_grav_GN/cthick2.grd"
cthick_data_label="Crustal Thickness (GN 2012-03)"

#topo_data="$datadir/data_DTM_DLR/M1_DTM.grd"
topo_data="$datadir/data_topo/hdem_16.grd"
topo_data_label="Topography (MLA HDEM_16)"

caloris_floor_outline="$datadir/data_Paul/floor_outline.gmt"
circlesfile="smallcircles_mercury_100km.txt"
#outname='freeair_map_100km' #.ps and .csv get added later
#outname='caloris_FA_forprint' #.ps and .csv get added later
outname='nplains_4up' #.ps and .csv get added later

# As a reminder, to get PDS .JP2 files into GMT-plottable .grd files, do e.g.:
# gdal_translate -of GMT -unscale LDEM_16.JP2 LOLA_16ppd_topo.grd

#GENERAL SETTINGS
gmtset HEADER_FONT_SIZE 12p
gmtset ANNOT_FONT_SIZE_PRIMARY 10p
gmtset LABEL_FONT_SIZE 10p
gmtset ELLIPSOID Mercury
gmtset PAGE_ORIENTATION LANDSCAPE
gmtset GRID_CROSS_SIZE_PRIMARY 0
gmtset PS_COLOR CMYK
#gmtset BASEMAP_TYPE FANCY
#gmtset DOTS_PR_INCH 600
fontcolor=black
##Caloris:
#xstart=1
#xstart_legend=1.1875
#ystart=3
#ystart_legend=3.125
#xspacing=2.5
##N Plains:
xstart=.75
xstart_legend=1
ystart=3
ystart_legend=3
xspacing=2.75
#xspacing=3.5

# Choose/create a color scale with defined interval and high/low values
colorfile='colors'
fa_low='-120'; fa_high='120'; fa_int='20'; fa_scale_int='40' #For FA gravity data
boug_low='-240'; boug_high='240'; boug_int='40'; boug_scale_int='80' #For FA gravity data
cthick_low='0'; cthick_high='100'; cthick_int='10'; cthick_scale_int='20' #For FA gravity data
topo_low='-3'; topo_high='3'; topo_int='0.5'; topo_scale_int='1' #For Caloris topo data
#topo_low='-2'; topo_high='4'; topo_int='0.5'; topo_scale_int='1' #For Raditladi topo data
makecpt -Cno_green -T$fa_low/$fa_high/$fa_int > "$colorfile"_fa.cpt
makecpt -Cno_green -T$boug_low/$boug_high/$boug_int > "$colorfile"_boug.cpt
makecpt -Chot -I -T$cthick_low/$cthick_high/$cthick_int > "$colorfile"_cthick.cpt
makecpt -Crainbow -T$topo_low/$topo_high/$topo_int > "$colorfile"_topo.cpt

# Define the projection, range, and scale bar
# Scalebar syntax:
#scalebar='Lf315/-35/-34.5/500k:"km":'
# Rachmaninoff: 58E 27N
#projection='JL45/10/85/45/2i'
#projection='JM2i'
#range='R45/85/10/45'
# Raditladi: 119E 27N
#projection='JM2i'
#range='R100/140/10/45'
# Mozart: 170E 8N
#projection='JL150/-5/185/30/2i'
#range='R150/185/-5/30'
# Caloris (perspective view): 170E 30N
#projection='JG170/30/2.375i'
#range='Rg'
# Global (perspective view)
#projection='JG170/30/2i'
#range='Rg'
# Global (Molleweide):
#projection='JW8i'
#range='Rg'
# Global (Equirectangular)
#projection='JX8i/2i'
#range='Rg' #0/360
# Northern Plains
projection='JG0/90/2i'
range='R0/360/30/90'
# Lat/lon lines: B[Marked lons]g[lon lines]/[Marked lats]g[lat lines]
#latlonscale='B10g10/10g10' #for regional plots
latlonscale='B30a30' #for global plots

# Scalebar:
# Freundlich-Sharanov:
#scalebar='Lf170/5/5.5/500k:"km":'

# Plot up an empty file to get the plot started and the borders/title/etc drawn
touch baz
psxy baz -$range -$projection -$latlonscale:.:WSNe \
    -X"$xstart"i -Y"$ystart"i -K > "$outname".ps
rm baz

# Data of interest
#grdimage $data -$range -$projection -$latlonscale -C$colorfile -Q -K -O >> $outname.ps
#grdimage $data -$range -$projection -C$colorfile -Q -K -O >> $outname.ps
#grdimage $topo_data -R -J -C$colorfile -Q -K -O >> $outname.ps
grdimage $fa_data -$range -$projection \
    -$latlonscale:."$fa_data_label":WSNe \
    -C$"$colorfile"_fa.cpt \
    --BASEMAP_FRAME_RGB=+$fontcolor -Q -K -O >> "$outname".ps
grdimage $boug_data -$range -$projection \
    -$latlonscale:."$boug_data_label":WSNe \
    -Xa$(echo "1*$xspacing" | bc)i -Ya0i \
    --BASEMAP_FRAME_RGB=+$fontcolor -C"$colorfile"_boug.cpt -Q -K -O >> "$outname".ps
grdimage $cthick_data -$range -$projection \
    -$latlonscale:."$cthick_data_label":WSNe \
    -Xa$(echo "2*$xspacing" | bc)i -Ya0i \
    --BASEMAP_FRAME_RGB=+$fontcolor -C"$colorfile"_cthick.cpt -Q -K -O >> "$outname".ps
grdimage $topo_data -$range -$projection \
    -$latlonscale:."$topo_data_label":WSNe \
    -Xa$(echo "3*$xspacing" | bc)i -Ya0i \
    --BASEMAP_FRAME_RGB=+$fontcolor -C"$colorfile"_topo.cpt -Q -K -O >> "$outname".ps

# Small circles & basin centers
#psxy $circlesfile -R -J -m -Wthinnest,purple -L -K -O >> $outname.ps

# Also write out data along these tracks?
#grdtrack $circlesfile -G$data -m -fg > $outname.csv

# Basin floor outlines
psxy $caloris_floor_outline -R -J -m -W1p,black \
    --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> $outname.ps
psxy $caloris_floor_outline -R -J -m -W1p,black \
    --BASEMAP_FRAME_RGB=+$fontcolor -Xa$(echo "1*$xspacing" | bc)i -Ya0i -K -O >> $outname.ps
psxy $caloris_floor_outline -R -J -m -W1p,black \
    --BASEMAP_FRAME_RGB=+$fontcolor -Xa$(echo "2*$xspacing" | bc)i -Ya0i -K -O >> $outname.ps
psxy $caloris_floor_outline -R -J -m -W1p,black \
    --BASEMAP_FRAME_RGB=+$fontcolor -Xa$(echo "3*$xspacing" | bc)i -Ya0i -K -O >> $outname.ps

# Global gridlines
#psxy -T -$range -$projection -$latlonscale -W0.1/black -K -O >> $outname.ps
#psxy -T -$projection -$range -$latlonscale -Wblack -K -O >> $outname.ps

# Scale bar
#psbasemap -J -R -X-4i -$scalebar  -K -O >> $outname.ps

# Legend (vertical) -D[xpos/ypos/length/width]
#psscale -D3i/2i/4i/.25i -X+2i -B"$interval"a"$interval" -C$colorfile -K -O >> $outname.ps
# Legend (horizontal)
#psscale -D3i/-.5i/5i/.2ih -B$interval"a"$interval" -C$colorfile  -K -O >> $outname.ps
psscale -D0i/-3.5i/2i/.25ih -B"$fa_int"a"$fa_scale_int":"mGal": -C"$colorfile"_fa.cpt \
    -X"$xstart_legend"i -Y"$ystart_legend"i \
    --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps
psscale -D0i/-3.5i/2i/.25ih -B"$boug_int"a"$boug_scale_int":"mGal": -C"$colorfile"_boug.cpt \
    -Xa$(echo "1*$xspacing" | bc)i -Ya0i \
    --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps
psscale -D0i/-3.5i/2i/.25ih -B"$cthick_int"a"$cthick_scale_int":"km": -C"$colorfile"_cthick.cpt \
    -Xa$(echo "2*$xspacing" | bc)i -Ya0i \
    --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps
psscale -D0i/-3.5i/2i/.25ih -B"$topo_int"a"$topo_scale_int":"km": -C"$colorfile"_topo.cpt \
    -Xa$(echo "3*$xspacing" | bc)i -Ya0i \
    --BASEMAP_FRAME_RGB=+$fontcolor -K -O >> "$outname".ps

# Create a .eps version, and open the file for viewing
#ps2raster -A -Te $outname.ps  #makes .eps file
ps2pdf "$outname".ps "$outname".pdf
#trash "$outname".ps
open $outname.pdf
#evince $outname.ps &
