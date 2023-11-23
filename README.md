# TrackElements
## import.jl
### REQUIREMENTS FOR THE IMPORT
Every file that should be imported is supposed to contain per node at least a nodeID, x and y coordinate in the first three columns.
The z Coordinate is optional. For completeness it is also read but right know it is not used in the calculations. 
**TODO** where do I use the z Coordinate?
**TODO** what happens if a file contains only 3 columns (error because select expect 4 columns?)
There has to be only one node per row.
The x and y coordinates have to be indicated in the UTM coordinate system. 
Right now all nodes have to be located in one UTM zone. 
**TODO** calculate the distance between of nodes in different UTM zones

# Was ich hier erklären sollte.
bei PT file oben steht y und x, drunter stehen die Koordinaten aber andersrum (also x und y)
aufbau eines PT files (damit die exportfunktionen verstanden werden)
UTM Zonen Systematik: plus 500.000 -> eine Koordinaten urprung. Alles passiert im ersten Quadranten, die Knoten lassen sich als ORtsvektoren betrachten

[![Build Status](https://github.com/ThanDerJoren/TrackElements.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/ThanDerJoren/TrackElements.jl/actions/workflows/CI.yml?query=branch%3Amaster)
