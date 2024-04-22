#!/bin/bash

# Grab the first argument, which is the plot name:
plot_title=$1

# This command makes $2 into $1, $3 into $2, and so on; we'll use it to look at
# the 2nd command line on in future arguments
shift

# Take the rest of the arguments and assign them to a "data_files" variable for
# clarity
data_files=$@

# Define the output file using the name passed in above
outfile="$plot_title"

#OLD:
## Grab the input files (which should all by x, y):
##args=("@")
#args=$@
#outfile="thermprofiles.ps"

# Define the file against which we're comparing
#comparisonfile="brandon.thermprofile"
comparisonfile30="BJ20131106_30Kpkm.thermprofile"
comparisonfile20="BJ20131106_20Kpkm.thermprofile"

# Plot parameters
dimensionsxy="4i/6i"

##...for the full T range:
#range="200/1500/-1740000./0." #full half-Moon
#range="200/1500/-500000./0." #shallower but full T range
range="200/2000/-500000./0." #shallower with extra big T range
#range="200/2000/-500000./0." #shallower with slightly more T range
gridlines="Ba200g50:"$xcaption":/a50000g10000:"$ycaption":WN"

##...for a smaller T range:
#range="1200/1400/-1740000./0." #full half-Moon, but less of a T range
#range="1200/1400/-500000./0." #shallower and less of a T range
#range="1280/1350/-500000./0." #shallower and even less of a T range
#gridlines="Ba20g5:"$xcaption":/a50000g10000:"$ycaption":WN"

title="Temperature Profile"
xcaption="Temperature (K)"
ycaption="Depth (m)"

# Font and other global options and settings
gmtset ANNOT_FONT_PRIMARY Helvetica
gmtset ANNOT_FONT_SIZE 10
gmtset LABEL_FONT_SIZE 14
colors=(gray black blue red green orange purple)
colorindex=0

# Remove the output file in case it exists, and touch a temporary file
rm -f $outfile.pdf
touch nodata.tmp

# Plot up the grid using an empty data file
psxy nodata.tmp -JX$dimensionsxy -R$range -W4/2 -P -K \
    -"$gridlines" \
    -X2.0i -Y1.5i > $outfile.ps
    #-Ba100g10:"$xcaption":/a100000g10000:"$ycaption":WN \
    #-Ba50g10:"$xcaption":/a100000g10000:"$ycaption":WN \ #shallower
    #-X5.0 -Y7.0 > $outfile.ps

# Create a title above the plot with the model name
# For Reference, text line is [X Y Size Angle Font Justify Text]
pstext -R -JX \
    -Xa0.1i -Ya1.5i \
    -N -K -O << END >> $outfile.ps
0 0 16 0 Helvetica LM $plot_title
END

# Optional: plot up some standard data in the beginning for comparison
psxy $comparisonfile30 -JX -R -W8,${colors[$colorindex]} -K -O >> $outfile.ps
let colorindex++
psxy $comparisonfile20 -JX -R -W8,${colors[$colorindex]} -K -O >> $outfile.ps
let colorindex++
#psxy $comparisonfile2 -JX -R -W8,${colors[$colorindex]} -K -O >> $outfile.ps
#let colorindex++

# Plot up all the data, using the command-line arguments as files
#for thisfile in $args; do
for thisfile in $data_files; do

    # Make sure the file is sorted by x value (or at least 1st column...)
    sort -n $thisfile > thistempfile.tmp

    # Plot it with lines:
    #psxy thistempfile.tmp -JX -R -W8,${colors[$colorindex]} -K -O >> $outfile.ps
    # Plot it with little circles:
    psxy thistempfile.tmp -JX -R -Sc0.05 -G${colors[$colorindex]} -K -O >> $outfile.ps

    # Remove the temporary file, increment the color index
    #rm thistempfile.tmp
    let colorindex++
done

# Plot the empty data file (to have a consistent close-out line for the
# PostScript file)
psxy nodata.tmp -JX -R -W8 -O >> $outfile.ps

# Cleanup & display: delete the temporary file and show the plot automatically
ps2pdf $outfile.ps $outfile.pdf
rm $outfile.ps
rm nodata.tmp

# on Linux
#evince $outfile.pdf

# on Mac
open $outfile.pdf
