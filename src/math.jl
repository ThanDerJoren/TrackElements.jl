#=
euclideanNorm funktioniert nur im zweidimensionalen
angelBetweenVectors gibt eine Gradzahl zurück
=#
function getVectorFromTo(start::DataFrames.DataFrameRow, ending::DataFrames.DataFrameRow) ##getVector From start To ending
    ##man könnte die Methode noch so abändern, dass auch hier named Tuple übergeben werden müssen
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

function getRadiusOfThreePoints(point1::DataFrames.DataFrameRow, point2::DataFrames.DataFrameRow, point3::DataFrames.DataFrameRow)
    ## hier müssen noch 
    z1 = point1[:xCoordinates] + point1[:yCoordinates]im
    z2 = point2[:xCoordinates] + point2[:yCoordinates]im
    z3 = point3[:xCoordinates] + point3[:yCoordinates]im

    w = (z3-z1)/(z2-z1)
    c = (z2-z1)*(w-abs2(w))/(w-conj(w))+z1
    r = abs(z1-c)
    return r
end ## getRadiusOfThreePoints

