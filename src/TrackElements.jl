module TrackElements
using DataFrames                                               ## main data structure
using CSV, Tables, Printf                                      ## import/ export
using LinearAlgebra                                            ## math
using LightOSM, HTTP, LightXML, Geodesy                        ## osmAdjustment
using CairoMakie; CairoMakie.activate!(type = "svg")           ## plot
using Dates                                                    ## TrackElements
#=
EXPLANATION of some Packages
Tables is needed for the export of Arrays in CSV -> TODO isn't in use anymore? can be deleted?
Printf is used in createPtFileWithRadiiInHighColum. It put the columns in the right length
LinearAlgebra is used for the regression in calculateRadiusWithLeastSquareFittingOfCircles!
Geodesy converts different coordinate systems
=#

export getNodesOfOSMRelation
export getNodesOfOSMWay
export getRadiiOfNodes

include("import.jl")
include("osmAdjustment.jl")
include("math.jl")
include("plot.jl")
include("export.jl")

function getNodesOfOSMRelation(relationID::Int)
    accessTime = dateTimeForFilePath(now())
    getOSMRelationXML(relationID)
    extractTrackNodes(relationID, "relation")
    nodesWithUTMCoordinates = convertLLAtoUTM()
    exportDataFrameToCSV(nodesWithUTMCoordinates,"data/osmRelations/relationID_$(relationID)_$accessTime.csv")
    return nodesWithUTMCoordinates
end

function getNodesOfOSMWay(wayID::Int)
    accessTime = dateTimeForFilePath(now())
    getOSMWayXML(wayID)
    extractTrackNodes(wayID, "way")
    nodesWithUTMCoordinates = convertLLAtoUTM()
    exportDataFrameToCSV(nodesWithUTMCoordinates,"data/osmRelations/wayID_$(wayID)_$accessTime.csv")
    return nodesWithUTMCoordinates
end 

function getRadiiOfNodes(filePath::String, fileType::String, relationID::String; radiiToCSV=true, trackVisalizationToSVG=false)
    ## relationID is a String, so one can give readable names
    accessTime = dateTimeForFilePath(now())
    trackProperties = loadNodes(filePath, fileType)
    sortNodeOrder!(trackProperties)
    trackVisualization = plotTrack(trackProperties)
    
    calculateAverageOfLeftsideCentralRightsideRadii!(trackProperties)
    setStraightLineRadiiToInfinity!(trackProperties, :leftCentralRightRadiiAverage)
    for radiiAmount in 3:3
        columnName = Symbol("centralRadiiAverageOf$(radiiAmount)Radii")
        calculateAverageOfDifferentCentralRadii!(trackProperties, radiiAmount, columnName)
        setStraightLineRadiiToInfinity!(trackProperties, columnName)
    end
    
    ## Don't delete! For demonstration purposes that circular regression doesen't work:
    # for limit in 1:6
    #     columnName = Symbol("radiusThroughRegressionWith$((2*limit)+1)Nodes")
    #     calculateRadiusWithLeastSquareFittingOfCircles!(trackProperties, limit, columnName)
    #     setStraightLineRadiiToInfinity!(trackProperties, columnName)
    # end

    if radiiToCSV
        exportDataFrameToCSV(trackProperties, "data/trackProperties/TrackProperties_relationID_$(relationID)_$accessTime.csv")
    end
    if trackVisalizationToSVG
        save("data/trackProperties/TrackVisualization_relationID_$(relationID)_$accessTime.svg", trackVisualization)
    end
    return trackProperties
end
getRadiiOfNodes("data/osmRelations/relationID_4238488_without ID.csv", "csv", "4238488_missing_values")
#getRadiiOfNodes("data/osmRelations/relationID_4238488_without-z.csv", "csv", "4238488_without-z")
end

nodesWithUTMCoordinates=getNodesOfOSMRelation(4238488)
createPtFileForOSMNodes(nodesWithUTMCoordinates, "data/osmRelations/relationID_4238488.pt")
getRadiiOfNodes("data/osmRelations/relationID_4238488.csv", "CSV", "4238488", radiiToCSV=false, trackVisalizationToSVG = true)
getRadiiOfNodes("data/ptTracks/StreckenachseFreihandErfasst(ausProVI).PT", "PT", "StreckenachseFreihandErfasst", trackVisalizationToSVG = false )
TrackElements.getRadiiOfNodes("data/osmRelations/relationID_4238488_missing_values.csv", "csv", "4238488_missing_values")
