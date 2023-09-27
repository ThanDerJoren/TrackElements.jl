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

function getEuclideanNormOf(xValue::Number, yValue::Number ) ## Woher weiß ich welchen Datentyp meine WErte in trackProperties haben?
    length = sqrt((xValue^2)+(yValue^2))
    return length
end ##getEuclideanNorm

function getRadiusOfThreeNodes(node1::DataFrames.DataFrameRow, node2::DataFrames.DataFrameRow, node3::DataFrames.DataFrameRow)
    z1 = node1[:x] + node1[:y]im
    z2 = node2[:x] + node2[:y]im
    z3 = node3[:x] + node3[:y]im

    w = (z3-z1)/(z2-z1)
    c = (z2-z1)*(w-abs2(w))/(w-conj(w))+z1
    r = abs(z1-c)
    return r
end ## getRadiusOfThreeNodes

function setStraightLineRadiiToInfinity!(trackProperties::AbstractDataFrame, columnName::Symbol)
    ## 25000 ist der maximal verbaute Radius
    ## alles darüber kann als gerade angesehen werden -> sehr große radien
    for row in eachrow(trackProperties)
        if row[columnName] >50000
            row[columnName] = Inf
        end
    end
end ## setStraightLineRadiiToInfinity


########################################################################
########################################################################

function getOutertrackProperties(trackProperties::AbstractDataFrame)
    ## hier benötige ich explizit pass by value für trackProperties
    # darüber begin finden macht leider doch keinen sinn
    # Es wird je die nördlichste, sündlichste, westlichste und östlichste Koordinate abgespeichert
    trackNodes = copy(trackProperties)
    outerTrackNodes = DataFrame()
    
    sort!(trackNodes, :x)
    push!(outerTrackNodes, first(trackNodes))
    push!(outerTrackNodes, last(trackNodes))

    sort!(trackNodes, :y)
    push!(outerTrackNodes, first(trackNodes))
    push!(outerTrackNodes, last(trackNodes))
    return outerTrackNodes
end##getOutertrackProperties    

function findFirstNode(trackProperties::AbstractDataFrame)
    trackProperties[!, :distanceToNextCoordinate] .= 0.0
    trackProperties[!, :isVisited] .= false
    currentRow = DataFrame()
    nextRowToVisit = DataFrame()
    shortestDistance = Inf
    currentRow = trackProperties[1,:]
    currentRow[:isVisited] = true
    coordinateWithLargestDistance = trackProperties[1,:]
    #firstCoordinate::NamedTuple ##kann man so eine Variable deklarieren?
    for i in 1:size(trackProperties,1) ##innerhalb dieser forschleife darf der DataFrame nicht neu sortiert werden
        if(i==size(trackProperties,1)) ##Schließt den Kreis distanz von der letzten Coordinate zur ersten Koordinate des Durchlaufs (Standardmäßig 1. Zeile). Deswegen nicht neu sortieren, sonst ist die Koordinate in der ersten Zeile eine andere.
            currentRow[:distanceToNextCoordinate] = getEuclideanNormOf(currentRow[:x]-trackProperties[1,:x], currentRow[:y]-trackProperties[1,:y])
        else
            for comparedRow in eachrow(trackProperties)
                if(!comparedRow[:isVisited])
                    distance = getEuclideanNormOf(currentRow[:x]-comparedRow[:x],currentRow[:y]-comparedRow[:y])
                    if(distance<shortestDistance)
                        shortestDistance=distance
                        nextRowToVisit = comparedRow
                    end##if
                end##if
            end##for
            currentRow[:distanceToNextCoordinate] = shortestDistance
            shortestDistance = Inf
            nextRowToVisit[:isVisited] = true
            currentRow = nextRowToVisit
        end##if
    end##for
    for item in eachrow(trackProperties)
        if (item[:distanceToNextCoordinate]>coordinateWithLargestDistance[:distanceToNextCoordinate])
            coordinateWithLargestDistance = item
        end#if
    end##for
    firstCoordinate = (x=coordinateWithLargestDistance[:x], y=coordinateWithLargestDistance[:y], z=coordinateWithLargestDistance[:z])
    select!(trackProperties, Not(:distanceToNextCoordinate))
    return firstCoordinate
end##findFirstCoordinate

