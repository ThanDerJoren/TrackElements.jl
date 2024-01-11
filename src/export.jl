#=
The Data Type DateTime uses special characters, which aren't allowed in a fileName.
This function changes these special character to usable characters
=#
function dateTimeForFilePath(toAdjust::DateTime)
    return "D$(Date(toAdjust))T$(hour(toAdjust))_$(minute(toAdjust))"
end

function exportDataFrameToCSV(data::DataFrame,FilePath::String) 
    CSV.write(FilePath, data)
end

#=
The PT filetype is used by ProVI. 
The first row contains always 'EB:' for 'Eisenbahn'
The second row contains always the long sequence of characters
After that every row contains the information about one node.
Spacecaracters fill the gap to the next entry, which has to fit under the right caracters of the second row.
TODO which column is the best for the radius?
TODO in which column is the radius written right now?
=#
function createPtFileWithRadii(trackProperties::AbstractDataFrame, radii:: Symbol)
    if(size(trackProperties,1)<10000000000000000) ## maximum entries, given by the length of p
        open("CoordinatesAndRadiusInSSSSS.pt","w") do io ## new file, because of 'w' one can fill the file
            println(io, "EB:")
            println(io, "%PPPPPPPPPPPPPPPP YYYYYYYY.YYYYYY XXXXXXXX.XXXXXX HHHH.HHHHHH GGGGG SSSSSSSSSS QQ DDDDDDDDDD FFFFFFFFFF xx.xxx yy.yyy ddd.dddd sss.sss ttt.ttt uuu.uuu vvv.vvv www.wwww")
            for row in axes(trackProperties,1)
                xCoord = @sprintf "%.6f" round(trackProperties[row,:y], digits = 6)
                yCoord = @sprintf "%.6f" round(trackProperties[row,:x], digits = 6)
                zCoord = @sprintf "%.6f" round(trackProperties[row, :z], digits = 6)
                radius = round(trackProperties[row, radii])
                if (radius == Inf) 
                    radius = 100000
                end
                radius = @sprintf "%.4f" radius
                println(io, 
                    lpad(row,17," "), 
                    lpad(yCoord,15+1," "), # the +1 is needed for the space caracter between the 'columns'
                    lpad(xCoord,15+1," "),
                    lpad(zCoord,11+1," "),
                    lpad("",5+1," "),
                    lpad(radius,10+1," "))
            end
        end
    end
end



function createPtFileForOSMNodes(nodesWithUTMCoordinates::AbstractDataFrame, filePath::String)
    if(size(nodesWithUTMCoordinates,1)<10000000000000000) 
        open(filePath,"w") do io
            println(io, "EB:")
            println(io, "%PPPPPPPPPPPPPPPP YYYYYYYY.YYYYYY XXXXXXXX.XXXXXX HHHH.HHHHHH GGGGG SSSSSSSSSS QQ DDDDDDDDDD FFFFFFFFFF xx.xxx yy.yyy ddd.dddd sss.sss ttt.ttt uuu.uuu vvv.vvv www.wwww")
            for row in axes(nodesWithUTMCoordinates,1)
                xCoord = @sprintf "%.6f" round(nodesWithUTMCoordinates[row,:y], digits = 6)
                yCoord = @sprintf "%.6f" round(nodesWithUTMCoordinates[row,:x], digits = 6)
                zCoord = @sprintf "%.6f" round(nodesWithUTMCoordinates[row, :z], digits = 6)
                nodeID = nodesWithUTMCoordinates[row, :ID]
                println(io, 
                    lpad(nodeID,17," "), 
                    lpad(yCoord,15+1," "),
                    lpad(xCoord,15+1," "),
                    lpad(zCoord,11+1," "))
            end
        end
    end
end
