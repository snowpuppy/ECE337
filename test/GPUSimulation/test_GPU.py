#!/usr/local/bin/python2.6
from __future__ import division
import line_drawing

def test_line(x1,y1,x2,y2):
    if x2 == x1:
        m = "inf"
    else:
        m =  (y2 - y1)/(x2 - x1)
    print "Drawing Line with slope:", m
    line_drawing.draw_line(x1,y1,x2,y2)
    line_drawing.print_screen()
    line_drawing.clr_screen()

#################################################
# test a line from each of the eight quadrants
#################################################
#### POSITIVE SLOPES ##### (Passing For Now)
# slope of 1
test_line(1,1,5,5)
# slope of 1 points reversed.
test_line(5,5,1,1)
# slope < 1
test_line(1,1,5,3)
# slope < 1 points reversed.
test_line(5,3,1,1)
# slope > 1
test_line(1,1,3,5)
# slope > 1 points reversed.
test_line(3,5,1,1)
# slope of zero
test_line(3,5,10,5)
# slope of zero points reversed
test_line(10,5,3,5)
# slope of inf
test_line(3,5,3,25)
# slope of inf points reversed
test_line(3,25,3,5)


#### NEGATIVE SLOPES ##### (Passing)
# slope of -1
test_line(5,0,0,5)
# slope of -1 points reversed
test_line(0,5,5,0)
# slope > -1
test_line(5,2,0,5)
# slope > -1 points reversed
test_line(0,5,5,2)
# slope < -1
test_line(7,0,3,12)
# slope < -1 points reversed
test_line(3,12,7,0)
