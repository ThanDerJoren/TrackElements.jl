
# function plot2D(trackProperties::DataFrame)
#     @df trackProperties display(scatter(:x, :y, markercolor = :grey, linecolor = :grey))
#     @df trackProperties display(plot!(:x, :y, linecolor = :grey))
#     #display(annotate!([trackProperties[1,:x], trackProperties[size(trackProperties,1),:x]], [trackProperties[1,:y], trackProperties[size(trackProperties,1),:y]], [1:size(trackProperties,1)]))
#     for item in eachrow(trackProperties)
#         display(annotate!(item[:x], item[:y], (rownumber(item),7, :red, :right)))
#     end ## for loop
# end ##plotXy

function plotTrackWithOutertrackProperties(trackProperties::AbstractDataFrame, outertrackProperties::AbstractDataFrame)
    x = trackProperties[:,:x]
    y = trackProperties[:,:y]
    xOC = outertrackProperties[:, :x]
    yOC = outertrackProperties[:, :y]


    f= Figure()
    Axis(f[1,1])
    scatter!(x,y, color = :grey, markersize = 10)
    #lines!(x,y, color = :grey, linewidth = 1)
    scatter!(xOC,yOC, color = :blue, markersize = 11)
    text!(xOC,yOC, 
        text = string.(1:size(outertrackProperties,1)), 
        color = :blue,
        fontsize =20,
        align = (:center, :bottom))
    display(f)

end##plotWithMakie

function plotTrack(trackProperties::AbstractDataFrame)
    colors = [repeat([:green, :blue], floor(Int,size(trackProperties,1)/2)); repeat([:green], size(trackProperties,1)%2)]## das Semikolon ist wichtig

    outerTrackNodes = getOutertrackProperties(trackProperties)
    width = abs(outerTrackNodes[1, :x]- outerTrackNodes[2, :x])
    height = abs(outerTrackNodes[3, :y]-outerTrackNodes[4, :y])
    
    x = trackProperties[:,:x]
    y = trackProperties[:,:y]

    f= Figure(resolution = (width, height))
    Axis(f[1,1])
    lines!(x,y, color = :grey, linewidth = 10)
    scatter!(x,y, color = colors, markersize = 15)
    text!(x,y, 
        text = string.(1:size(trackProperties,1)), 
        color = :black,
        fontsize =8,
        align = (:center, :bottom))
    display(f)
    #save("TrackPlot.svg", f)
    return f
end##plotWithMakie