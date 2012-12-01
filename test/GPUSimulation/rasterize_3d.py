#!/usr/local/bin/python2.6
from __future__ import division
import line_drawing
import numpy

def orthographic_projection(list_tuples):
    plane_points = []
    for i in range(len(list_tuples)):
        #print "x =",list_tuples[i][0]
        #print "y =",list_tuples[i][1]
        if (i == 0):
            p1 = list_tuples[0]
            p2 = list_tuples[1]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
            p2 = list_tuples[3]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
            p2 = list_tuples[7]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
        if (i == 1):
            p1 = list_tuples[1]
            p2 = list_tuples[2]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
            p2 = list_tuples[6]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
        if (i == 2):
            p1 = list_tuples[2]
            p2 = list_tuples[3]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
            p2 = list_tuples[5]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
        if (i == 3):
            p1 = list_tuples[3]
            p2 = list_tuples[4]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
        if (i == 4):
            p1 = list_tuples[4]
            p2 = list_tuples[5]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
            p2 = list_tuples[7]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
        if (i == 5):
            p1 = list_tuples[5]
            p2 = list_tuples[6]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))
        if (i == 6):
            p1 = list_tuples[6]
            p2 = list_tuples[7]
            print_line(p1,p2)
            line_drawing.draw_line(int(p2[0]),int(p2[1]),int(p1[0]),int(p1[1]))

    for i in list_tuples:
        x = i[0]
        y = i[1]
        print "X =", int(x), "Y =", int(y)
        if (int(x) >= 0 and int(y) >= 0 and int(y) < line_drawing.HEIGHT and int(x) < line_drawing.WIDTH):
            line_drawing.screen[int(y)][int(x)] = "*"

def print_line(p1,p2):
    print "Line(%d,%d,%d,%d)" % (p1[0],p1[1],p2[0],p2[1])

#def perspective_projection(list_tuples, intheta, ):
#    theta = numpy.array([
