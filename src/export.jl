function createPtFileWithRadiiInHighColumn(trackProperties::AbstractDataFrame, radii:: Symbol)
    if(size(trackProperties,1)<10000000000000000) ## mehr EInträge kann pt nicht(zumindest die Nummerierung)
        open("CoordinatesAndRadiusInSSSSS.pt","w") do io ##Datei wird neu erstellt wenn noch nicht vorhanden, durch "w" kann man in die DAtei schreiben
            println(io, "EB:")
            println(io, "%PPPPPPPPPPPPPPPP YYYYYYYY.YYYYYY XXXXXXXX.XXXXXX HHHH.HHHHHH GGGGG SSSSSSSSSS QQ DDDDDDDDDD FFFFFFFFFF xx.xxx yy.yyy ddd.dddd sss.sss ttt.ttt uuu.uuu vvv.vvv www.wwww")
            for row in axes(trackProperties,1)
                xCoord = @sprintf "%.6f" round(trackProperties[row,:x], digits = 6)
                yCoord = @sprintf "%.6f" round(trackProperties[row,:y], digits = 6)
                zCoord = @sprintf "%.6f" round(trackProperties[row, :z], digits = 6)
                radius = round(trackProperties[row, radii])
                if (radius > 50000) ## 25000 ist der maximal verbaute Radius
                    radius = 100000 ## alles darüber kann als gerade angesehen werden -> sehr große radien
                end
                radius = @sprintf "%.4f" radius
                println(io, 
                    lpad(row,17," "), 
                    lpad(yCoord,15+1," "),
                    lpad(xCoord,15+1," "),
                    lpad(zCoord,11+1," "),
                    lpad("",5+1," "), ##füllt die G Spalte mit Leerzeichen
                    lpad(radius,10+1," "))## das +1 für das Leerzeichen zwischen den Einträgen
            end##for
        end##open
    end##if
end