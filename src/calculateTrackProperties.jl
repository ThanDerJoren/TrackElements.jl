function calculateRadiiFromTrack!(coordinates::AbstractDataFrame, trackProperties::AbstractDataFrame)
    for i in 1:size(coordinates, 1)-2
        trackProperties[i,:radius] = getRadiusOfThreePoints(coordinates[i,:], coordinates[i+1,:], coordinates[i+2,:])
    end ##for
end ##calculateRadiiFromTrack