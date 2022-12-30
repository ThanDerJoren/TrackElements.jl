module TrackElements
using CSV, DataFrames
using Plots, StatsPlots

#=Ich arbeite in normalem Koordinatensystem, 
nicht im Geodäten koordinatensystem
=#
include("math.jl")
include("loadFile.jl")
include("plotCoordinates.jl")
include("sortOrder.jl")
function TrackElement()
    testDocument = "C:/Users/Julek/Nextcloud/A Verkehrsingenieurwesen/ifev/ProgrammRadienBestimmen/Streckenachse freihand erfasst (aus ProVI).PT"
    coordinates = loadFile(testDocument, ".PT")
    plot2D(coordinates)
    #sortByDistance!(coordinates, 55)
    sortByDistanceConsideringAngel!(coordinates, 55)
    plot2D(coordinates)
end ##TrackElement

TrackElement()

end##module TrackElements
