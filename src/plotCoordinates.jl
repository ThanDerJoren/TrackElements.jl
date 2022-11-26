function plot2D(coordinates::DataFrame)
    @df coordinates display(scatter(:xCoordinates, :yCoordinates))
    @df coordinates display(plot!(:xCoordinates, :yCoordinates))
end ##plotXYCoordinates