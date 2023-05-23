function exportCoordinatesAndTrackPropertiesInCSV(coordinates::AbstractDataFrame, trackProperties::AbstractDataFrame)
    # seitdem trackProperties variablere spalten hat, funktioniert die klare zusortierung nicht mehr
    # das zusammenfügen der beiden DataFrames muss variabler gemacht werden (dokumentation lesen, vielleicht effiziente funktionen)
    
    # coordinatesAndProperties = DataFrame()
    # coordinatesAndProperties[!, :x] = coordinates[:,:x]
    # coordinatesAndProperties[!, :y] = coordinates[:,:y]
    # coordinatesAndProperties[!, :z] = coordinates[:,:z]
    # coordinatesAndProperties[:,:radius] = trackProperties[:, :radius]
    # coordinatesAndProperties[!, :speedLimit] = trackProperties[:, :speedLimit]
    # CSV.write("CoordinatesAndTrackProperties.csv", coordinatesAndProperties)
end
function createPtFileWithRadiiInHighColumn(coordinates::AbstractDataFrame, radii:: Vector)
    if(size(coordinates,1)<10000000000000000) ## mehr EInträge kann pt nicht(zumindest die Nummerierung)
        open("CoordinatesAndRadiusInSSSSS.pt","w") do io ##Datei wird neu erstellt wenn noch nicht vorhanden, durch "w" kann man in die DAtei schreiben
            println(io, "EB:")
            println(io, "%PPPPPPPPPPPPPPPP YYYYYYYY.YYYYYY XXXXXXXX.XXXXXX HHHH.HHHHHH GGGGG SSSSSSSSSS QQ DDDDDDDDDD FFFFFFFFFF xx.xxx yy.yyy ddd.dddd sss.sss ttt.ttt uuu.uuu vvv.vvv www.wwww")## ACHTUNG, orgiginal wäre HHHH.HHHHHH
            for row in 1:size(coordinates,1)
                xCoordinate = @sprintf "%.6f" round(coordinates[row,:x], digits = 6)
                yCoordinate = @sprintf "%.6f" round(coordinates[row,:y], digits = 6)
                zCoordinate = @sprintf "%.6f" round(coordinates[row, :z], digits = 6)
                radius = round(radii[row]) ## HHHHHH.HHHH leichte änderung zu original pt datei (6 stellen hinter dem komma und nur 4 davor)
                if (radius > 50000) ## 25000 ist der maximal verbaute Radius
                    radius = 100000 ## alles darüber kann als gerade angesehen werden -> sehr große radien
                end
                radius = @sprintf "%.4f" radius
                println(io, 
                    lpad(row,17," "), 
                    lpad(yCoordinate,15+1," "),
                    lpad(xCoordinate,15+1," "),
                    lpad(zCoordinate,11+1," "),
                    lpad("",5+1," "), ##füllt die G Spalte mit Leerzeichen
                    lpad(radius,10+1," "))## das +1 für das Leerzeichen zwischen den Einträgen
            end##for
        end##open
    end##if
end