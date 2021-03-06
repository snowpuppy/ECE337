#!/usr/local/bin/python2.6
from __future__ import division
import line_drawing
import rasterize_3d
import numpy
import math

SIZE = 5

square = [(-SIZE,-2*SIZE,-SIZE), (-SIZE,2*SIZE,-SIZE), (SIZE,2*SIZE,-SIZE), (SIZE,-2*SIZE,-SIZE), (SIZE,-2*SIZE,SIZE), (SIZE,2*SIZE,SIZE), (-SIZE,2*SIZE,SIZE), (-SIZE,-2*SIZE,SIZE)]
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
    pos = numpy.matrix( [ [0], [0], [20] ] )
    #n = ry*ry*ry*rz*rz*p
    n = rz*rz*p
    n += pos
    # I added twelve and twenty to position the object in the middle of the screen.
    # I multiplied by twelve and twenty to scale the object so that it would be bigger.
    rotsquare.append( (12 + 12*float(n[0])/float(n[2]),20 + 20*float(n[1])/float(n[2]),float(n[2])) )

print rotsquare

rasterize_3d.orthographic_projection(rotsquare)
line_drawing.print_screen()
