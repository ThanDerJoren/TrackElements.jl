function plot2D(coordinates::DataFrame)
    @df coordinates display(scatter(:xCoordinates, :yCoordinates, markercolor = :grey, linecolor = :grey))
    @df coordinates display(plot!(:xCoordinates, :yCoordinates, linecolor = :grey))
    #display(annotate!([coordinates[1,:xCoordinates], coordinates[size(coordinates,1),:xCoordinates]], [coordinates[1,:yCoordinates], coordinates[size(coordinates,1),:yCoordinates]], [1:size(coordinates,1)]))
    for item in eachrow(coordinates)
        display(annotate!(item[:xCoordinates], item[:yCoordinates], (rownumber(item),7, :red, :right)))
    end ## for loop
end ##plotXYCoordinates