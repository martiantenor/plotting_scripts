#!/usr/bin/env python
#
# A program that takes files A and B and returns A-B. Files are assumed to be in
# columns X, Y, and Z, and output is given in that same format.

import sys

# Which columns are your data in?

# Raw files without an ID column:
#xcolumn = 0
#ycolumn = 1
#valcolumn = 2

# Files with an extra column at the beginning:
xcolumn = 1
ycolumn = 2
valcolumn = 3

# Files that are just x, y, value:
#xcolumn = 0
#ycolumn = 1
#valcolumn = 2



data = open(sys.argv[1], 'r')
base = open(sys.argv[2], 'r')

baselines = base.readlines()
datalines = data.readlines()

base.close()
data.close()

newdata = []
for i in range(len(baselines)):
    if baselines[i].startswith("#") or datalines[i].startswith("#"):
        continue

    baseval = eval(baselines[i].strip().split()[valcolumn])
    datax = eval(datalines[i].strip().split()[xcolumn])
    datay = eval(datalines[i].strip().split()[ycolumn])
    dataval = eval(datalines[i].strip().split()[valcolumn])

    newval = dataval - baseval

    newdata.append( [datax, datay, newval] )

for item in newdata:
    print "%16.4f %16.4f %16.4f"%(item[0],item[1],item[2])
