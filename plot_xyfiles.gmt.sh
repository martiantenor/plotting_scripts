#!/bin/bash

# Data sources and range/scale information

# X, Y, and Z gravity components for a test case
#outfilename="hollow_ball_3components"
#thing1="hollow_ball_Xcomponent-FIXED_acc.xy"
#thing2="hollow_ball_Ycomponent_acc.xy"
#thing3="hollow_ball_Rtotal_acc.xy"
#thing1_range='R0/0.320/-2.5e-6/2.5e-6'
#thing1_scale='Ba0.020g0.010/a5e-7g1e-7:mGal:WS:.X-Acceleration:'
#thing1_color='red'
#thing2_range='R0/320/-2.5e-6/2.5e-6'
#thing2_scale='Ba20g10/a5e-7g1e-7:mGal:WS:.Y-Acceleration:'
#thing2_color='darkgreen'
#thing3_range='R0/320/-2.5e-6/2.5e-6'
#thing3_scale='Ba20g10/a5e-7g1e-7:mGal:WS:.R-Acceleration:'
#thing3_color='blue'

# Hollow ball test
#thing1_range='R0/1000/0/2e5'
#thing1_scale='Ba100g50:km:/a50000g10000:mGal:WS:.Acceleration:'
#thing2_range='R0/1000/0/2e5'
#thing2_scale='Ba100g50:km:/a50000g10000:mGal:WS:.Acceleration:'
#thing3_range='R0/1000/0/2e5'
#thing3_scale='Ba100g50:km:/a50000g10000:mGal:WS:.Acceleration:'
# oriC02
#thing1_range='R0/1000/-1000/1000'
#thing1_scale='Ba100g50:km:/a1000g100:mGal:WS:.Free-Air:'
#thing2_range='R0/1000/-1000/1000'
#thing2_scale='Ba100g50:km:/a1000g100:mGal:WS:.Bouguer:'

# Track data for SPA: Topography
#outfilename="SPA_topo_tracks"
#thing1="SPA_topo_A_90deg.xy"
#thing2="SPA_topo_B_0deg.xy"
#thing3="SPA_topo_C_20deg.xy"
#thing1_range='R0/2000/-20/20'
#thing1_scale='Ba200g100:km:/a10g5:km:WS:.Topography:'
#thing1_color='red'
#thing2_range='R0/2000/-20/20'
#thing2_scale='Ba200g100:km:/a10g5:km:WS:.Topography:'
#thing2_color='green'
#thing3_range='R0/2000/-20/20'
#thing3_scale='Ba200g100:km:/a10g5:km:WS:.Topography:'
#thing3_color='blue'

# Track data for SPA: Bouguer gravity anomaly
#outfilename="SPA_bouguer_tracks"
#thing1="SPA_bouguer_A_90deg.xy"
#thing2="SPA_bouguer_B_0deg.xy"
#thing3="SPA_bouguer_C_20deg.xy"
#thing1_range='R0/2000/-300/300'
#thing1_scale='Ba200g100:km:/a100g50:mGal:WS:.Bouguer:'
#thing1_color='red'
#thing2_range='R0/2000/-300/300'
#thing2_scale='Ba200g100:km:/a100g50:mGal:WS:.Bouguer:'
#thing2_color='green'
#thing3_range='R0/2000/-300/300'
#thing3_scale='Ba200g100:km:/a100g50:mGal:WS:.Bouguer:'
#thing3_color='blue'

# Curved vs flat model comparisons: 1 plot, landscape
#outfilename='curvature_comparison'
#range="R0/300/-10/40/"
#scale="Ba25g5:km:/a10g5:mGal:WS"
#thing0="curvature_F10_fa.xy"
#thing0_pen='fat,black,.'
#thing1='curvature_C11_fa.xy'
#thing1_pen='thickest,red'
#thing2='curvature_C12_fa.xy'
#thing2_pen='thickest,darkgreen'
#thing3="curvature_C13_fa.xy"
#thing3_pen='thickest,blue'
#vlines='curved_vs_flat_vertical_lines.xy'
#vlines_pen='black'

# Orientale models
#outfilename="oriC02_visco_frame78"
#range="R0/1000/-1000/1000"
#scale="Ba200g50:km:/a200g50:mGal:WS"
#thing1="oriC02_visco_ps6_frame78_fa.xy"
#thing2="oriC02_visco_ps6_frame78_boug.xy"

# Topography points from Brandon
outfilename="topography"
#range="R0/700/-15/6"
range="R0/800/-12/6"
scale="Ba50g5:'km':/a1g0.5:'km':WS"
#scale="Ba100:'Distance from Basin Center (km)':/a2:'Relief (km)':WS"
thing1=$1
thing1_pen='thickest,black'
#thing2=$2
#thing2_pen='thickest,red'
#thing3=$3
#thing3_pen='thickest,blue'
#thing4=$4
#thing4_pen='thickest,cyan'

# SBC Bouguer data
#outfilename="SBC1_boug"
#range="R0/300/-100/100"
#scale="Ba50g50:km:/a50g50:mGal:WS"
#thing1=$1
#thing1_pen='thickest,blue'
#error_pen='thinnest,blue'
# SBC Gravity Eigenvalue data from Loic
#outfilename="SBC1_boug_e"
#range="R0/300/-70/30"
#scale="Ba50g50:km:/a10g10:Eotvos:WS"
#thing1=$1
#thing1_pen='thickest,blue'
#error_pen='thinnest,blue'


