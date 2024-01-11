function plotTrack(trackProperties::AbstractDataFrame)
    colors = [repeat([:green, :blue], floor(Int,size(trackProperties,1)/2)); repeat([:green], size(trackProperties,1)%2)]

    # for the resolution:
    outerTrackNodes = getOuterNodes(trackProperties)
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
    return f
end