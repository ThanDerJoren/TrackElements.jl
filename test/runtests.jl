using TrackElements
using Test


#=
If the position of the nodes is exactly on a circle with a known radius, the the math functions should calculate this radius.
The following test test this case. 
I constructed some of these nodes in ProVI, but on bigger circles the nodes were not exactly on the circle anymore. So I constructed the bigger circles mathematicaly and not with an CAD program.
=#

@testset "TrackElements.jl" begin
    @testset "nodes on track axis. Nodes generated with ProVI" begin
        @testset "200m radius, 100m node distance" begin
            trackProperties = TrackElements.loadNodes("test/data/ProVI/R200m_Punktabstand100m.PT", "PT")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 1, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 2, trackProperties)[1,:centralRadiiAverageOf1Radii] == 200.0
            @test filter(row -> row.ID == 3, trackProperties)[1,:centralRadiiAverageOf1Radii] == 200.0
            @test filter(row -> row.ID == 4, trackProperties)[1,:centralRadiiAverageOf1Radii] == 200.0
            @test filter(row -> row.ID == 5, trackProperties)[1,:centralRadiiAverageOf1Radii] == 200.0
            @test filter(row -> row.ID == 6, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end

        @testset "1000m radius, 100m node distance" begin
            trackProperties = TrackElements.loadNodes("test/data/ProVI/R1000m_Punktabstand100m.pt", "PT")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 25, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 26, trackProperties)[1,:centralRadiiAverageOf1Radii] == 1000.0
            @test filter(row -> row.ID == 27, trackProperties)[1,:centralRadiiAverageOf1Radii] == 1000.0
            @test filter(row -> row.ID == 28, trackProperties)[1,:centralRadiiAverageOf1Radii] == 1000.0
            @test filter(row -> row.ID == 29, trackProperties)[1,:centralRadiiAverageOf1Radii] == 1000.0
            @test filter(row -> row.ID == 30, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end

        @testset "1000m radius, 200m node distance" begin
            trackProperties = TrackElements.loadNodes("test/data/ProVI/R1000m_Punktabstand200m.pt", "PT")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 31, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 32, trackProperties)[1,:centralRadiiAverageOf1Radii] == 1000.0
            @test filter(row -> row.ID == 33, trackProperties)[1,:centralRadiiAverageOf1Radii] == 1000.0
            @test filter(row -> row.ID == 34, trackProperties)[1,:centralRadiiAverageOf1Radii] == 1000.0
            @test filter(row -> row.ID == 35, trackProperties)[1,:centralRadiiAverageOf1Radii] == 1000.0
            @test filter(row -> row.ID == 36, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end
    end

    @testset "nodes on track axis. Nodes generated mathematicaly" begin
        @testset "25000m radius, 200m node distance, 1000m track length" begin
            trackProperties = TrackElements.loadNodes("test/data/script-coordinates_on_Circle/radius-25000m_coordinateDistance-200m_trackLength-1000m.csv", "csv")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 0, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 1, trackProperties)[1,:centralRadiiAverageOf1Radii] == 25000.0
            @test filter(row -> row.ID == 2, trackProperties)[1,:centralRadiiAverageOf1Radii] == 25000.0
            @test filter(row -> row.ID == 3, trackProperties)[1,:centralRadiiAverageOf1Radii] == 25000.0
            @test filter(row -> row.ID == 4, trackProperties)[1,:centralRadiiAverageOf1Radii] == 25000.0
            @test filter(row -> row.ID == 5, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end
        @testset "20000m radius, 200m node distance, 1000m track length" begin
            trackProperties = TrackElements.loadNodes("test/data/script-coordinates_on_Circle/radius-20000m_coordinateDistance-200m_trackLength-1000m.csv", "csv")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 0, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 1, trackProperties)[1,:centralRadiiAverageOf1Radii] == 20000.0
            @test filter(row -> row.ID == 2, trackProperties)[1,:centralRadiiAverageOf1Radii] == 20000.0
            @test filter(row -> row.ID == 3, trackProperties)[1,:centralRadiiAverageOf1Radii] == 20000.0
            @test filter(row -> row.ID == 4, trackProperties)[1,:centralRadiiAverageOf1Radii] == 20000.0
            @test filter(row -> row.ID == 5, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end
        @testset "15000m radius, 200m node distance, 1000m track length" begin
            trackProperties = TrackElements.loadNodes("test/data/script-coordinates_on_Circle/radius-15000m_coordinateDistance-200m_trackLength-1000m.csv", "csv")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 0, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 1, trackProperties)[1,:centralRadiiAverageOf1Radii] == 15000.0
            @test filter(row -> row.ID == 2, trackProperties)[1,:centralRadiiAverageOf1Radii] == 15000.0
            @test filter(row -> row.ID == 3, trackProperties)[1,:centralRadiiAverageOf1Radii] == 15000.0
            @test filter(row -> row.ID == 4, trackProperties)[1,:centralRadiiAverageOf1Radii] == 15000.0
            @test filter(row -> row.ID == 5, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end
    end
end
