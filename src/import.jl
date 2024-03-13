#=
STRUCTURE of the DataFrame 'trackProperties'
loadNodes returns a DataFrame, which can be used for the sorting and calculations.
It is importend that the columns of the DataFrame have alway the Symbols [:ID, :x, :y, :z], because the functions will call them by these names.
Thats why the order of the columns in the DataFrame isn't importend.
=#

#=
Because the calculations aren't working without x and y values, the Nodes get deleted, when these values are missing.
The IDs and z coordinates aren't so importend. If they are missing, they get a zero.
With this function it is possible to import Data without a z column
=#
function replaceMissingValues!(trackProperties::DataFrame)
    missingID = false
    missingZ = false
    for row in 1:size(trackProperties,1)
        if string(trackProperties[row,:x]) == "missing"
            @warn "x-value is missing around row $row with ID $(trackProperties[row, :ID]). The Node got deleted"
        elseif string(trackProperties[row,:y]) == "missing"
            @warn "y-value is missing around row $row with ID $(trackProperties[row, :ID]). The Node got deleted"
        end
        if string(trackProperties[row,:ID]) == "missing"
            missingID = true
        end
        if string(trackProperties[row, :z]) == "missing"
            missingZ = true
        end
    end
    dropmissing!(trackProperties, [:x,:y])
    trackProperties[:,:ID]=coalesce.(trackProperties[:,:ID], 0)
    if missingID == true
        @info "There were missing IDs. They were set to 0"
    end
    trackProperties[:,:z]=coalesce.(trackProperties[:,:z],0.0)
    if missingZ == true
        @info "There were missing Z values. They were set to 0.0"
    end
end

#=
The imported file should contain columns in the same order as the order in 'columnNames'.
The first two rows of the PT file will be skipped because they contains the header. If there isn't any header the first tow nodes of the CSV file get lost.
=#
function readPTFile(filePath::String)
    columnNames = [:ID, :x, :y, :z]
    columnTypes = [Int64, Float64, Float64, Float64]
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames, skipto = 3, select = [1,2,3,4], delim =' ', ignorerepeated = true, types = columnTypes)
    #TODO insert replacemissingvalue and check
    return trackProperties
end 

#= 
The imported file should contain columns in the same order as the order in 'columnNames'.
The first row of the CSV file will be skipped because it contains the header. If there isn't any header the first node of the CSV file get lost.
=#
function readCSVFile(filePath::String)
    columnNames = [:ID, :x, :y, :z]
    columnTypes = [Int64, Float64, Float64, Float64]
    trackProperties = CSV.read(filePath, DataFrame, header = columnNames, skipto = 2, select = [1,2,3,4], types = columnTypes)
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