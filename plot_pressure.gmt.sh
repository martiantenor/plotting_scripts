#!/bin/bash
# A program that takes a pressure data file (two-column X, P) and plot them
# using GMT
#
# (c) David Blair, 2014. This work is licensed under a Creative Commons
# Attribution-NonCommercial-ShareAlike Unported License
# (http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US)

# Grab the input files (which should all by x, y):
args=("@")

# Plot parameters
# Flat model:
#range="R0./500000./-200000./0"
#range="R0/800000/-700000/100000" #Zoomed in, zero moved
#dimensionsxy=".00002"
#dimensionsin="6i/3i"

# Curved model:
projection="JX4i/4i"
#range="R0./2000000./0./2000000" #Whole model
#range="R1000000./2000000./0./1000000." #Zoom 1
range="R0./1000000./1000000./2000000." #Zoom 1
scale="Ba500000f100000/a500000f100000/WSne"

# Output "resolution":
#grid_spacing="10000.0" #Mega-coarse
#grid_spacing="5000.0" #Coarse
grid_spacing="1000.0" #Finest

# Font and other global options and settings
gmtset ANNOT_FONT_PRIMARY Helvetica
gmtset ANNOT_FONT_SIZE 10
gmtset HEADER_FONT_SIZE 20
gmtset LABEL_FONT_SIZE 10
gmtset PAGE_ORIENTATION LANDSCAPE

# Pressure ranges (Orientale):
#min_pressure="-10e6"
min_pressure="-30e6"
max_pressure="10e6"
pressure_increment="5e6"

# Create the color scale
#cptfile='pressure_colors.cpt'
#makecpt -Cjet -T$min_pressure/$max_pressure/$pressure_increment > $cptfile
#makecpt -Cjet -Z -T$min_pressure/$max_pressure/$pressure_increment > $cptfile

# Alternately, just choose a color scale
cptfile='pressure_diff.cpt'

# Set some values to use for two-file increments
firstplot=true
# Flat models
#yvalue1="6i"
#yvalue2="3i"
# Curved models
xstart="2i"
ystart="2i"

# Delete and re-create the output file
outfile="pressures"
rm -f $outfile.ps

for thisfile in $(echo $@); do

    # Define the title and the name of the output file, and delete any existing
    # outfile by that name
    plottitle=$thisfile

    # Process the .xy files into .xy.grd files, if the specified file is a .xy
    if [[ $thisfile == *.xy ]]; then
        surface $thisfile -G$thisfile.grd -I$grid_spacing -$range -Vl -T0.5
        #surface $thisfile -G$thisfile.grd \
        #    -I$grid_spacing -$range -Vl -T0.5 \
        #    -i2s0.001,3s0.001,4

        thisfile=$thisfile.grd
    fi

    # Plot the scale only once
    if $firstplot; then
        psbasemap -$projection \
                  -$range \
                  -$scale \
                  -X$xstart -Y$ystart \
                  -K > $outfile.ps

        grdimage $thisfile \
                  -C$cptfile \
                  -J \
                  -R \
                  -$scale:."$plottitle": \
                  -K -O >> $outfile.ps

        firstplot=false
    else
        psbasemap -$projection \
                  -$range \
                  -$scale \
                  -K -O >> $outfile.ps

        grdimage $thisfile \
                  -C$cptfile \
                  -J \
                  -R \
                  -$scale:."$plottitle": \
                  -K -O >> $outfile.ps
    fi

    psscale -C$cptfile -D5i/2i/4i/0.5i \
            -K -O >> $outfile.ps
done

# Display the result
ps2pdf $outfile.ps $outfile.pdf
rm -f $outfile.ps
evince $outfile.pdf &
