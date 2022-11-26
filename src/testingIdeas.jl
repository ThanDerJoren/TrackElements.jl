using CSV
using DataFrames
columnNames = ["Index", "yCoordinates", "xCoordinates", "zCoordinates"]
CSV.read("C:/Users/Julek/Nextcloud/A Verkehrsingenieurwesen/ifev/ProgrammRadienBestimmen/Streckenachse freihand erfasst (aus ProVI).PT", DataFrame, header = columnNames, skipto = 3 , select = [2,3,4], delim =' ',  ignorerepeated = true)

##C:/Users/Julek/Nextcloud/A Verkehrsingenieurwesen/ifev/ProgrammRadienBestimmen/Streckenachse freihand erfasst (aus ProVI).PT