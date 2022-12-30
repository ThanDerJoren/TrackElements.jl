#=
euclideanNorm funktioniert nur im zweidimensionalen
angelBetweenVectors gibt eine Gradzahl zurück
=#
function getVectorFromTo(start::DataFrame, ending::DataFrame) ##getVector From start To ending
    vector = DataFrame(
        xCoordinates = ending[:xCoordinates]-start[:xCoordinates],
        yCoordinates = ending[:yCoordinates]-start[:yCoordinates],
        zCoordinates = ending[:zCoordinates]-start[:zCoordinates]
        )
    return vector
end ## getVectorFromTo

function getEuclideanNormOf(xValue::Float64, yValue::Float64 ) ## Woher weiß ich welchen Datentyp meine WErte in Coordinates haben?
    length = sqrt((xValue^2)+(yValue^2))
    return length
end ##getEuclideanNorm

function getDotProductOf(vectorA::DataFrame, vectorB::DataFrame)
    dotProduct = vectorA[:xCoordinates]*vectorB[:xCoordinates]+vectorA[:yCoordinates]*vectorB[:yCoordinates]
    return dotProduct
end ##getDotProduct

function getAngelBetweenVectors(vectorA::DataFrame, vectorB::DataFrame)
    ## acosd gibt den arkus cosinus in Degree zurück
    angel = acosd(getDotProductOf(vectorA,vectorB)/
                (getEuclideanNormOf(vectorA[:xCoordinates],vectorA[:yCoordinates])*getEuclideanNormOf(vectorB[:xCoordinates],vectorB[:yCoordinates])))
    return angel
end ##getAngelBetweenVectors