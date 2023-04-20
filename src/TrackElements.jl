module TrackElements
using CSV, DataFrames
#using Plots, StatsPlots 
using CairoMakie
using LinearAlgebra #wird für die Regression bei Radiusberechnung benötigt

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
    testDocument = raw"C:\Users\Julek\Nextcloud\A Verkehrsingenieurwesen\ifev\ProgrammRadienBestimmen\Streckenachse freihand erfasst (aus ProVI).PT" ##raw macht aus \ die benötigten /
    #testDocument = "Streckenachse freihand erfasst (aus ProVI).PT"
    #testDocument = "C:/Users/Julek/Nextcloud/A Verkehrsingenieurwesen/ifev/ProgrammRadienBestimmen/Streckenachse freihand erfasst (aus ProVI).PT"
    coordinates = loadFile(testDocument, ".PT")
    plotTrack(coordinates)
    firstCoordinate = findFirstCoordinate(coordinates)
    sortByDistance!(coordinates, firstCoordinate)
    plotTrack(coordinates)
    # calculateAverageOfDifferentCentralRadii!(coordinates, trackProperties)
    # calculateAverageOfLeftsideCentralRightsideRadii!(coordinates, trackProperties)
    # calculateRadiusWithLeastSquareFittingOfCircles!(coordinates, trackProperties)
    # print(trackProperties)
    #CSV.write("TrackProperties.csv", trackProperties)
    #exportCoordinatesAndTrackPropertiesInCSV(coordinates, trackProperties)

end ##TrackElement

TrackElement()

end##module TrackElements