function sortNodeOrder!(trackProperties::AbstractDataFrame) ## start soll 1 sein wenn nichts übergeben wird
    firstNode = findFirstNode(trackProperties)

    trackProperties[!,:sortIndex] .= 0 ##kann man auch leere Spalten einfügen?
    trackProperties[!,:isVisited] .= false ## mit .= werden alle Zeilen mit dem gleichen wert befüllt?
    currentRow = DataFrame() ##kann man definieren, dass es einfach nur ein DataFrameRow ist?
    nextRowToVisit = DataFrame()
    shortestDistance = Inf
    
    for item in eachrow(trackProperties) ##hier wird die firstCoordinate im Datensatz gesucht
        if(item[:x]==firstNode[:x] && item[:y]==firstNode[:y] && item[:z]==firstNode[:z])
            currentRow = item ## hier entsteht ein DataFrameRow
            currentRow[:isVisited] = true ##hier wird der Startpunkt konfiguriert
            currentRow[:sortIndex] = 1  ##hier wird der Startpunkt konfiguriert
            break
        end##if
    end##for

    for i in 2:size(trackProperties,1) #mit 2 Anfange: 1. sortIndex stimmt sofort 2. Der Letzte Punkt hat keine "nextRowToVisit", darf den Prozess also nicht mehr durchlaufen
        for comparedRow in eachrow(trackProperties) ## die Eigene Zeile muss ausgeschlossen werden!!
            if(!comparedRow[:isVisited]) ## bereits besuchte Koordinaten müssen nicht mehr verglichen werden
                distance = getEuclideanNormOf(currentRow[:x]-comparedRow[:x],currentRow[:y]-comparedRow[:y])
                #= Man guckt sich für jede Koordinate jede andere (nicht besuchte) Koordinate an
                ist es die Kürzeste distanz, wird sie als die Folgekoordinate abgespeichert
                findet man danach einen kürzeren Abstand, wird alles mit der neuen Folgekoordinate überschrieben
                =#
                if(distance < shortestDistance)
                    shortestDistance = distance
                    nextRowToVisit = comparedRow
                    comparedRow[:sortIndex] = i
                end #if
            end##if
        end##for
        nextRowToVisit[:isVisited] = true ##erst hier ist sicher, welche koordinate den kürzesten Abstand hat
        currentRow = nextRowToVisit
        shortestDistance = Inf ##für den nächsten durchlauf wieder reseten
    end ## for loop  
    sort!(trackProperties, :sortIndex)
    #print(trackProperties)
    select!(trackProperties, Not(:isVisited))
    select!(trackProperties, Not(:sortIndex)) ##wie schaffe ich das in einer Zeile?
    println(trackProperties)
end ##sortByDistance

############################################################################
############################################################################

function calculateRightsideRadiiFromTrack!(trackProperties::AbstractDataFrame)
    rightsideRadii = fill(0.0, size(trackProperties,1)) ## es muss sichergestellt werden, dass alle Arrays, die trackProperties hinzugefügt werden sollen, die gleiche Länge haben
    for i in 1:size(trackProperties, 1)-2
        rightsideRadii[i] = getRadiusOfThreeNodes(trackProperties[i,:], trackProperties[i+1,:], trackProperties[i+2,:])
    end ##for
    trackProperties[!, :rightsideRadii] = rightsideRadii ## hier wird das vorher berechnete Array, dass genauso lang ist wie der Koordinaten DataFrame, als Spalte zu dem DataFrame trackProperties hinzugefügt.
end ##calculateRadiiFromTrack

