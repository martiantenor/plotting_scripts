#!/bin/bash
# A program to plot up where tubes fail using GMT
#
# (c) David Blair, 2015. This work is licensed under a Creative Commons
# Attribution-NonCommercial-ShareAlike Unported License
# (http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US)

# Grab the input file (should be roof thickness, width, failure status)
data_file=$1

# Plot parameters: log-log
#projection="JX6il/4il"
#range="R50/12000/1/1000"
#    #tubes up to 10 km wide, roofs up to 500 m thick
#scale="Ba2f2g3:Tube Width (m):/a2f2g3:Roof Thickness (m):WS"
#    #a, f, and g: 1 = every power of 10, 2 = 1-2-5, 3 = 1, 2 ... 9

# Plot parameters: straight x/y
projection="JX6i/4il"
#range="R100/12000/1/1000" #every model
range="R100/8000/1/1000" #DOESN'T COVER WHOLE RANGE!!!
    #tubes up to 10 km wide, roofs up to 500 m thick
#scale="Ba1000f250g250:Tube Width (m):/a50f10g10:Roof Thickness (m):WS"
scale="Ba1000f250g250:Tube Width (m):/a2f2g2:Roof Thickness (m):WS"
    #a, f, and g: 1 = every power of 10, 2 = 1-2-5, 3 = 1, 2 ... 9

# Symbols for the failure statuses:
#s = stable = green circle
#b = borderline = orange inverted tri
#f = failure = red square
#c = crash/failure = red x
#x = crash = grey x
statuses=(
    "s"
    "b"
    "f"
    "c"
    "x"
)
symbols=(
    "Sc0.3i"
    "Si0.3i"
    "Ss0.3i"
    "Sx0.25i"
    "Sx0.25i"
)
colors=(
    "Ggreen"
    "Gorange"
    "Gred"
    "Wthickest,red"
    "Wthickest,grey"
)



# Plot up the first file, through a series of greps
# Search for that letter & save as a temp file
grep "${statuses[0]}$" $data_file > baz

# Plot up that temp file using the appropriate symbol
#psxy baz -: -J -R -B \
    #-"$symbol_s" -"$color_s" \
psxy baz -: -"$projection" -"$range" -"$scale" \
    -${symbols[0]} -${colors[0]} \
    -K >> foo.ps

echo "Stable tubes plotted..."


# Plot up the next few statuses, through a series of greps
for i in {1,2,3}; do

    # Search for that letter & save as a temp file
    grep "${statuses[$i]}$" $data_file > baz

    # Plot up that temp file using the appropriate symbol
    #psxy baz -: -"$projection2" -"$range2" -"$scale2" \
    psxy baz -: -"$projection" -"$range" \
        -${symbols[$i]} -${colors[$i]} \
        -K -O >> foo.ps
    rm baz
    echo "LOOP DONE"
done

# Search for that letter & save as a temp file
grep "${statuses[4]}$" $data_file > baz

# Plot up that temp file using the appropriate symbol
#psxy baz -: -"$projection2" -"$range2" -"$scale2" \
psxy baz -: -"$projection" -"$range" \
    -${symbols[4]} -${colors[4]} \
    -O >> foo.ps
echo "Crashes plotted..."

#touch bar
#psxy bar -"$projection" -"$range" -"$scale" -X2i -Y2i -K -O > foo.ps
#rm bar


# File operations
rm baz
ps2pdf foo.ps
trash foo.ps
open foo.pdf
