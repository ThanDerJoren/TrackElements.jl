# using Geodesy
# origin_lla = LLA(52.2513849, 10.5383673)
# utm_zone = UTMZ(origin_lla, wgs84)

using DataFrames
df1 = DataFrame(a = [1,2], b = [3,4])
print(typeof(df1[in(2).(df1.a), :b]))
print(first(filter(row -> row.a ==2, df1)[!,:b]))
print(df1[1,2])
filter(row -> row.a ==2, df1)[1,:b]
