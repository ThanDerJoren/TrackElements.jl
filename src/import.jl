function readPTFile(filePath::String)
    #= Variante Skipto ist unsauber: die ersten beiden Zeilen müssen übersprunge werden, aber sind es immer 2?
        schön wäre "comit" zu verstehen. Das scheint mir ein befehl zu sein mit dem man kommentare (also Strings) überspringt
        das wäre optimal. Was gibt es noch für lösungen?
    =#
    #= 
        Annahme: Koordinaten in PT dateien haben immer einen Index. Das ist die erste Spalte, die ich mit select überspringe
        Wichtig: die Spalten müssen immer gleich heißen, sonst funktionieren die math.jl funktionen nicht
    =#
    columnNames = [:ID, :x, :y, :z] ## Reihenfolge konvertiert Geodätenkoordinatensystem in "normales Koordinatensystem"
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames, skipto = 3 , select = [2,3,4], delim =' ',  ignorerepeated = true) ##Mit ignorerepeated werdne die vielen leerzeichen ignoriert
    print(trackProperties)
    return trackProperties
end ##readPTFile

function readCSVFile(filePath::String)
    columnNames = [:ID, :x, :y, :z]
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames,skipto = 2, select = [1,2,3,4])
    #print(trackProperties)
    return trackProperties
end##readCSVFile

function loadNodes(filePath::String, fileType::String)
   
    trackProperties = DataFrame()
    if (filePath!=empty && fileType!=empty)
        uppercase(fileType)
        if (fileType == "PT") trackProperties = readPTFile(filePath)
        elseif (fileType == "CSV") trackProperties = readCSVFile(filePath)
        else println("der fileType muss als string ohne '.' angegeben werden z.B: 'PT'")
        end ## if cases
    else println("Es muss ein Dateipfad und der Datentyp übergeben werden")
    end ##if   
    return trackProperties 
end ##loadCoordinates