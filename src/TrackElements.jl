module TrackElements
using CSV, DataFrames
#using Plots, StatsPlots 
using CairoMakie
using LinearAlgebra #wird für die Regression bei Radiusberechnung benötigt
using Printf

export TrackElement ##sonst würde er nach using TrackElements nur TrackElements.TrackElement kennen. Durch das export ändert sich das

#=Ich arbeite in normalem Koordinatensystem, 
nicht im Geodäten koordinatensystem
=#
include("math.jl")
include("import.jl")
include("plot.jl")
include("sortOrder.jl")
include("calculateRadii.jl")
include("export.jl")
function TrackElement()
    trackProperties = DataFrame()
    outertrackProperties = DataFrame() ## enthält 4 Koordinaten: nördlichste, sündlichste, westlichste und östlichste
    firstCoordinate = NamedTuple()

    filePath = raw"test/data/StreckenachseFreihandErfasst(ausProVI).PT" ##raw macht aus \ die benötigten /
    trackProperties = loadCoordinates(filePath, ".PT")
    # coord = loadCoord(file, type = :PT)
    plotTrack(trackProperties)
    firstCoordinate = findFirstCoordinate(trackProperties)
    sortByDistance!(trackProperties, firstCoordinate)
    plotTrack(trackProperties)
    calculateAverageOfDifferentCentralRadii!(trackProperties)
    calculateAverageOfLeftsideCentralRightsideRadii!(trackProperties)
    calculateRadiusWithLeastSquareFittingOfCircles!(trackProperties)
    print(trackProperties)
    createPtFileWithRadiiInHighColumn(trackProperties, :centralRadiiAverage)
    #CSV.write("TrackProperties.csv", trackProperties)
    #exporttrackPropertiesAndTrackPropertiesInCSV(trackProperties, trackProperties)

end ##TrackElement

TrackElement()

end##module TrackElements