function calculateAverageOfDifferentCentralRadii!(trackProperties::AbstractDataFrame, radiiAmount::Int, columnName::Symbol)
    ##radiiAmount: Aus wie vielen Radien der Mittelwert berechnet werden soll
    #= Es werden mehrere Radien aus 3 Koordinaten berechnet. Dabei bleibt eine Koordinate immer gleich(central).
    Es wird immer eine Koordinate rechts und eine links von der Zentralen Koordinate gewählt.
    Bei dem ersten radius werden die Koordinaten direkt je rechts und links von der Zentralen Koordinate gewählt.
    Bei jedem weiteren Radius, der berechnet wird, wird der Abstand zur Zentralen Koordinate immer um eine Koordinate vergrößert.
    Der Parameter "radiiPerCoordinate" gibt dabei an wie viele Radien pro Zentraler Koordinate berechnet werden.
    Wie viele Koordinaten also maximal nach links und rechts gewandert werden.
    Am Ende wird das arithmetische Mittel aus allen berechneten Radien gebildet.
    =#
    centralRadiiAverage = fill(0.0, size(trackProperties,1))
    for center in radiiAmount+1:size(trackProperties,1)-radiiAmount ## es werden z.B. 3 Radien gebildet, von der letzten zentralen Koordinate braucht man noch 3 Koordinaten zu jedem Rand
        radiusAverage = 0
        for i in 1:radiiAmount
            radiusAverage = radiusAverage+getRadiusOfThreeNodes(trackProperties[center-i,:], trackProperties[center,:], trackProperties[center+i,:])
        end ## for i
        radiusAverage = radiusAverage/radiiAmount
        centralRadiiAverage[center] = round(radiusAverage) ##ACHTUNG hier wird gerundet
    end ##for center
    trackProperties[!, columnName] = centralRadiiAverage
end ##calculateAverageRadiiOfDifferentCentralRadii

function calculateAverageOfLeftsideCentralRightsideRadii!(trackProperties::AbstractDataFrame)
    #= Es werden 3 Radien aus je 3 Koordinaten berechnet. Dabei betrachtet man eine Koordinate als Zentral.
    Die beiden weiteren Koordinaten sind
    a) die beiden nächsten Koordinaten direkt links von der zentralen Koordinate (linksseitiger Radius)
    b) direkt links und rechts neben der zentralen Koordinate (zentraler Radius)
    c) die beiden nächsten Koordinaten direkt rechts von der zentralen Koordinate (rechtsseitiger Radius)
    Aus diesen 3 Radien wird dann das arithmetische Mittel gebildet.
    =#
    leftCentralRightRadiiAverage = fill(0.0, size(trackProperties,1))
    for center in 3:size(trackProperties,1)-2 ## Am Rand müssen neben dem letzten zu berechnenden center noch 2 Koordinaten verfügbar sein
        radiusAverage = 0
        leftsideRadius = getRadiusOfThreeNodes(trackProperties[center-2,:], trackProperties[center-1,:], trackProperties[center,:])
        centralRadius = getRadiusOfThreeNodes(trackProperties[center-1,:], trackProperties[center,:], trackProperties[center+1,:])
        rightsideRadius = getRadiusOfThreeNodes(trackProperties[center,:], trackProperties[center+1,:], trackProperties[center+2,:])
        radiusAverage = (leftsideRadius+centralRadius+rightsideRadius)/3
        leftCentralRightRadiiAverage[center] = round(radiusAverage) ##ACHTUNG hier wird gerundet
    end ## for center
    trackProperties[!, :leftCentralRightRadiiAverage] = leftCentralRightRadiiAverage
end## calculateAverageOfLeftsideCenterRightsideRadii

function calculateRadiusWithLeastSquareFittingOfCircles!(trackProperties::AbstractDataFrame, limit::Int, columnName::Symbol)
    #=hier soll der Radius durch eine Regression anngenähert werden.
    Dafür gibt es wieder eine Zentrale Koordinate. Mit dem parameter limit kann geregelt werden, wie viele Koordinaten je links und rechts vom Zentrum mit in die Regression mit einfließen soll.
    ACHTUNG: Die berechneten Radien sind komplett unrealistisch!!
    =#
    radiusThroughRegression = fill(0.0, size(trackProperties,1))
    #limit = 6
    for center in limit+1:size(trackProperties,1)-limit
        A = [trackProperties[center-limit:center+limit,:x] trackProperties[center-limit:center+limit,:y] fill(1, limit*2+1)]
        B = [(trackProperties[center-limit:center+limit,:x]).^2+(trackProperties[center-limit:center+limit,:y]).^2] ## hier ist dim(B) = (1,1)
        B = B[1] ## vorher liegt der gesamte vektor in einem Eintrag, dem ersten. Jetz ist dim(B)=(7,1)
        x = pinv(A)*B
        radiusThroughRegression[center] = round(sqrt(4*(x[3])^2+x[1]^2+x[2]^2)/2) ## ACHTUNG hier wird gerundet
    end ## for center
    trackProperties[!, columnName] = radiusThroughRegression
end##calculateRadiusWithLeastSquareFittingOfCircles
        