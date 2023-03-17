using DataFrames
trackProperties = DataFrame(radius = fill(0.0, 8), speedLimit = fill(0.0, 8))
trackProperties[1,:radius] = 1