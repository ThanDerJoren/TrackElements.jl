module TrackElements
using DataFrames                                               ## main data structure
using CSV, Tables, Printf                                      ## import/ export
using LinearAlgebra                                            ## math
using LightOSM, HTTP, LightXML, Geodesy                        ## osmAdjustment
using CairoMakie; CairoMakie.activate!(type = "svg")           ## plot
using Dates                                                    ## TrackElements
#=
EXPLANATION of some Packages
Tables is needed for the export of Arrays in CSV -> isn't in use anymore? can be deleted?
Printf is used in createPtFileWithRadiiInHighColum. It put the columns in the right length
LinearAlgebra is used for the regression in calculateRadiusWithLeastSquareFittingOfCircles!
Geodesy converts different coordinate systems
=#

export getNodesOfOSMRelation
export getNodesOfOSMWay
export getRadiiOfNodes

#=Ich arbeite in normalem Koordinatensystem, 
nicht im Geodäten koordinatensystem
=#

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
end ##getNodesOfOSMRelation

function getNodesOfOSMWay(wayID::Int)
    accessTime = dateTimeForFilePath(now())
    getOSMWayXML(wayID)
    extractTrackNodes(wayID, "way")
    nodesWithUTMCoordinates = convertLLAtoUTM()
    exportDataFrameToCSV(nodesWithUTMCoordinates,"data/osmRelations/relationID_$(relationID)_$accessTime.csv")
    return nodesWithUTMCoordinates
end ##getNodesOfOSMWay

function getRadiiOfNodes(filePath::String, fileType::String, relationID::String)
    ##relationID bewusst ein String, damit man andere namen wählen kann, falls nicht von OSM
    accessTime = dateTimeForFilePath(now())
    trackProperties = loadNodes(filePath, fileType)
    sortNodeOrder!(trackProperties)
    trackVisualization = plotTrack(trackProperties)

    #=
    calculateAverageOfLeftsideCentralRightsideRadii!(trackProperties)
    setStraightLineRadiiToInfinity!(trackProperties, :leftCentralRightRadiiAverage)
    calculateRightsideRadiiFromTrack!(trackProperties)
    setStraightLineRadiiToInfinity!(trackProperties, :rightsideRadii)
    for radiiAmount in 1:1
        columnName = Symbol("centralRadiiAverageOf$(radiiAmount)Radii")
        calculateAverageOfDifferentCentralRadii!(trackProperties, radiiAmount, columnName)
        setStraightLineRadiiToInfinity!(trackProperties, columnName)
    end##for
    # for limit in 1:6
    #     columnName = Symbol("radiusThroughRegressionWith$((2*limit)+1)Nodes")
    #     calculateRadiusWithLeastSquareFittingOfCircles!(trackProperties, limit, columnName)
    #     setStraightLineRadiiToInfinity!(trackProperties, columnName)
    # end##for

    exportDataFrameToCSV(trackProperties, "data/trackProperties/TrackProperties_relationID_$(relationID)_$accessTime.csv")
    #save("data/trackProperties/TrackVisualization_relationID_$(relationID)_$accessTime.svg", trackVisualization)
    =#
    return trackProperties
end ## getRadiiOfNodes


#nodesWithUTMCoordinates=getNodesOfOSMRelation(4238488)
#createPtFileForOSMNodes(nodesWithUTMCoordinates, "data/osmRelations/relationID_4238488.pt")
#getRadiiOfNodes("data/osmRelations/relationID_4238488.csv", "CSV", "4238488")

getRadiiOfNodes("data/ptTracks/StreckenachseFreihandErfasst(ausProVI).PT", "PT", "StreckenachseFreihandErfasst")



#TrackElement("test/data/StreckenachseFreihandErfasst(ausProVI).PT", ".PT")
#TrackElement("test/data/relationID_4238488.csv", ".CSV")

end##module TrackElements
