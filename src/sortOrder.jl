#include("math.jl")
function getOutertrackProperties(trackProperties::AbstractDataFrame, outertrackProperties::AbstractDataFrame)
    # darüber begin finden macht leider doch keinen sinn
    # Es wird je die nördlichste, sündlichste, westlichste und östlichste Koordinate abgespeichert
    sort!(trackProperties, :y)
    push!(outertrackProperties, first(trackProperties))
    push!(outertrackProperties, last(trackProperties))

    sort!(trackProperties, :x)
    push!(outertrackProperties, first(trackProperties))
    push!(outertrackProperties, last(trackProperties))
end##getOutertrackProperties    

function findFirstCoordinate(trackProperties::AbstractDataFrame)
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
    return firstCoordinate
end##findFirstCoordinate



function sortByDistance!(trackProperties::AbstractDataFrame, firstCoordinate::NamedTuple) ## start soll 1 sein wenn nichts übergeben wird
    trackProperties[!,:sortIndex] .= 0 ##kann man auch leere Spalten einfügen?
    trackProperties[!,:isVisited] .= false ## mit .= werden alle Zeilen mit dem gleichen wert befüllt?
    currentRow = DataFrame() ##kann man definieren, dass es einfach nur ein DataFrameRow ist?
    nextRowToVisit = DataFrame()
    shortestDistance = Inf
    
    for item in eachrow(trackProperties) ##hier wird die firstCoordinate im Datensatz gesucht
        if(item[:x]==firstCoordinate[:x] && item[:y]==firstCoordinate[:y] && item[:z]==firstCoordinate[:z])
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







function sortByDistanceConsideringAngle!(trackProperties::AbstractDataFrame, start::Integer)
    #= FRAGE
    Es kann passieren, dass ein Punkt (oder zwei) übersprungen werden, wenn der dahinter liegende Punkt
    einen Flacheren Winkel hat. ist das Problematisch?
    =#
    trackPropertiesInOrder = DataFrame()
    currentRow = DataFrame()
    nextRowToVisit = DataFrame()
    shortestDistance= Inf
    nextPossibletrackProperties = DataFrame()
    
    ##Vorbereitung: befüllen und neue Spalte hiunzufügen, um mit nextPossibletrackProperties arbeiten zu können
    for i in 1:3
        push!(nextPossibletrackProperties, trackProperties[1,:])
    end##for i
    nextPossibletrackProperties[!,:distance].= Inf
    nextPossibletrackProperties[!,:angle].=0.0
    nextPossibletrackProperties[!,:rownumberIntrackProperties].=0

    currentRow = trackProperties[start, :]
    push!(trackPropertiesInOrder, currentRow)
    deleteat!(trackProperties, rownumber(currentRow))
    ## der erste Folgepunkt muss ohne Winkel ermittelt werden, da es noch keine Referenz gibt
    for comparedRow in eachrow(trackProperties)
        lineBetweentrackProperties = getVectorFromTo(currentRow,comparedRow)
        distance = getEuclideanNormOf(lineBetweentrackProperties[:x],lineBetweentrackProperties[:y])
        if (distance<shortestDistance)
            shortestDistance = distance
            nextRowToVisit = comparedRow
        end ## if    
    end ##comparedRow
    currentRow = nextRowToVisit
    push!(trackPropertiesInOrder, currentRow)
    deleteat!(trackProperties, rownumber(currentRow))
    
    
    #=
    hier werden jetzt zuerst die 3 nächsten Punkte ermittel. Dann ist der kleinste Winkel zwischen
    Vektor: previous-current und Vektor: next-current entscheident
    =#
    while (!isempty(trackProperties))
        ## die 3 nächsten Punkte werden in nextPossibletrackProperties abgespeichert
        for comparedRow in eachrow(trackProperties)
            lineBetweentrackProperties = getVectorFromTo(currentRow,comparedRow)
            distance = getEuclideanNormOf(lineBetweentrackProperties[:x],lineBetweentrackProperties[:y])
            if (distance<nextPossibletrackProperties[1,:distance])
                nextPossibletrackProperties[1,1:3] = comparedRow ##hier wird die längste distance, mit einer kürzeren Distanz überschrieben
                nextPossibletrackProperties[1,:distance] = distance ##vorher stand hier statt :distance eine 4, sollte aber keinen unterschied machen
                nextPossibletrackProperties[1,:rownumberIntrackProperties] = rownumber(comparedRow)
                sort!(nextPossibletrackProperties, :distance, rev=true) ## die längste dinstanz ist in der ersten Zeile
            end ## if
        end ## for comapredRow
        ## hier wird der Winkel zwischen dem referenzvektor und den 3 möglichen Folgenden koordinaten berechnet
        #nextPossibletrackProperties[:,:angle].=0.0 das mache ich jetzt in Zeile 54

        previousRow = trackPropertiesInOrder[size(trackPropertiesInOrder,1)-1,:] ## currentRow ist der letzte Eintrag in trackPropertiesInOrder -> previousRow im vorletzten
        referenceVector = getVectorFromTo(previousRow,currentRow)
        ## aus den beiden Ortsvektoren von current und next den Vektor zwischen current und next berechnen
        for item in eachrow(nextPossibletrackProperties)
            vectorToCompare = getVectorFromTo(currentRow,item)
            item[:angle] = getAngleBetweenVectors(referenceVector,vectorToCompare)            
        end ##for i
        sort!(nextPossibletrackProperties, :angle)
        
        currentRow = trackProperties[first(nextPossibletrackProperties)[:rownumberIntrackProperties], :]
        push!(trackPropertiesInOrder, currentRow)
        deleteat!(trackProperties, rownumber(currentRow))

        nextPossibletrackProperties[:,:distance].= Inf ## durch den : wird die bereits bestehende spalte distance geändert
    end ## while
    trackProperties = trackPropertiesInOrder ## ACHTUNG: hier gehen punkte verloren, die in trackProperties bleiben, 
                                        ##da sie durch die Winkelberücksichtigung übersprungen werden 
end ## sortByDistanceConsideringAngle