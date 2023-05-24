function readPTFile(filePath::String)
    #= Variante Skipto ist unsauber: die ersten beiden Zeilen müssen übersprunge werden, aber sind es immer 2?
        schön wäre "comit" zu verstehen. Das scheint mir ein befehl zu sein mit dem man kommentare (also Strings) überspringt
        das wäre optimal. Was gibt es noch für lösungen?
    =#
    #= 
        Annahme: Koordinaten in PT dateien haben immer einen Index. Das ist die erste Spalte, die ich mit select überspringe
        Wichtig: die Spalten müssen immer gleich heißen, sonst funktionieren die math.jl funktionen nicht
    =#
    columnNames = [:Index, :x, :y, :z] ##konvertiert Geodätenkoordinatensystem in "normales Koordinatensystem"
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames, skipto = 3 , select = [2,3,4], delim =' ',  ignorerepeated = true) ##Mit ignorerepeated werdne die vielen leerzeichen ignoriert
    #print(trackProperties)
    return trackProperties
end ##readPTFile

function loadCoordinates(filePath::String, fileType::String)
    #filePath = communicationViaTerminal("Bitte den Dateipfad einfügen")
    
    #Warum Funktioniert das nicht?

    # filePath = raw"test/data/StreckenachseFreihandErfasst(ausProVI).PT" ##raw macht aus \ die benötigten /

    ##testDocument = raw"C:\Users\Julek\Nextcloud\A Verkehrsingenieurwesen\ifev\ProgrammRadienBestimmen\Streckenachse freihand erfasst (aus ProVI).PT" 
    
    trackProperties = DataFrame()
    if (filePath!=empty && fileType!=empty)
        if (fileType == ".PT") trackProperties = readPTFile(filePath)
        elseif (fileType == ".pt") trackProperties = readPTFile(filePath)
        elseif (filetype == ".csv") println("csv dateien einzulesen ist noch nicht programmiert")
        else println("der fileType muss als string mit . und dem Dateitypen angegeben werden z.B: .PT")
        end ## if cases
    else println("Es muss ein Dateipfad und der Datentyp übergeben werden")
    end ##if   
    return trackProperties 
end ##loadCoordinates