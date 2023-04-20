# function plot2D(coordinates::DataFrame)
#     @df coordinates display(scatter(:xCoordinates, :yCoordinates, markercolor = :grey, linecolor = :grey))
#     @df coordinates display(plot!(:xCoordinates, :yCoordinates, linecolor = :grey))
#     #display(annotate!([coordinates[1,:xCoordinates], coordinates[size(coordinates,1),:xCoordinates]], [coordinates[1,:yCoordinates], coordinates[size(coordinates,1),:yCoordinates]], [1:size(coordinates,1)]))
#     for item in eachrow(coordinates)
#         display(annotate!(item[:xCoordinates], item[:yCoordinates], (rownumber(item),7, :red, :right)))
#     end ## for loop
# end ##plotXYCoordinates

function plotTrackWithOuterCoordinates(coordinates::AbstractDataFrame, outerCoordinates::AbstractDataFrame)
    x = coordinates[:,:xCoordinates]
    y = coordinates[:,:yCoordinates]
    xOC = outerCoordinates[:, :xCoordinates]
    yOC = outerCoordinates[:, :yCoordinates]

    f= Figure()
    Axis(f[1,1])
    scatter!(x,y, color = :grey, markersize = 10)
    #lines!(x,y, color = :grey, linewidth = 1)
    scatter!(xOC,yOC, color = :blue, markersize = 11)
    text!(xOC,yOC, 
        text = string.(1:size(outerCoordinates,1)), 
        color = :blue,
        fontsize =20,
        align = (:center, :bottom))
    display(f)

end##plotWithMakie

function plotTrack(coordinates::AbstractDataFrame)
    colors = [repeat([:black, :blue], floor(Int,size(coordinates,1)/2)); repeat([:black], size(coordinates,1)%2)]## das Semikolon ist wichtig
    x = coordinates[:,:xCoordinates]
    y = coordinates[:,:yCoordinates]
    
    f= Figure()
    Axis(f[1,1])
    scatter!(x,y, color = colors, markersize = 5)
    lines!(x,y, color = :grey, linewidth = 0.5)
    text!(x,y, 
        text = string.(1:size(coordinates,1)), 
        color = colors,
        fontsize =10,
        align = (:center, :bottom))
    display(f)

end##plotWithMakie