# General settings & environment variables
gmtset HEADER_FONT_SIZE 8p
gmtset ANNOT_FONT_SIZE_PRIMARY 10p
gmtset LABEL_FONT_SIZE 10p
gmtset GRID_PEN_PRIMARY .1p,grey
gmtset PAGE_ORIENTATION LANDSCAPE
#gmtset PAGE_ORIENTATION PORTRAIT
#gmtset DOTS_PR_INCH 600
#xstart=2 #portrait
#xstart=1.5 #landscape

#ystart=1 #one plot, landscape
#ystart=7.5 #three plots
#ystart=9.5 #four plots

#yspacing=-2.5 #three plots
#yspacing=-2.5 #four plots

#Define the projection
#projection='JX9i/6i' #1 plot, landscape
#projection='JX6i/9i' #1 plot, portrait
#projection='JX5i/1.5i' #3 or 4 plots
projection='JX3.5i/2i' #1 plot, sized like 4-up plots

#To match 4-up Moon plots
xstart=1.5
ystart=3.5
#range='R0/800/-10/5'
#scale='Ba100:Distance from Basin Center (km):/a2:Relief (km):WS'


# Create an empty file, and a file that's just a horizontal line at 0
touch baz
echo "0 0"    > foo_straightline.xy
echo "999999 0" >> foo_straightline.xy
#echo "0 2.4460901e-6" > foo_constantvalue.xy
#echo "999999 2.4460901e-6" >> foo_constantvalue.xy

# Everything on one plot
psxy baz -$projection -$range -$scale -X"$xstart"i -Y"$ystart"i \
    -K  > $outfilename.ps
psxy foo_straightline.xy -J -R -W1p,black \
    -K -O >> $outfilename.ps
#psxy foo_constantvalue.xy -J -R -Wthickest,black \
#    -K -O >> $outfilename.ps
#psxy $vlines -m -J -R -Wthick,$vlines_pen \
#    -K -O >> $outfilename.ps
#psxy $thing0 -J -R -W$thing0_pen \
#    -K -O >> $outfilename.ps
#psxy $thing1 -J -R -W$thing1_pen \
#    -Ey2p/$error_pen \
#    -K -O >> $outfilename.ps
psxy $thing1 -J -R -W$thing1_pen \
    -O >> $outfilename.ps
#psxy $thing2 -J -R -W$thing2_pen \
    #-K -O >> $outfilename.ps
#psxy $thing3 -J -R -W$thing3_pen \
    #-O >> $outfilename.ps
#psxy $thing4 -J -R -W$thing4_pen \
#    -K -O >> $outfilename.ps

# Each thing with its own plot
## Thing 1
#psxy baz -$projection -$thing1_range -$thing1_scale -X"$xstart"i -Y"$ystart"i \
#    -K > $outfilename.ps
#psxy foo_straightline.xy -J -R -W1p,black \
#    -K -O >> $outfilename.ps
#psxy foo_constantvalue.xy -J -R -Wthickest,black \
#    -K -O >> $outfilename.ps
##psxy $vlines -m -J -R -Wthick,$vlines_color \
##    -K -O >> $outfilename.ps
#psxy $thing1 -J -R -Wthickest,$thing1_color \
#    -K -O >> $outfilename.ps
#
## Thing 2
#psxy baz -$projection -$thing2_range -$thing2_scale -Y"$yspacing"i \
#    -K -O >> $outfilename.ps
#psxy foo_straightline.xy -J -R -W1p,black \
#    -K -O >> $outfilename.ps
#psxy foo_constantvalue.xy -J -R -Wthickest,black \
#    -K -O >> $outfilename.ps
#psxy $thing2 -J -R -Wthickest,$thing2_color \
#    -K -O >> $outfilename.ps
#
## Thing 3
#psxy baz -$projection -$thing3_range -$thing3_scale -Y"$yspacing"i \
#    -K -O >> $outfilename.ps
#psxy foo_straightline.xy -J -R -W1p,black \
#    -K -O >> $outfilename.ps
#psxy foo_constantvalue.xy -J -R -Wthickest,black \
#    -K -O >> $outfilename.ps
#psxy $thing3 -J -R -Wthickest,$thing3_color \
#    -K -O >> $outfilename.ps
#
# Thing 4
#psxy baz -$projection -$thing4_range -$thing4_scale -Y"$yspacing"i \
#    -K -O >> $outfilename.ps
#psxy foo_straightline.xy -J -R -W1p,black \
#    -K -O >> $outfilename.ps
#psxy foo_constantvalue.xy -J -R -Wthickest,black \
#    -K -O >> $outfilename.ps
#psxy $thing4 -J -R -Wthickest,$thing4_color \
#    -O >> $outfilename.ps

#Copy .ps file to Dropbox?
#cp $outfilename.ps /project/taylor/a/dave/Dropbox/

# Create a PDF and open it for viewing
ps2pdf $outfilename.ps $outfilename.pdf
#rm $outfilename.ps
#evince $outfilename.pdf
open $outfilename.pdf

# ...Or just open the .ps file
#evince $outfilename.ps
#open $outfilename.ps

# Clean up
#rm baz foo_straightline.xy foo_constantvalue.xy
