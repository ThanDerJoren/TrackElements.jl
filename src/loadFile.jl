function readPTFile(filePath::String)
    #= Variante Skipto ist unsauber: die ersten beiden Zeilen müssen übersprunge werden, aber sind es immer 2?
        schön wäre "comit" zu verstehen. Das scheint mir ein befehl zu sein mit dem man kommentare (also Strings) überspringt
        das wäre optimal. Was gibt es noch für lösungen?
    =#
    #= Annahme: Koordinaten in PT dateien haben immer einen Index. Das ist die erste Spalte, die ich mit select überspringe
    =#
    columnNames = [:Index, :yCoordinates, :xCoordinates, :zCoordinates]
    coordinates = CSV.read(filePath, DataFrame, header = columnNames, skipto = 3 , select = [2,3,4], delim =' ',  ignorerepeated = true) ##Mit ignorerepeated werdne die vielen leerzeichen ignoriert
    return coordinates
end ##readPTFile

function loadFile(filePath::String, fileType::String)
    coordinates = DataFrame()
    if (filePath!=empty && fileType!=empty)
        if (fileType == ".PT") coordinates = readPTFile(filePath)
        elseif (fileType == ".pt") coordinates = readPTFile(filePath)
        elseif (filetype == ".csv") println("csv dateien einzulesen ist noch nicht programmiert")
        else println("der fileType muss als string mit . und dem Dateitypen angegeben werden z.B: .PT")
        end ## if cases
    else println("Es muss ein Dateipfad und der Datentyp übergeben werden")
    end ##if   
    return coordinates 
end ##loadFile