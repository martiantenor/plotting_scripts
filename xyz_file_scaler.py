#!/usr/bin/env python
# A program to make changes to columns in a file, to scale them to different
# units, change the 0 point, and other simple operations. Output goes to STDOUT
# via a print command.
#
# Contact Dave Blair (dblair@purdue.edu) with questions
#
# (c) David Blair. This work is licensed under a Creative Commons 
# Attribution-ShareAlike Unported License
# (http://creativecommons.org/licenses/by-sa/3.0)

from __future__ import division
import sys

infile = open(sys.argv[1], 'r')

for line in infile:

    # Read and edit the data

    ## For pressure files:
    #a = float(line.split()[0])
    #b = float(line.split()[1]) - 1740000.0 #Changing (0,0)
    #c = float(line.split()[2]) / 1000000.0 #Pa to MPa

    ## For density files:
    a = float(line.split()[0])
    b = float(line.split()[1]) - 1740000.0 #Changing (0,0)
    c = float(line.split()[2])

    # Output the data
    #outfile.write("%16.4f %16.4f %16.4f\n"%(a,b-1700.0,c))
    print "%16.4f %16.4f %16.4f"%(a,b,c)
