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
                distance = abs(sqrt((currentRow[:xCoordinates]-comparedRow[:xCoordinates])^2+(currentRow[:yCoordinates]-comparedRow[:yCoordinates])^2))
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
    print(coordinates)
    sort!(coordinates, :sortIndex)
    print("ab hier sortiert")
    print(coordinates)
end ##sortByDistance