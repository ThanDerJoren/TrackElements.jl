# using Geodesy
# origin_lla = LLA(52.2513849, 10.5383673)
# utm_zone = UTMZ(origin_lla, wgs84)

using DataFrames
df1 = DataFrame(a = [1,2], b = [3,4])
df2 = DataFrame()
push!(df2, df1[1,:])
#println(df1)
#df2=copy(df1)
#print(df2[1,:a])
# df2[1,:a] = 5
# println(df1)
println(df2)