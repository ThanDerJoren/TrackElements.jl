function exportCoordinatesAndTrackPropertiesInCSV(coordinates::AbstractDataFrame, trackProperties::AbstractDataFrame)
    # seitdem trackProperties variablere spalten hat, funktioniert die klare zusortierung nicht mehr
    # das zusammenfügen der beiden DataFrames muss variabler gemacht werden (dokumentation lesen, vielleicht effiziente funktionen)
    
    # coordinatesAndProperties = DataFrame()
    # coordinatesAndProperties[!, :xCoordinates] = coordinates[:,:xCoordinates]
    # coordinatesAndProperties[!, :yCoordinates] = coordinates[:,:yCoordinates]
    # coordinatesAndProperties[!, :zCoordinates] = coordinates[:,:zCoordinates]
    # coordinatesAndProperties[:,:radius] = trackProperties[:, :radius]
    # coordinatesAndProperties[!, :speedLimit] = trackProperties[:, :speedLimit]
    # CSV.write("CoordinatesAndTrackProperties.csv", coordinatesAndProperties)
end