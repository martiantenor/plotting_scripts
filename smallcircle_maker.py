#!/usr/bin/env python
#
# A program to make a bunch of files describing small circles at given km
# intervals from the center of a feature on the Moon or Mercury
#
# (c) David Blair, 2013. This work is licensed under a Creative Commons
# Attribution-NonCommercial-ShareAlike Unported License
# (http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US)

from math import pi
import subprocess


######## Options ########

#Constants for the body
R_body = 1737.4 #kilometers (Moon)
#R_body = 2439.7 #kilometers (Mercury) (IAU 2000)

#Output filename
#outfile_name = "smallcircles_mercury_100km.txt"
#outfile_name = "smallcircles_SBC_5km.txt"
outfile_name = "smallcircles_SBC_1km.txt"

#Radius of largest circle and radius increment (a 1-km-radius circle is added
#later, so there's no need to define one here)
max_radius = 300
#radius_step = 5
radius_step = 1

#Lon/Lat/ID of centers of our basins of interest
basin_centers = []
#basin_centers.append([ 0, 45, "foo"]) #Test basin
#basin_centers.append([ -38.6, -24.4, "hum"]) #Humorum (from Wikipedia)
#basin_centers.append([ -39.6, -23.4, "Humorum"]) #Humorum (tweaked)
#basin_centers.append([ 175.0, 18.5, "Freundlich-Sharonov"]) #Freundlich-Sharonov
#basin_centers.append([ -92.8, -19.4, "ori"])  #Orientale (from Wikipedia)
#basin_centers.append([ -94, -19.4, "Orientale"])  #Orientale (tweaked)
#basin_centers.append([ -189.8, 30.5, "Caloris"])  #Caloris Basin (from Wikipedia)
#basin_centers.append([ -197.01, 30.58, "Caloris"])  #Caloris Basin (Apollodorus Crater location from Wikipedia)
#basin_centers.append([ -197.5, 32, "Caloris"])  #Caloris Basin (tweaked)
basin_centers.append([ 31.21, 8.66, "SBC1"])  #SBC1


######## Program Body ########

#Calculate circumference and degrees/km along a great circle
C_body = R_body * 2 * pi
degrees_per_km = 360/C_body

#Start with 1, then work up by the range we specified
radii_km = [1]
for radius_km in range(radius_step,max_radius+1,radius_step):
    radii_km.append(radius_km)

#Convert these values to degrees latitude
degrees_lat = []
for radius_km in radii_km:
    degrees_lat.append(90 - radius_km*degrees_per_km)

#Put together all the small-circle data
smallcircles = []
for i in range(len(radii_km)):
    this_smallcircle = []
    this_km = radii_km[i]
    this_lat = degrees_lat[i]
    for azimuth in range(0,360):
        this_smallcircle.append([azimuth, this_lat])
    smallcircles.append(this_smallcircle)

#For each basin in question, get the lat/lon coordinates for every small circle
#around the basin. This involves multiple steps, which are outlined below.
newpoints = ""
for basin_center in basin_centers:

    #Initialize a new set of "oldpoints" for each basin
    oldpoints = ""

    #Get the name of the basin we're working on
    basinID = basin_center[2]

    #Open the GMT tool `project` to get the coordinates of (0/90) and (0/0)
    #after they've been reprojected using the coordinates of the basin center as
    #the pole of rotation
    proc_polerotator = subprocess.Popen("project -T%f/%f -C0/-90 -Fpq -m"%(
                                          basin_center[0],basin_center[1]),
                                        shell=True,
                                        stdin=subprocess.PIPE,
                                        stdout=subprocess.PIPE)
    rotatedpole = proc_polerotator.communicate("0 90\n0 0")[0]

    #Interpret the output of that rotated pole
    t1 = eval(rotatedpole.split("\n")[0].split("\t")[0])
    t2 = eval(rotatedpole.split("\n")[0].split("\t")[1])
    c1 = eval(rotatedpole.split("\n")[1].split("\t")[0])
    c2 = eval(rotatedpole.split("\n")[1].split("\t")[1])

    #Get the input ready by combining each smallcircle into a string with line
    #breaks as if it were a file (it's destined for STDIN). To do this, we'll go
    #through each small circle, go through all the points in it, and turn those
    #into a single string
    for i in range(len(smallcircles)):

        this_smallcircle = smallcircles[i]

        #Add some human-readable comments to this file
        oldpoints += "> #%s, radius %.1f\n"%(basinID, radii_km[i])

        for point_coords in this_smallcircle:
            oldpoints += "%s %s\n"%(point_coords[0],point_coords[1])

    #Open the GMT tool PROJECT to reproject the small circle points around the
    #new pole we've defined for the center of each basin
    proc = subprocess.Popen("project -T%f/%f -C%f/%f -Fpq -m"%(t1,t2,c1,c2),
                            shell=True,
                            stdin=subprocess.PIPE,
                            stdout=subprocess.PIPE)
    newpoints += proc.communicate(oldpoints)[0]

#Write these points to a file for plotting in a GMT script or data extraction in
#`azimuthal_averager.py`
outfile = open(outfile_name,'w')
outfile.write(newpoints)
outfile.close()
