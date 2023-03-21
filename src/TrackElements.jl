module TrackElements
using CSV, DataFrames
using Plots, StatsPlots
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
    trackProperties = DataFrame()
    
    testDocument = "C:/Users/Julek/Nextcloud/A Verkehrsingenieurwesen/ifev/ProgrammRadienBestimmen/Streckenachse freihand erfasst (aus ProVI).PT"
    coordinates = loadFile(testDocument, ".PT")

    #plot2D(coordinates)
    sortByDistance!(coordinates, 55)
    plot2D(coordinates)
    calculateAverageOfDifferentCentralRadii!(coordinates, trackProperties)
    calculateAverageOfLeftsideCentralRightsideRadii!(coordinates, trackProperties)
    calculateRadiusWithLeastSquareFittingOfCircles!(coordinates, trackProperties)
    print(trackProperties)
    #exportCoordinatesAndTrackPropertiesInCSV(coordinates, trackProperties)

end ##TrackElement

TrackElement()

end##module TrackElements
