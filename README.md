For Users

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

[![Build Status](https://github.com/ThanDerJoren/TrackElements.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/ThanDerJoren/TrackElements.jl/actions/workflows/CI.yml?query=branch%3Amaster)
