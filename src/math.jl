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
To see the transitions between curves and straight lines the radius has to be higher than 50000m to be set to Infinity.
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
For that the nodes have to be sorted again. To keep the order in the main DataFrame, the nodes get copied in a new DataFrame.
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
The findFirstNode funtion finds one of the two nodes with only one neighbouring node.
Therefore it searches node for node the next node with the shortest distance. It starts with a random node and at the end every node has two neighbouring nodes, so they build a circle. Because of this circle one distance is from one ending node to the nearest free node. This distance is larger than every other distance.
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

#=
The nodes map the route of the track. After the import it's not safe that the order of the list matches the order of the nodes on the track.
Every node has two neighbouring nodes (the previous and a following node), except the two ending nodes. 
The function sortNodeOrder! starts at one of these ending nodes and searches node for node the following node with the shortest distance.
=#
function sortNodeOrder!(trackProperties::AbstractDataFrame)
    firstNode = findFirstNode(trackProperties)

    trackProperties[!,:sortIndex] .= 0 
    trackProperties[!,:isVisited] .= false
    currentRow = DataFrame()
    nextRowToVisit = DataFrame()
    shortestDistance = Inf
    
    for item in eachrow(trackProperties) ##searches the firstNode in the DataFrame trackProperties
        if(item[:x]==firstNode[:x] && item[:y]==firstNode[:y] && item[:z]==firstNode[:z])
            currentRow = item 
            currentRow[:isVisited] = true
            currentRow[:sortIndex] = 1  
            break
        end
    end

    for i in 2:size(trackProperties,1) #starts with 2 because the first node was found previously
        for comparedRow in eachrow(trackProperties)
            if(!comparedRow[:isVisited])
                distance = getEuclideanNormOf(currentRow[:x]-comparedRow[:x],currentRow[:y]-comparedRow[:y])
                if(distance < shortestDistance)
                    shortestDistance = distance
                    nextRowToVisit = comparedRow
                    comparedRow[:sortIndex] = i
                end
            end
        end
        nextRowToVisit[:isVisited] = true
        currentRow = nextRowToVisit
        shortestDistance = Inf
    end
    sort!(trackProperties, :sortIndex)
    #print(trackProperties)
    select!(trackProperties, Not(:isVisited))
    select!(trackProperties, Not(:sortIndex))
    #println(trackProperties)
end

#=-----------------------------------------------------------------------------------------------------------------
Functions to calculate the radius of each node 
------------------------------------------------------------------------------------------------------------------=#

#=
This calculation is based on the concept, that there exist only one circle (and its radius) which goes through three specific points in a 2D coordinate System.
There is one current node n, for which the radius will be calculated.
The (central) Radius will be calculated with n-j, n, n+j. So one node is always before n and one node is always behind n.
The functions calculates all raddi from R(n-1, n, n+1) to R(n-radiiAmount, n, n+radiiAmount)
The final radius is the average of all calculated radii.
=#
function calculateAverageOfDifferentCentralRadii!(trackProperties::AbstractDataFrame, radiiAmount::Int, columnName::Symbol)
    centralRadiiAverage = fill(0.0, size(trackProperties,1))
    for center in radiiAmount+1:size(trackProperties,1)-radiiAmount # The first node which can get a radius is not the first node in the DataFrame, because you need the amount of 'radiiAmount' nodes before the first node. The same applies for the end of the DataFrame.
        radiusAverage = 0
        for i in 1:radiiAmount
            radiusAverage = radiusAverage+getRadiusOfThreeNodes(trackProperties[center-i,:], trackProperties[center,:], trackProperties[center+i,:])
        end 
        radiusAverage = radiusAverage/radiiAmount
        centralRadiiAverage[center] = round(radiusAverage)
    end
    trackProperties[!, columnName] = centralRadiiAverage
end


#=
This calculation is based on the concept, that there exist only one circle (and its radius) which goes through three specific points in a 2D coordinate System.
There is one current node n, for which the radius will be calculated.
There are three ways to arrange two nodes arround the main node n.
left:       n-2, n-1, n
central:    n-1, n,   n+1
right:      n,   n+1, n+2
The final radius is the average of the three radii.
=#
function calculateAverageOfLeftsideCentralRightsideRadii!(trackProperties::AbstractDataFrame)
    leftCentralRightRadiiAverage = fill(0.0, size(trackProperties,1))
    for currentNode in 3:size(trackProperties,1)-2 # The first node which can get a radius is not the first node in the DataFrame, because you need 2 nodes before the main node. The same applies for the end of the DataFrame.
        radiusAverage = 0
        leftsideRadius = getRadiusOfThreeNodes(trackProperties[currentNode-2,:], trackProperties[currentNode-1,:], trackProperties[currentNode,:])
        centralRadius = getRadiusOfThreeNodes(trackProperties[currentNode-1,:], trackProperties[currentNode,:], trackProperties[currentNode+1,:])
        rightsideRadius = getRadiusOfThreeNodes(trackProperties[currentNode,:], trackProperties[currentNode+1,:], trackProperties[currentNode+2,:])
        radiusAverage = (leftsideRadius+centralRadius+rightsideRadius)/3
        leftCentralRightRadiiAverage[currentNode] = round(radiusAverage)
    end
    trackProperties[!, :leftCentralRightRadiiAverage] = leftCentralRightRadiiAverage
end


#=
Radius through circular regression. But the "circle" is more a straight line, so the results are nowhere near the actual radii.
https://lucidar.me/en/mathematics/least-squares-fitting-of-circle/
=#
function calculateRadiusWithLeastSquareFittingOfCircles!(trackProperties::AbstractDataFrame, limit::Int, columnName::Symbol)
    radiusThroughRegression = fill(0.0, size(trackProperties,1))
    #limit = 6
    for center in limit+1:size(trackProperties,1)-limit
        A = [trackProperties[center-limit:center+limit,:x] trackProperties[center-limit:center+limit,:y] fill(1, limit*2+1)]
        B = [(trackProperties[center-limit:center+limit,:x]).^2+(trackProperties[center-limit:center+limit,:y]).^2] 
        B = B[1]
        x = pinv(A)*B
        radiusThroughRegression[center] = round(sqrt(4*(x[3])^2+x[1]^2+x[2]^2)/2)
    end
    trackProperties[!, columnName] = radiusThroughRegression
end
