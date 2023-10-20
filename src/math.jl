#= TODO brauch ich diesen Kommentar noch?
euclideanNorm funktioniert nur im zweidimensionalen
angelBetweenVectors gibt eine Gradzahl zurück
=#

#=
Each node in the DataFrame trackProperties has a position vector.
If one want to know something about the ralation between two nodes (e.g. the distance), one need the Euclidean vector between these two nodes.
The Euclidean vector points towards the ending Node.
=#
function getVectorFromTo(start::DataFrames.DataFrameRow, ending::DataFrames.DataFrameRow)
    vector::NamedTuple =(
        x = ending[:x]-start[:x],
        y = ending[:y]-start[:y],
        z = ending[:z]-start[:z]
        )
    return vector
end

function getEuclideanNormOf(xValue::Number, yValue::Number )
    length = sqrt((xValue^2)+(yValue^2))
    return length
end 

#=
There are a few ways to get a cricle, thus the radius, through three nodes.
I found the solution which used the complex plane mosed convincing:
https://math.stackexchange.com/a/3503338
=#
function getRadiusOfThreeNodes(node1::DataFrames.DataFrameRow, node2::DataFrames.DataFrameRow, node3::DataFrames.DataFrameRow)
    z1 = node1[:x] + node1[:y]im
    z2 = node2[:x] + node2[:y]im
    z3 = node3[:x] + node3[:y]im

    w = (z3-z1)/(z2-z1)
    c = (z2-z1)*(w-abs2(w))/(w-conj(w))+z1
    r = abs(z1-c)
    return r
end

#=
For a track width of 1435mm the highest radius of a curve is 25000m.
Every node with a radius higher than 25000m lies probably in a straight part of the track.
A straight track isn't something else than a curve with an infinity high radius.
Thats way the attribute will be set to Inf.
To see the transitions between curves and straight lines the radius has to be higher than 50000 to be set to Infinity.
=#
function setStraightLineRadiiToInfinity!(trackProperties::AbstractDataFrame, columnName::Symbol)
    for row in eachrow(trackProperties)
        if row[columnName] >50000
            row[columnName] = Inf
        end
    end
end

#=
This function finds the northernmost, southernmost, easternmost and westernmost node.
For that the nodes have to be sorted again. To keep the order in the main DataFrame the nodes get copied in a new DataFrame.
This information is importend to plot the nodes properly.
=#
function getOuterNodes(trackProperties::AbstractDataFrame)
    trackNodes = copy(trackProperties)
    outerTrackNodes = DataFrame()
    
    sort!(trackNodes, :x)
    push!(outerTrackNodes, first(trackNodes))
    push!(outerTrackNodes, last(trackNodes))

    sort!(trackNodes, :y)
    push!(outerTrackNodes, first(trackNodes))
    push!(outerTrackNodes, last(trackNodes))
    return outerTrackNodes
end    

#=-----------------------------------------------------------------------------------------------------------------
Functions to bring the nodes in the right order
------------------------------------------------------------------------------------------------------------------=#

#=
The nodes map the route of the track. After the import it's not safe that the order of the list matches the order of the nodes on the track.
Every node has two neighbouring nodes (the previous and a following node), except the two ending nodes. 
The function sortNodeOrder! starts at one of these ending nodes and searches node for node the next node with the shortest distance.
The findFirstNode funtion finds one of the two nodes with only one neighbouring node.
Therefore it also searches node for node the next node with the shortest distance. But it starts with a random node and at the end every node has two neighbouring nodes, so they build a circle.
If the findFirstNode function starts with a middle node, one distance is from an ending node to the nearest free node. This distance is larger than every other distance.
That means the node with the largest distance is one of the ending nodes.
=#

function findFirstNode(trackProperties::AbstractDataFrame)
    trackProperties[!, :distanceToNextNode] .= 0.0
    trackProperties[!, :isVisited] .= false
    currentRow = DataFrame()
    nextRowToVisit = DataFrame()
    shortestDistance = Inf
    currentRow = trackProperties[1,:]
    currentRow[:isVisited] = true
    nodeWithLargestDistance = trackProperties[1,:]
    for i in 1:size(trackProperties,1)
        if(i==size(trackProperties,1)) ## This calculates the distance between the first and last coordinate of the DataFrame, which builds the circle.
            currentRow[:distanceToNextNode] = getEuclideanNormOf(currentRow[:x]-trackProperties[1,:x], currentRow[:y]-trackProperties[1,:y])
        else
            for comparedRow in eachrow(trackProperties)
                if(!comparedRow[:isVisited])
                    distance = getEuclideanNormOf(currentRow[:x]-comparedRow[:x],currentRow[:y]-comparedRow[:y])
                    if(distance<shortestDistance)
                        shortestDistance=distance
                        nextRowToVisit = comparedRow
                    end
                end
            end
            currentRow[:distanceToNextNode] = shortestDistance
            shortestDistance = Inf
            nextRowToVisit[:isVisited] = true
            currentRow = nextRowToVisit
        end
    end
    for item in eachrow(trackProperties)
        if (item[:distanceToNextNode]>nodeWithLargestDistance[:distanceToNextNode])
            nodeWithLargestDistance = item
        end
    end
    firstNode = (x=nodeWithLargestDistance[:x], y=nodeWithLargestDistance[:y], z=nodeWithLargestDistance[:z])
    select!(trackProperties, Not(:distanceToNextNode))
    select!(trackProperties, Not(:isVisited))
    return firstNode
end


function sortNodeOrder!(trackProperties::AbstractDataFrame)
    firstNode = findFirstNode(trackProperties)

    trackProperties[!,:sortIndex] .= 0 
    trackProperties[!,:isVisited] .= false
    currentRow = DataFrame()
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
        