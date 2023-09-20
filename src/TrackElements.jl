module TrackElements
using DataFrames                                               ## main data structure
using CSV, Tables, Printf                                      ## import/ export
using LinearAlgebra                                            ## math
using LightOSM, HTTP, LightXML, Geodesy                        ## osmAdjustment
using CairoMakie; CairoMakie.activate!(type = "svg") #,GLMakie ## plot
#=
EXPLANATION of some Packages
Tables is needed for the export of Arrays in CSV -> isn't in use anymore? can be deleted?
Printf is used in createPtFileWithRadiiInHighColumn. It put the columns in the right length
LinearAlgebra is used for the regression in calculateRadiusWithLeastSquareFittingOfCircles!
Geodesy converts different coordinate systems
=#

export TrackElement ##sonst würde er nach using TrackElements nur TrackElements.TrackElement kennen. Durch das export ändert sich das

#=Ich arbeite in normalem Koordinatensystem, 
nicht im Geodäten koordinatensystem
=#

include("import.jl")
include("osmAdjustment.jl")
include("math.jl")
include("plot.jl")
include("export.jl")

function getNodesOfOSMRelation(relationID::Int)
    getOSMRelationXML(relationID)
    extractTrackNodes(relationID)
    nodesWithUTMCoordinates = convertLLAtoUTM()
    exportDataFrameToCSV(nodesWithUTMCoordinates,"data/osmRelations/relationID_$relationID.csv")
    return nodesWithUTMCoordinates
end ##getNodesOfOSMRelation

function getRadiiOfNodes(filePath::String, fileType::String, relationID::String)
    ##relationID bewusst ein String, damit man andere namen wählen kann, falls nicht von OSM
    trackProperties = loadNodes(filePath, fileType)
    sortNodeOrder!(trackProperties)
    plotTrack(trackProperties)

    calculateAverageOfDifferentCentralRadii!(trackProperties)
    calculateAverageOfLeftsideCentralRightsideRadii!(trackProperties)
    calculateRightsideRadiiFromTrack!(trackProperties)
    setStraightLineRadiiToInfinity!(trackProperties)

    exportDataFrameToCSV(trackProperties, "data/trackProperties/TrackProperties_relationID_$relationID.csv")
    return trackProperties
end ## getRadiiOfNodes


function TrackElement(filePath::String, fileType::String) ##im filePath werden / benötigt
    trackProperties = DataFrame()
    outertrackProperties = DataFrame() ## enthält 4 Koordinaten: nördlichste, sündlichste, westlichste und östlichste
    firstCoordinate = NamedTuple()
    trackProperties = loadNodes(filePath, fileType)
    # coord = loadCoord(file, type = :PT)
    plotTrack(trackProperties)
    
    sortNodeOrder!(trackProperties)
    plotTrack(trackProperties)
    calculateAverageOfDifferentCentralRadii!(trackProperties)
    calculateAverageOfLeftsideCentralRightsideRadii!(trackProperties)
    calculateRightsideRadiiFromTrack!(trackProperties)

    #calculateRadiusWithLeastSquareFittingOfCircles!(trackProperties)
    #print(trackProperties)
    
    #createPtFileWithRadiiInHighColumn(trackProperties, :centralRadiiAverage)
    #CSV.write("TrackProperties_relationID_4238488.csv", trackProperties)
    #exporttrackPropertiesAndTrackPropertiesInCSV(trackProperties, trackProperties)
    #createCSVFile(trackProperties)

end ##TrackElement


nodesWithUTMCoordinates = getNodesOfOSMRelation(4238488)
createPtFileForOSMNodes(nodesWithUTMCoordinates, "data/osmRelations/relationID_4238488.pt")
#getRadiiOfNodes("data/osmRelations/relationID_4238488.csv", ".CSV", "4238488")



#TrackElement("test/data/StreckenachseFreihandErfasst(ausProVI).PT", ".PT")
#TrackElement("test/data/relationID_4238488.csv", ".CSV")

end##module TrackElements
