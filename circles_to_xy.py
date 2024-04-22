#!/usr/bin/env python
#
# Reorganizes azimuthally averaged data from GMT into an X/Y dataset
#
# Dave Blair, Purdue University, 2014-11-14

import fileinput, re
import numpy

# Grab all the data via either "circles_to_xy.py foo" or "cat foo |
# circles_to_xy.py"
infile_data = []
for line in fileinput.input():
    infile_data.append(line)

# Make a class for storing data
class Track:
    def __init__(self, trackname, radius):
        self.name = trackname
        self.radius = radius
        self.y_values = []

# Get the data into a more usable set
data = {}
these_tracks = []
for line in infile_data:

    # Interpret the comment lines
    if line.startswith("> #"):
        this_trackname = line.strip("> #").split()[0].strip(",") + \
                       "_" + \
                       line.strip("> #").split()[-1].split(".")[0] + \
                       "km"
        this_radius = line.strip("> #").split()[-1].split(".")[0]
        this_track = Track(this_trackname, this_radius)
        these_tracks.append(this_track)
        #data[this_track] = []
        continue

    # Ignore pen-change lines
    elif line.startswith(">"):
        continue

    # The normal behavior, for data lines
    this_track.y_values.append(float(line.split()[-1])) #The final column

# Check that things went ok
if len(these_tracks[0].y_values) != 360:
    print "ERROR: Not enough points in each circle!"

# Write our output as a single file (via print statements, so we can pipe instead)
for this_track in these_tracks:

    # Calculate values for this track

    #average_y = sum(y for y in this_track.y_values)/len(this_track.y_values)
    average_y = numpy.mean(this_track.y_values)
    scatter = numpy.std(this_track.y_values)

    # Print it out
    print "%s %8f %8f"%(
        this_track.radius,
        average_y,
        scatter)


    #Then, a header line with all the radii
    #This is slick, but only works on 2.7:
    #print(','.join('{}'.format(k) for k in these_radii)+"\n")
    #headerline = ""
    #for radius in these_radii:
        #headerline += "%.4f,"%radius
    #headerline = headerline.strip(",") + "\n"
    #print headerline

    #Then, the data!
    #for target_radius in these_radii:
    #    if entry[1] == target_radius:
    #        #print "#######%s#######"%target_radius
    #        print ",".join(entry[-1])

    #Doing this pretty is too complicated: here's the simple version
    #print "%s,%.1f,"%(entry[0],entry[1]) + ",".join(entry[-1])
