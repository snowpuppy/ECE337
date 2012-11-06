#!/usr/local/bin/python2.6
from __future__ import division
import line_drawing
import rasterize_3d
import numpy
import math


square = [(-5,-5,-5), (-5,5,-5), (5,5,-5), (5,-5,-5), (5,-5,5), (5,5,5), (-5,5,5), (-5,-5,5)]
rotsquare = []

#rx = numpy.array( ( (1, 0, 0), (0, math.cos(math.pi/6), -math.sin(math.pi/6)), (0, math.sin(math.pi/6), math.cos(math.pi/6)) ) )
cospi6 = math.cos(math.pi/6)
sinpi6 = math.sin(math.pi/6)
# declare rotation matrices
rx = numpy.matrix( [ [1, 0, 0], [0, cospi6, -sinpi6], [0, sinpi6, cospi6 ] ] )
ry = numpy.matrix( [ [cospi6, 0, sinpi6], [0, 1, 0], [-sinpi6, 0, cospi6 ] ] )
rz = numpy.matrix( [ [cospi6, -sinpi6, 0], [sinpi6, cospi6, 0], [0, 0, 1] ] )
# rotate the square for viewing.
for i in square:
    p = numpy.matrix([ [ i[0] ], [ i[1] ], [ i[2] ] ] )
    #pos = numpy.matrix( [ [10], [20], [20] ] )
    pos = numpy.matrix( [ [0], [0], [16] ] )
    #n = ry*ry*ry*rz*rz*p
    n = rz*rz*p
    n += pos
    rotsquare.append( (12 + float(n[0])*12/float(n[2]),20 + float(n[1])*20/float(n[2]),float(n[2])) )

print rotsquare

rasterize_3d.orthographic_projection(rotsquare)
line_drawing.print_screen()
