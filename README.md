# FitFiberToOctagon

The purpose of this algorithm is to fit fiber cross section images to the projected octagonal shape, and extract relevant information: 

* Core center location

* Cladding center location

* Concentricity face to face 

* Concentricity edge to edge

*octagon_fit.m* open a GUI where the user can enter their image of an octagonal inner cladding optical fiber. The GUI calls an edge detection algorithm to find points on the circumference of the octagon. 

*octagon_direct_fit.m* receives a set of points and produces the enclosing and enclosed ellipsoids.
