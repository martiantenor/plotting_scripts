#!/usr/bin/env python
#
# A program that takes files A and B and returns B-A

import sys

base = open(sys.argv[1], 'r')
data = open(sys.argv[2], 'r')

baselines = base.readlines()
datalines = data.readlines()

base.close()
data.close()

newdata = []
for i in range(len(baselines)):
    if baselines[i].startswith("#") or datalines[i].startswith("#"):
        continue

    baseval = eval(baselines[i].strip().split()[3])
    datax = eval(datalines[i].strip().split()[1])
    datay = eval(datalines[i].strip().split()[2])
    dataval = eval(datalines[i].strip().split()[3])

    newval = dataval - baseval

    newdata.append( [datax, datay, newval] )

for item in newdata:
    print "%16.4f %16.4f %16.4f"%(item[0],item[1],item[2])
