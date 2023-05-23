#  using DataFrames, LinearAlgebra
# include("math.jl")
# # df = DataFrame(x=[607672707, 607700728, 607755395], y =[5757301.2, 5757296.1, 5757277.1], z = [0,0,0])
# # println(getRadiusOfThreePoints(df[1,:], df[2,:], df[3,:]))

# # df = DataFrame(x=[607672707, 607700728, 607755395], y =[5.757301174e6, 5.757296138e6, 5.757277146e6], z = [0,0,0])
# # println(getRadiusOfThreePoints(df[1,:], df[2,:], df[3,:]))

# # bigNumbers = DataFrame(x=[608771.777000, 608799.761000], y =[5760322.982000, 5759541.361000], z = [0,0])
# # print(bigNumbers[:,:x])

# df = DataFrame(A = [1,2,3,4], B = [5,6,7,8])
# # A =[df[1:3, :A] df[1:3, :B] fill(1, 3)]
# # B =[(df[1:3, :A]).^2 + (df[1:3, :B]).^2]## der Punkt ist wichtig
# # B = B[1]
# # pinv(A)*B
# filter(:A => A -> A == 1, df; view=true)

# using DataFrames, CSV
# df = DataFrame(A=11:14, B=15:18)
# columnNames = ["fCeee", "Deeee",]
# CSV.write("testExport.pt", df; delim = " ", missingstring = "-", header = columnNames) ## hier sieht man,d ass man pt als Dateiendung nutzen kann
# print("done")

## WICHTIG ##
## So lässt sich das Format von pt herstellen.
##PROBLEM: bei der write methode werden die " des Strings mit ausgegeben
using DataFrames, CSV
df = DataFrame(X=0.5:0.5:5, Y=0.25:0.25:2.5)
# dfForPT = DataFrame(
#     PPPP = String[],
#     XXXX = String[],
#     YYYY = String[],
# )
# for row in 1:size(df,1)
#     push!(dfForPT,(
#         lpad(row,4," "),
#         lpad(df[row,:X],4," "),   
#         lpad(df[row,:Y],4," ") ##hier haben manche Variablen bereits 4 stellen. Obwohl sie die 
#     ))
# end
# dfForPT[!,:RRRR] .= lpad("",4," ")
# CSV.write("testExport.pt", dfForPT, delim = " ",)

# open("ExportViaOpen.pt", "w") do io
#     println(io, "EB:")
#     println(io, "%PPPPP XXXXXX YYYYYY RRRRRR ZZZZZZ")
#     for row in 1:size(df,1)
#         println(io, lpad(row,4,' '), lpad(df[row,:X],4+1," "),lpad(df[row,:Y],4+1," "))
#     end
# end
# Julia program to take input from user
  
# prompt to input

function main()
    print("What's your name ? \n\n") 
    
    # Calling rdeadline() function
    name = readline()
   

end
function test(datentyp::String)
    print("DAtenpfad angeben: \n")
    testPfad = readline()

    return(testPfad)
end