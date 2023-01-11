#=
euclideanNorm funktioniert nur im zweidimensionalen
angelBetweenVectors gibt eine Gradzahl zurück
=#
function getVectorFromTo(start::DataFrames.DataFrameRow, ending::DataFrames.DataFrameRow) ##getVector From start To ending
    vector =(
        xCoordinates = ending[:xCoordinates]-start[:xCoordinates],
        yCoordinates = ending[:yCoordinates]-start[:yCoordinates],
        zCoordinates = ending[:zCoordinates]-start[:zCoordinates]
        )
    return vector ##Datentyp: NamedTuple
end ## getVectorFromTo

function getEuclideanNormOf(xValue::Float64, yValue::Float64 ) ## Woher weiß ich welchen Datentyp meine WErte in Coordinates haben?
    length = sqrt((xValue^2)+(yValue^2))
    return length
end ##getEuclideanNorm

function getDotProductOf(vectorA::NamedTuple, vectorB::NamedTuple)
    dotProduct = vectorA[:xCoordinates]*vectorB[:xCoordinates]+vectorA[:yCoordinates]*vectorB[:yCoordinates]
    return dotProduct
end ##getDotProduct

function getAngleBetweenVectors(vectorA::NamedTuple, vectorB::NamedTuple)
    ## acosd gibt den arkus cosinus in Degree zurück
    angle = acosd(getDotProductOf(vectorA,vectorB)/
                (getEuclideanNormOf(vectorA[:xCoordinates],vectorA[:yCoordinates])*getEuclideanNormOf(vectorB[:xCoordinates],vectorB[:yCoordinates])))
    return angle
end ##getAngelBetweenVectors