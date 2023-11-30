#=
STRUCTURE trackProperties
loadNodes returns a DataFrame, which can be used for the sorting and calculations.
It is importend that the columns of the DataFrame have alway the Symbols [:ID, :x, :y, :z], because the functions will call them by these names.
Thats why the order of the columns in the DataFrame isn't importend.
=#

#=
The content of each column and the order of the columns in the PT file is determined by 'columnNames'
The first two rows of the PT file will be skipped because they contains the header. If there isn't any header the first tow nodes of the CSV file get lost.
=#
function readPTFile(filePath::String)
    columnNames = [:ID, :x, :y, :z]
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames, skipto = 3 , select = [1,2,3,4], delim =' ',  ignorerepeated = true) ##Mit ignorerepeated werdne die vielen leerzeichen ignoriert
    #print(trackProperties)
    return trackProperties
end 

#= 
The content of each column and the order of the columns in the CSV file is determined by 'columnNames'.
The first row of the CSV file will be skipped because it contains the header. If there isn't any header the first node of the CSV file get lost.
=#
function readCSVFile(filePath::String)
    columnNames = [:ID, :x, :y, :z]
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames,skipto = 2, select = [1,2,3,4])
    #print(trackProperties)
    return trackProperties
end


function loadNodes(filePath::String, fileType::String)  
    trackProperties = DataFrame()
    if (filePath!=empty && fileType!=empty)
        uppercase(fileType)
        if (fileType == "PT") trackProperties = readPTFile(filePath)
        elseif (fileType == "CSV") trackProperties = readCSVFile(filePath)
        else println("der fileType muss als string ohne '.' angegeben werden z.B: 'PT'")
        end
    else println("Es muss ein Dateipfad und der Datentyp übergeben werden")
    end 
    return trackProperties 
end