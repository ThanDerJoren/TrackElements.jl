 using DataFrames, LinearAlgebra
include("math.jl")
# df = DataFrame(xCoordinates=[607672707, 607700728, 607755395], yCoordinates =[5757301.2, 5757296.1, 5757277.1], zCoordinates = [0,0,0])
# println(getRadiusOfThreePoints(df[1,:], df[2,:], df[3,:]))

# df = DataFrame(xCoordinates=[607672707, 607700728, 607755395], yCoordinates =[5.757301174e6, 5.757296138e6, 5.757277146e6], zCoordinates = [0,0,0])
# println(getRadiusOfThreePoints(df[1,:], df[2,:], df[3,:]))

# bigNumbers = DataFrame(xCoordinates=[608771.777000, 608799.761000], yCoordinates =[5760322.982000, 5759541.361000], zCoordinates = [0,0])
# print(bigNumbers[:,:xCoordinates])

df = DataFrame(A = [1,2,3,4], B = [5,6,7,8])
A =[df[1:3, :A] df[1:3, :B] fill(1, 3)]
B =[(df[1:3, :A]).^2 + (df[1:3, :B]).^2]## der Punkt ist wichtig
B = B[1]
pinv(A)*B

