#=
STRUCTURE of the DataFrame 'trackProperties'
loadNodes returns a DataFrame, which can be used for the sorting and calculations.
It is importend that the columns of the DataFrame have alway the Symbols [:ID, :x, :y, :z], because the functions will call them by these names.
Thats why the order of the columns in the DataFrame isn't importend.
=#

#=
TODO write a comment
delets rows with missing x and y 
replace missing with 0 or 0.0 at id or z
TODO write @info for each changed value of id or z
=#
function replaceMissingValues!(trackProperties::DataFrame)
    for row in 1:size(trackProperties,1)
        if string(trackProperties[row,:x]) == "missing"
            @warn "x-value is missing around row $row with ID $(trackProperties[row, :ID]). The Node got deleted"
        elseif string(trackProperties[row,:y]) == "missing"
            @warn "y-value is missing around row $row with ID $(trackProperties[row, :ID]). The Node got deleted"
        end
    end
    dropmissing!(trackProperties, [:x,:y])
    trackProperties[:,:ID]=coalesce.(trackProperties[:,:ID], 0)
    trackProperties[:,:z]=coalesce.(trackProperties[:,:z],0.0)
end

#=
The imported file should contain columns in the same order as the order in 'columnNames'.
The first two rows of the PT file will be skipped because they contains the header. If there isn't any header the first tow nodes of the CSV file get lost.
=#
function readPTFile(filePath::String)
    columnNames = [:ID, :x, :y, :z]
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames, skipto = 3, select = [1,2,3,4], delim =' ',  ignorerepeated = true)
    #TODO insert replacemissingvalue and check
    return trackProperties
end 

#= 
The imported file should contain columns in the same order as the order in 'columnNames'.
The first row of the CSV file will be skipped because it contains the header. If there isn't any header the first node of the CSV file get lost.
=#
function readCSVFile(filePath::String)
    columnNames = [:ID, :x, :y, :z]
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames, skipto = 2, select = [1,2,3,4])
    replaceMissingValues!(trackProperties)
    print(trackProperties)
    return trackProperties
end


function loadNodes(filePath::String, fileType::String)  
    trackProperties = DataFrame()
    if (filePath!=empty && fileType!=empty)
        fileType = uppercase(fileType)
        if (fileType == "PT") trackProperties = readPTFile(filePath)
        elseif (fileType == "CSV") trackProperties = readCSVFile(filePath)
        else println("der fileType muss als string ohne '.' angegeben werden z.B: 'PT'")
        end
    else println("Es muss ein Dateipfad und der Datentyp übergeben werden")
    end 
    return trackProperties 
end