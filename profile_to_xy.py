#!/usr/bin/env python
#
# Reorganizes topographic track / cross-section data from GMT into a set of
# simple X/Y column files
#
# Dave Blair, Purdue University, 2014-01-17

import fileinput, re

### OPTIONS
#outfile_names = ["A","B","C","D","E","F","G"]

### MAIN

# Grab all the data via either "profile_reorganizer.py foo" or "cat foo |
# profile_reorganizer.py"
infile_data = []
for line in fileinput.input():
    infile_data.append(line)

# Make a class for storing data
class track_object:
    def __init__(self, trackname):
        self.name = trackname
        self.x_values = []
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
                       "deg"
        this_track = track_object(this_trackname)
        these_tracks.append(this_track)
        #data[this_track] = []
        continue

    # Ignore pen-change lines
    elif line.startswith(">"):
        continue

    # The normal behavior, for data lines
    this_track.x_values.append(float(line.split()[-2]))
    this_track.y_values.append(float(line.split()[-1]))
    #this_track.y_values.append(float(line.split()[-1])/1000.)

    # Check that things are going ok
    if len(this_track.x_values) != len(this_track.y_values):
        print "ERROR: X and Y value lists of unequal length!"

###DEBUG
#print len(data)
#print data["SPA_B_0deg"]
#print [track.name for track in these_tracks]
#print [track.x_values for track in these_tracks]
#for this_value in these_tracks[0].x_values:
#    print "%f\n"%this_value,


# Output the reorganized data as multiple files
#for this_track in these_tracks:
#    outfile = open("%s.xy"%this_track.name,'w')
#
#    for i in range(len(this_track.x_values)):
#        outfile.write("%8.8f %8.8f\n"%(this_track.x_values[i],
#                                       this_track.y_values[i]))
#
#    outfile.close()

##Write our output as a single file (via print statements, so we can pipe instead)
for this_track in these_tracks:

    #First, the header line with the basin name
    #print "%s\n"%entry[0]

    #Then, a header line with all the radii
    #This is slick, but only works on 2.7:
    print(','.join('{}'.format(k) for k in these_radii)+"\n")
    headerline = ""
    for radius in these_radii:
        headerline += "%.4f,"%radius
    headerline = headerline.strip(",") + "\n"
    print headerline

    #Then, the data!
    #for target_radius in these_radii:
    #    if entry[1] == target_radius:
    #        #print "#######%s#######"%target_radius
    #        print ",".join(entry[-1])

    #Doing this pretty is too complicated: here's the simple version
    print "%s,%.1f,"%(entry[0],entry[1]) + ",".join(entry[-1])
