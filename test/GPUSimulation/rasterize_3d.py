#!/usr/local/bin/python2.6
from __future__ import division
import line_drawing
import numpy

def orthographic_projection(list_tuples):
    plane_points = []
    for i in list_tuples:
        x = i[0]
        y = i[2]
        line_drawing.screen[int(y)][int(x)] = "#"

#def perspective_projection(list_tuples, intheta, ):
#    theta = numpy.array([
