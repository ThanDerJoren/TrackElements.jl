#=
euclideanNorm funktioniert nur im zweidimensionalen
angelBetweenVectors gibt eine Gradzahl zurück
=#
function getVectorFromTo(start::DataFrames.DataFrameRow, ending::DataFrames.DataFrameRow) ##getVector From start To ending
    ##man könnte die Methode noch so abändern, dass auch hier named Tuple übergeben werden müssen
    vector =(
        x = ending[:x]-start[:x],
        y = ending[:y]-start[:y],
        z = ending[:z]-start[:z]
        )
    return vector ##Datentyp: NamedTuple
end ## getVectorFromTo

function getEuclideanNormOf(xValue::Float64, yValue::Float64 ) ## Woher weiß ich welchen Datentyp meine WErte in trackProperties haben?
    length = sqrt((xValue^2)+(yValue^2))
    return length
end ##getEuclideanNorm

function getDotProductOf(vectorA::NamedTuple, vectorB::NamedTuple)
    dotProduct = vectorA[:x]*vectorB[:x]+vectorA[:y]*vectorB[:y]
    return dotProduct
end ##getDotProduct

function getAngleBetweenVectors(vectorA::NamedTuple, vectorB::NamedTuple)
    ## acosd gibt den arkus cosinus in Degree zurück
    angle = acosd(getDotProductOf(vectorA,vectorB)/
                (getEuclideanNormOf(vectorA[:x],vectorA[:y])*getEuclideanNormOf(vectorB[:x],vectorB[:y])))
    return angle
end ##getAngelBetweenVectors

function getRadiusOfThreePoints(point1::DataFrames.DataFrameRow, point2::DataFrames.DataFrameRow, point3::DataFrames.DataFrameRow)
    z1 = point1[:x] + point1[:y]im
    z2 = point2[:x] + point2[:y]im
    z3 = point3[:x] + point3[:y]im

    w = (z3-z1)/(z2-z1)
    c = (z2-z1)*(w-abs2(w))/(w-conj(w))+z1
    r = abs(z1-c)
    return r
end ## getRadiusOfThreePoints

