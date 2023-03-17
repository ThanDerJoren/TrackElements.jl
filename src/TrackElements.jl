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
include("calculateTrackProperties.jl")
function TrackElement()
    testDocument = "C:/Users/Julek/Nextcloud/A Verkehrsingenieurwesen/ifev/ProgrammRadienBestimmen/Streckenachse freihand erfasst (aus ProVI).PT"
    coordinates = loadFile(testDocument, ".PT")
    trackProperties = DataFrame(radius=fill(0.0, size(coordinates,1)-2), speedLimit = fill(0.0, size(coordinates,1)-2))
    plot2D(coordinates)
    sortByDistance!(coordinates, 55)
    # sortByDistanceConsideringAngle!(coordinates, 55)
    plot2D(coordinates)
    calculateRadiiFromTrack!(coordinates, trackProperties)
    print(trackProperties)

end ##TrackElement

TrackElement()

end##module TrackElements
