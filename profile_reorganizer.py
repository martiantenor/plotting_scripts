#!/usr/bin/env python
#
# Reorganizes topographic data into a more Excel-friendly format
#
# Dave Blair, Purdue University, 2013/04/01

import fileinput

#Grab all the data via either "profile_reorganizer.py foo" or "cat foo |
#profile_reorganizer.py"
raw_data = []
for line in fileinput.input():
    raw_data.append(line)

#Get the data into a more usable set
data = []
these_basins = []
these_radii = []
for line in raw_data:

    #Interpret the comment lines
    if line.startswith("> #"):
        this_basin = line.split()[1].strip("#").strip(",")
        this_radius = eval(line.split()[-1])
        continue

    #Ignore pen-change lines
    elif line.startswith(">"):
        continue

    #Make sure our lists of basins and radii are complete
    if this_basin not in these_basins:
        these_basins.append(this_basin)
    if this_radius not in these_radii:
        these_radii.append(this_radius)

    #The normal behavior, for data lines
    data.append([this_basin,
                 this_radius,
                 line.split()[-1]])

###DEBUG
#print len(these_basins)
#print len(these_radii)
#print data

#Go through the data and re-organize it
final_data = []
for basin in these_basins:
    for radius in these_radii:
        this_data = [basin,radius,[]]
        for record in data:
            if ( record[0] == basin ) and ( record[1] == radius):
                this_data[-1].append(record[-1])
        final_data.append(this_data)

###DEBUG
#print final_data[-1]

#Write our output (via print statements, so we can pipe instead)
for entry in final_data:

    #First, the header line with the basin name
    #print "%s\n"%entry[0]

    #Then, a header line with all the radii
    #This is slick, but only works on 2.7:
    #print(','.join('{}'.format(k) for k in these_radii)+"\n")
    #headerline = ""
    #for radius in these_radii:
    #    headerline += "%.4f,"%radius
    #headerline = headerline.strip(",") + "\n"
    #print headerline

    #Then, the data!
    #for target_radius in these_radii:
    #    if entry[1] == target_radius:
    #        #print "#######%s#######"%target_radius
    #        print ",".join(entry[-1])

    #Doing this pretty is too complicated: here's the simple version
    print "%s,%.1f,"%(entry[0],entry[1]) + ",".join(entry[-1])
