module TrackElements
using CSV, DataFrames
#using Plots, StatsPlots 
using CairoMakie
using LinearAlgebra #wird für die Regression bei Radiusberechnung benötigt
using Printf

#=Ich arbeite in normalem Koordinatensystem, 
nicht im Geodäten koordinatensystem
=#
include("math.jl")
include("loadFile.jl")
include("plotCoordinates.jl")
include("sortOrder.jl")
include("calculateTrackProperties.jl")
include("export.jl")
function TrackElement()
    coordinates = DataFrame()
    trackProperties = DataFrame() ##wird von Funktionen in calculateTrackProperties mit werten befüllt
    outerCoordinates = DataFrame() ## enthält 4 Koordinaten: nördlichste, sündlichste, westlichste und östlichste
    firstCoordinate = NamedTuple()

    filePath = raw"test/data/StreckenachseFreihandErfasst(ausProVI).PT" ##raw macht aus \ die benötigten /
    coordinates = loadFile(filePath, ".PT")
    # coord = loadCoord(file, type = :PT)
    plotTrack(coordinates)
    firstCoordinate = findFirstCoordinate(coordinates)
    sortByDistance!(coordinates, firstCoordinate)
    plotTrack(coordinates)
    calculateAverageOfDifferentCentralRadii!(coordinates, trackProperties)
    calculateAverageOfLeftsideCentralRightsideRadii!(coordinates, trackProperties)
    calculateRadiusWithLeastSquareFittingOfCircles!(coordinates, trackProperties)
    print(trackProperties)
    createPtFileWithRadiiInHighColumn(coordinates,trackProperties[:, :centralRadiiAverage])
    #CSV.write("TrackProperties.csv", trackProperties)
    #exportCoordinatesAndTrackPropertiesInCSV(coordinates, trackProperties)

end ##TrackElement

TrackElement()

end##module TrackElements
