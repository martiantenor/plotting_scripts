#!/bin/bash
# A program to take density data files (three-column X, Y, rho) and plot them up
# using GMT.
#
# (c) David Blair, 2014. This work is licensed under a Creative Commons
# Attribution-NonCommercial-ShareAlike Unported License
# (http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US)

# Grab the input files (which should all by x, y):
args=("@")

###REPLACED
## Specify the color file
#cptfile="/project/taylor/a/dave/code/lib/GMTcptfile/density_mantle.cpt"
##cptfile="/project/taylor/a/dave/code/lib/GMTcptfile/density_crust.cpt"

# Plot parameters
# Flat model:
#projection="JX4i/2i"
#range="R0./500000./-200000./0"
#scale="Ba100000/a50000/WSne"
# Curved model:
projection="JX4i/4i"
#range="R0/1800000/0/1800000" #Full quadrant
range="R0/800000/1000000/1800000" #Zoomed in
#range="R0/800000/-700000/100000" #Zoomed in, zero moved
#range="R0/1800/0/1800"
scale="Ba500000f100000/a500000f100000/WSne"

# Whole model
#min_density="2400"
#max_density="3200"
# Mantle only
min_density="3000"
max_density="3400"
density_increment="50" #Coarser
# Crust only
#min_density="2500"
#max_density="2600"
#density_increment="10" #Coarser

#grid_spacing="10000.0" #Coarser
grid_spacing="1000.0" #Finer

# Font and other global options and settings
gmtset ANNOT_FONT_PRIMARY Helvetica
gmtset ANNOT_FONT_SIZE 10
gmtset HEADER_FONT_SIZE 20
gmtset LABEL_FONT_SIZE 10
gmtset PAGE_ORIENTATION LANDSCAPE

# Create the color scale
cptfile='density_colors.cpt'
makecpt -Ccopper -I -T$min_density/$max_density/$density_increment > $cptfile

# Alternately, load a color scale
#cptfile='some_pressure_name.cpt'

# Set some values to use for two-file increments
firstplot=true
# Flat models
#yvalue1="6i"
#yvalue2="3i"
# Curved models
xstart="2i"
ystart="2i"

# Delete and re-create the output file
outfile="densities"
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
        #    -i1,2,3
        thisfile=$thisfile.grd
    fi

    # Plot the scale only once
    if $firstplot; then
        psbasemap -$projection \
                  -$range \
                  -$scale \
                  -X$xstart -Y$ystart \
                  -K > $outfile.ps
                  #-Xr5.0 -Yr18.0 \

        grdimage $thisfile \
                  -C$cptfile \
                  -JX \
                  -R \
                  -$scale:."$plottitle": \
                  -K -O >> $outfile.ps

        firstplot=false
    else
        psbasemap -$projection \
                  -$range \
                  -$scale \
                  -Y-8.0 \
                  -K -O >> $outfile.ps

        grdimage $thisfile \
                  -C$cptfile \
                  -JX \
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
