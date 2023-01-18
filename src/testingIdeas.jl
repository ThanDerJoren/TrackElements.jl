df = DataFrame(xCoordinates= 1:2, yCoordinates= 1:2, zCoordinates= 1:2 )
vectorA = df[1,:]
vectorB = df[2,:]

getVectorFromTo(vectorA, vectorB)

using DataFrames
df = DataFrame(A=1:4)
println(df)
oneRow = df[3,:]
println(oneRow)
deleteat!(df,2)
println(oneRow)

