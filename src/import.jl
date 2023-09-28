#=
REQUIREMENTS FOR THE IMPORT
Every file that should be imported is supposed to contain per node at least a nodeID, x and y coordinate in the first three columns.
The z Coordinate is optional. For completeness it is also read but right know it is not used in the calculations. 
TODO where do I use the z Coordinate?
TODO what happens if a file contains only 3 columns (error because select expect 4 columns?)
There has to be only one node per row.
The x and y coordinates have to be indicated in the UTM coordinate system. 
Right now all nodes have to be located in one UTM zone. 
TODO calculate the distance between of nodes in different UTM zones
=#

#=
STRUCTURE trackProperties
loadNodes returns a DataFrame, which can be used for the sorting and calculations.
It is importend that the columns of the DataFrame have alway the Symbols [:ID, :x, :y, :z], because the functions will call them by these names.
Thats why the order of the columns isn't importend.
=#

#=
The content of each column and the order of the columns in the PT file is determined by 'columnNames'
The first two rows of the PT file will be skipped because they contains the header. If there isn't any header the first tow nodes of the CSV file get lost.
=#
function readPTFile(filePath::String)
    columnNames = [:ID, :x, :y, :z] ## Reihenfolge konvertiert Geodätenkoordinatensystem in "normales Koordinatensystem"
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames, skipto = 3 , select = [1,2,3,4], delim =' ',  ignorerepeated = true) ##Mit ignorerepeated werdne die vielen leerzeichen ignoriert
    print(trackProperties)
    return trackProperties
end ##readPTFile

#= 
The content of each column and the order of the columns in the CSV file is determined by 'columnNames'.
The first row of the CSV file will be skipped because it contains the header. If there isn't any header the first node of the CSV file get lost.
=#
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