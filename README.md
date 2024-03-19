# For Users

TrackElements is a program which calculates the radii of railway tracks. The basis are UTM coordinates which map the track layout. As a side feature TrackElements can also import UTM coordinates for tracks out of the openStreetMap.

## Functions

### getRadiiOfNodes

```julia
function getRadiiOfNodes(filePath::String, fileType::String,
    relationID::String; radiiToCSV=true, trackVisalizationToSVG=false)
```

Import an CSV file (and other file types) with the UTM coordinates, sort them to the right order, plot the Track, calculate a radius for each coordinate and create a CSV file with the imported data and a new column with the radii.

Filename structure: `"TrackProperties_relationID_$(relationID)_$accessTime"`

#### Arguments

`filePath::String`: location of the file with the UTM coordinates

`fileType::String`: "CSV" or "PT". PT files are used in ProVI

`realtionID::String`: This String is part of the filename of the new created CSV file

`radiiToCSV=true`: whether a CSV file should be created or not

`trackVisalizationToSVG=false`: whether the trackVisualization should be saved as an SVG or not

#### further adjustments in the source code

There are two functios to culculate a radius:
`calculateAverageOfLeftsideCentralRightsideRadii!(trackProperties)`
`calculateAverageOfDifferentCentralRadii!(trackProperties, radiiAmount, columnName)`
By default both are calculated and exported. It is possible to delte/ comment out one of the functions. To prevent an error, you have to comment out the associated function `setStraightLineRadiiToInfinity!`

For the function `calculateAverageOfDifferentCentralRadii!(trackProperties, radiiAmount, columnName)` you can adjust the number of central radii from which the average radius should be calculated.

### getNodesOfOSMRelation

```julia
function getNodesOfOSMRelation(relationID::Int)
```

download relation as XML, extract the nodes, converts them to UTM and export in CSV file.

Filename structure: `"relationID_$(relationID)_$accessTime"`

`relationID::Int`: Each OSM relation has a unique ID.

For the radii calculation it is importend to download only single-Track relations!

### getNodesOfOSMWay

```julia
function getNodesOfOSMWay(wayID::Int)
```

download way as XML, extract the nodes, converts them to UTM and export in CSV file.

Filename structure: `"wayID_$(wayID)_$accessTime"`

`wayID::Int`: Each OSM way has a unique ID.

## Nice to know

### Format guidline CSV file

#### import

The function getRadiiOfNodes will read the first 4 Columns of the CSV file. The file can contain more columns, but they will be ignored. The columns have to contain in this exact order: ID, x-coordinate, y-coordinate, z-coordinate. Each row has to contain exact one node.

If there are missing values at the ID or z-coordinate column, they will be filled with 0.

If there are missing values at the x- or y-coordinate column, the row will be deleted.

The first row will be skipped, so it can contain a header.

The node IDs have to be integer.

#### export

The CSV file which will be crated by the function getRadiiOfNodes has the same structure as the imported files in the first 4 columns. The following columns will contain radii for each coordinate. Each of these columns have a different method for calculating the radius.

To calculate a radius at a specific node, there have to be nodes before at after that specific node. That's why the first and last nodes have no radius or rather a radius of 0.

### further remarks

The x-coordinate is the abscissa
The y-coordinate is the ordinate

The calculations work only within one UTM zone. Right now it is not possible to get the radius at the border crossing of two UTM Zones. So all Nodes in one CSV file should be located in the same UTM zone. If the Track lays in more than one UTM zone you can split the Track in different parts with different CSV files.

Currently, the radius calculation is not really accurate. The calculation is based on the concept, that there exists only one circle (and its radius) which goes through three specific points in a 2D coordinate System. The functions get different radii by combining different 2 nodes about one fix node. The final radius is the average of these different radii.

More details about the calculation of the radii can be found at the functions and its comments under Math.jl in the section "Functions to calculate the radius of each node".

