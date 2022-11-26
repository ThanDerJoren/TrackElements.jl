module TrackElements
using CSV, DataFrames
using Plots, StatsPlots

include("loadFile.jl")
include("plotCoordinates.jl")
function TrackElement()
    testDocument = "C:/Users/Julek/Nextcloud/A Verkehrsingenieurwesen/ifev/ProgrammRadienBestimmen/Streckenachse freihand erfasst (aus ProVI).PT"
    coordinates = loadFile(testDocument, ".PT")
    plot2D(coordinates)
end ##TrackElement

TrackElement()

end##module TrackElements
