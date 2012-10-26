UART To HDMI Adapter
====================

================
== INTRODUCTION:
================
The purpose of this project is to have an adapter that allows
low power microcontrollers to drive an HD TV. The frame rate
will be slow because of limitations from the microcontroller,
but our project is more focused on the novelty of being able
to generate HDMI signals from a low power microcontroller
than on how good the framerate is.

The design will utilize two external SRAM chips generating
the display. A frame recognizer will interpret incoming UART
packets and send that information to a GPU which will interpret
the requested operation and perform the requested manipulation
of the pixel buffer. Note that the color depth is 0-255 for
all three colors (red/green/blue).

=========================
==== DIRECTORY STRUCTURE:
=========================
doc/   src/   test/

doc/
####
The doc/ directory is for documentation of the main design.

src/
####
The src/ directory is for the source code of the main design
(which will turn out to be the entire project directory).

test/
####
The test/ directory is for things we have built to verify our
design concepts and for experimentation.
