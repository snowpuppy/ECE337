#!/usr/local/bin/python2.6
#
# Description: This file is for calculating
# the pixel clock for an hdmi signal given 
# the refresh rate and the resolution.
#
from __future__ import division
import sys

if (len(sys.argv) != 4):
    print "Usage: %s <refresh_rate> <pixelw> <pixelh>" % (sys.argv[0],)
    sys.exit(1)

# enter refresh rate here
try:
    REFRESH_RATE = int(sys.argv[1])
except:
    print "Error: Integer refresh rate required."
    sys.exit(1)

TIME_REFRESH = 1/REFRESH_RATE

# enter dimensions here.
try:
    PIXEL_W = int(sys.argv[2])
    PIXEL_H = int(sys.argv[3])
except:
    print "Error: Integer pixel dimensions required."
    sys.exit(1)

NUM_PIXELS = PIXEL_W*PIXEL_H
BPP = 10

#FREQ = 1/(TIME_REFRESH/NUM_PIXELS/BPP)
FREQ = NUM_PIXELS*REFRESH_RATE*10

print "FREQ = %.3fMHZ" % (FREQ/1e6, )