The z-coordinates are not used for the radii calculation. They are imported for the completeness. That's why its ok to set missed values to zero

# For Developers
## further developments

### big changes

#### create a Graph

Right now the focus of the programm are the nodes. They map the track layout and the calculated radii are related to a node. It would be nice to treat the Data more as an graph with nodes and edges. This would allow to calculate a radius for each edge and would be closer to the reality.

Currently, the route of the track is represented by the order of the nodes in the dataFrame. There is no view on the edges. They get only created when it comes to the visualization of the track.

#### various UTM Zones

The UTM system divides the Earth into 60 zones, each 6° of longitude in width.

The coordinate system inside of each Zone is the same. That means it is impossible to know in which Zone a coordinate lays, if you don't get the zone number. Thats why you can't just import coordinates out of two zones in one DataFrame and sort them. You have to split them to have an clear allocation to each zone. To split the coordinates you need the allocation to the zone.

Even within one zone a x, y, z combination is not unequivocal. The point could lay in the northern or southern hemisphere, because the equator starts at 0m for the nothern hemisphere and at 10,000,000m for the southern hemisphere. But this is only important if the track crosses the equator.

The Geodesy package converts also the zone and the hemisphere. If you get the OSM data, you can export also the zone and hemisphere (when I tried this, the hemisphere variable was not defied for some reasons).

It must be decided how to include this information into the CSV file, which get imported.

Furthermore it has to be reseached and implemented how to get a radius, distance and so on, at the edge which crosses the two zones. It may be helpful that there are overlapping grids.

#### improve the radius calculation

As you saw at the remarks above, the calculation of the radius isn't that accurate. It would be nice to improve that part of the code. There are two keywords where it is possible to start the research for better algorithms:

1. find curvey roads:
  
  > https://roadcurvature.com/how-it-works/ -> this is quite near of my approach
  > 
  > [Calculating Road Curvature in R | Spencer Schien](https://spencerschien.info/post/road_directness/)
  
2. curve reconstruction
  
  > for example with:
  > 
  > > a) Reconstruction with constant fitting functions.
  > > 
  > > b) Reconstruction with linear fitting functions.
  > 
  > Here is some literature which may help you to start your research
  > 
  > > [Curve reconstruction from unorganized points](https://doi.org/10.1016/S0167-8396(99)00044-8)
  > > 
  > > [Automatic Road Network Reconstruction from GPS Trajectory Data using Curve Reconstruction Algorithms](https://www.researchgate.net/publication/359419835_Automatic_Road_Network_Reconstruction_from_GPS_Trajectory_Data_using_Curve_Reconstruction_Algorithms)
  > > 
  > > [Realistic road path reconstruction from GIS data](https://onlinelibrary.wiley.com/doi/10.1111/cgf.12494)
  

### small changes

A good validation of the nodes is to check how accurate they lay on the actual track. One way to do this is to display the nodes over orthophotos of the track in a GIS program. A possible open source Program is QGis.

These programs can read shapefiles. So it would be nice to convert the nodes into a shapefile to display them in QGis.

If the program is changed to use a graph there are a few things you can change in the visualization of the track. It would be nice to colour the edges depending on the curvature. Furthermore the visualization would get better if the edges aren't straight lines but a curve equivalent to its radius.

## src file structure

**export.jl:** export the data and radii to CSV or PT.

**import.jl:** imort functions for CSV and PT. Function to deal with missing values.

**math.jl:** split in three sections:

1. mathematical basics for following functions
  
2. Functions to bring the nodes in the right order
  
3. Functions to calculate the radius of each node
  

**osmAdjustment.jl:** complete logic behind the OSM imports. Inclusive converting coordinates from LLA to UTM

**plot.jl:** visualization of the nodes

**TrackElements.jl:** main functions. Here you start the program

[![Build Status](https://github.com/ThanDerJoren/TrackElements.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/ThanDerJoren/TrackElements.jl/actions/workflows/CI.yml?query=branch%3Amaster)
