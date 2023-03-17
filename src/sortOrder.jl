#include("math.jl")
function sortByDistance!(coordinates::AbstractDataFrame, start::Integer) ## start soll 1 sein wenn nichts übergeben wird
    coordinates[!,:sortIndex] .= 0 ##kann man auch leere Spalten einfügen?
    coordinates[!,:isVisited] .= false ## mit .= werden alle Zeilen mit dem gleichen wert befüllt?
    currentRow = DataFrame() ##kann man definieren, dass es einfach nur ein DataFrameRow ist?
    nextRowToVisit = DataFrame()
    shortestDistance = Inf 
    currentRow = coordinates[start, :] ## hier entsteht ein DataFrameRow
    currentRow[:isVisited] = true ##hier wird der Startpunkt konfiguriert
    currentRow[:sortIndex] = 1  ##hier wird der Startpunkt konfiguriert
    for i in 2:size(coordinates,1) #mit 2 Anfange: 1. sortIndex stimmt sofort 2. Der Letzte Punkt hat keine "nextRowToVisit", darf den Prozess also nicht mehr durchlaufen
        for comparedRow in eachrow(coordinates) ## die Eigene Zeile muss ausgeschlossen werden!!
            if(!comparedRow[:isVisited]) ## bereits besuchte Koordinaten müssen nicht mehr verglichen werden
                distance = getEuclideanNormOf(currentRow[:xCoordinates]-comparedRow[:xCoordinates],currentRow[:yCoordinates]-comparedRow[:yCoordinates])
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
    sort!(coordinates, :sortIndex)
    print(coordinates)
    select!(coordinates, Not(:isVisited))
    select!(coordinates, Not(:sortIndex)) ##wie schaffe ich das in einer Zeile?
    print(coordinates)
end ##sortByDistance


function sortByDistanceConsideringAngle!(coordinates::AbstractDataFrame, start::Integer)
    #= FRAGE
    Es kann passieren, dass ein Punkt (oder zwei) übersprungen werden, wenn der dahinter liegende Punkt
    einen Flacheren Winkel hat. ist das Problematisch?
    =#
    coordinatesInOrder = DataFrame()
    currentRow = DataFrame()
    nextRowToVisit = DataFrame()
    shortestDistance= Inf
    nextPossibleCoordinates = DataFrame()
    
    ##Vorbereitung: befüllen und neue Spalte hiunzufügen, um mit nextPossibleCoordinates arbeiten zu können
    for i in 1:3
        push!(nextPossibleCoordinates, coordinates[1,:])
    end##for i
    nextPossibleCoordinates[!,:distance].= Inf
    nextPossibleCoordinates[!,:angle].=0.0
    nextPossibleCoordinates[!,:rownumberInCoordinates].=0

    currentRow = coordinates[start, :]
    push!(coordinatesInOrder, currentRow)
    deleteat!(coordinates, rownumber(currentRow))
    ## der erste Folgepunkt muss ohne Winkel ermittelt werden, da es noch keine Referenz gibt
    for comparedRow in eachrow(coordinates)
        lineBetweenCoordinates = getVectorFromTo(currentRow,comparedRow)
        distance = getEuclideanNormOf(lineBetweenCoordinates[:xCoordinates],lineBetweenCoordinates[:yCoordinates])
        if (distance<shortestDistance)
            shortestDistance = distance
            nextRowToVisit = comparedRow
        end ## if    
    end ##comparedRow
    currentRow = nextRowToVisit
    push!(coordinatesInOrder, currentRow)
    deleteat!(coordinates, rownumber(currentRow))
    
    
    #=
    hier werden jetzt zuerst die 3 nächsten Punkte ermittel. Dann ist der kleinste Winkel zwischen
    Vektor: previous-current und Vektor: next-current entscheident
    =#
    while (!isempty(coordinates))
        ## die 3 nächsten Punkte werden in nextPossibleCoordinates abgespeichert
        for comparedRow in eachrow(coordinates)
            lineBetweenCoordinates = getVectorFromTo(currentRow,comparedRow)
            distance = getEuclideanNormOf(lineBetweenCoordinates[:xCoordinates],lineBetweenCoordinates[:yCoordinates])
            if (distance<nextPossibleCoordinates[1,:distance])
                nextPossibleCoordinates[1,1:3] = comparedRow ##hier wird die längste distance, mit einer kürzeren Distanz überschrieben
                nextPossibleCoordinates[1,:distance] = distance ##vorher stand hier statt :distance eine 4, sollte aber keinen unterschied machen
                nextPossibleCoordinates[1,:rownumberInCoordinates] = rownumber(comparedRow)
                sort!(nextPossibleCoordinates, :distance, rev=true) ## die längste dinstanz ist in der ersten Zeile
            end ## if
        end ## for comapredRow
        ## hier wird der Winkel zwischen dem referenzvektor und den 3 möglichen Folgenden koordinaten berechnet
        #nextPossibleCoordinates[:,:angle].=0.0 das mache ich jetzt in Zeile 54

        previousRow = coordinatesInOrder[size(coordinatesInOrder,1)-1,:] ## currentRow ist der letzte Eintrag in coordinatesInOrder -> previousRow im vorletzten
        referenceVector = getVectorFromTo(previousRow,currentRow)
        ## aus den beiden Ortsvektoren von current und next den Vektor zwischen current und next berechnen
        for item in eachrow(nextPossibleCoordinates)
            vectorToCompare = getVectorFromTo(currentRow,item)
            item[:angle] = getAngleBetweenVectors(referenceVector,vectorToCompare)            
        end ##for i
        sort!(nextPossibleCoordinates, :angle)
        
        currentRow = coordinates[first(nextPossibleCoordinates)[:rownumberInCoordinates], :]
        push!(coordinatesInOrder, currentRow)
        deleteat!(coordinates, rownumber(currentRow))

        nextPossibleCoordinates[:,:distance].= Inf ## durch den : wird die bereits bestehende spalte distance geändert
    end ## while
    coordinates = coordinatesInOrder ## ACHTUNG: hier gehen punkte verloren, die in coordinates bleiben, 
                                        ##da sie durch die Winkelberücksichtigung übersprungen werden 
end ## sortByDistanceConsideringAngle