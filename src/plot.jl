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
    colors = [repeat([:black, :blue], floor(Int,size(trackProperties,1)/2)); repeat([:black], size(trackProperties,1)%2)]## das Semikolon ist wichtig
    x = trackProperties[:,:x]
    y = trackProperties[:,:y]
    
    f= Figure()
    Axis(f[1,1])
    scatter!(x,y, color = colors, markersize = 5)
    lines!(x,y, color = :grey, linewidth = 0.5)
    text!(x,y, 
        text = string.(1:size(trackProperties,1)), 
        color = colors,
        fontsize =10,
        align = (:center, :bottom))
    display(f)

end##plotWithMakie