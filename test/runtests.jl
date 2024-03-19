using TrackElements
using Test


#=
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

        @testset "5000m radius, 200m node distance" begin
            trackProperties = TrackElements.loadNodes("test/data/ProVI/R5000m_Punktabstand200m.pt", "PT")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 62, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 63, trackProperties)[1,:centralRadiiAverageOf1Radii] == 5000.0
            @test filter(row -> row.ID == 64, trackProperties)[1,:centralRadiiAverageOf1Radii] == 5000.0
            @test filter(row -> row.ID == 65, trackProperties)[1,:centralRadiiAverageOf1Radii] == 5000.0
            @test filter(row -> row.ID == 66, trackProperties)[1,:centralRadiiAverageOf1Radii] == 5000.0
            @test filter(row -> row.ID == 67, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end

        @testset "10000m radius, 200m node distance" begin
            trackProperties = TrackElements.loadNodes("test/data/ProVI/R10000m_Punktabstand200m.pt", "PT")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 56, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 57, trackProperties)[1,:centralRadiiAverageOf1Radii] == 10000.0
            @test filter(row -> row.ID == 58, trackProperties)[1,:centralRadiiAverageOf1Radii] == 10000.0
            @test filter(row -> row.ID == 59, trackProperties)[1,:centralRadiiAverageOf1Radii] == 10000.0
            @test filter(row -> row.ID == 60, trackProperties)[1,:centralRadiiAverageOf1Radii] == 10000.0
            @test filter(row -> row.ID == 61, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end

        @testset "15000m radius, 200m node distance" begin
            trackProperties = TrackElements.loadNodes("test/data/ProVI/R15000m_Punktabstand200m_Fehlerhafte-Schnittpunkterkennung-ProVI.pt", "PT")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 49, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 50, trackProperties)[1,:centralRadiiAverageOf1Radii] == 15000.0
            @test filter(row -> row.ID == 51, trackProperties)[1,:centralRadiiAverageOf1Radii] == 15000.0
            @test filter(row -> row.ID == 52, trackProperties)[1,:centralRadiiAverageOf1Radii] == 15000.0
            @test filter(row -> row.ID == 53, trackProperties)[1,:centralRadiiAverageOf1Radii] == 15000.0
            @test filter(row -> row.ID == 55, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end

        @testset "20000m radius, 200m node distance" begin
            trackProperties = TrackElements.loadNodes("test/data/ProVI/R20000m_Punktabstand200m.pt", "PT")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 43, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 44, trackProperties)[1,:centralRadiiAverageOf1Radii] == 20000.0
            @test filter(row -> row.ID == 45, trackProperties)[1,:centralRadiiAverageOf1Radii] == 20000.0
            @test filter(row -> row.ID == 46, trackProperties)[1,:centralRadiiAverageOf1Radii] == 20000.0
            @test filter(row -> row.ID == 47, trackProperties)[1,:centralRadiiAverageOf1Radii] == 20000.0
            @test filter(row -> row.ID == 48, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end

        @testset "25000m radius, 200m node distance" begin
            trackProperties = TrackElements.loadNodes("test/data/ProVI/R25000m_Punktabstand200m_fehlerhafteSchnittpunkterkennungProVI.pt", "PT")
            TrackElements.sortNodeOrder!(trackProperties)
            TrackElements.calculateAverageOfDifferentCentralRadii!(trackProperties, 1, :centralRadiiAverageOf1Radii)
            @test filter(row -> row.ID == 37, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 38, trackProperties)[1,:centralRadiiAverageOf1Radii] == 25000.0
            @test filter(row -> row.ID == 39, trackProperties)[1,:centralRadiiAverageOf1Radii] == 25000.0
            @test filter(row -> row.ID == 40, trackProperties)[1,:centralRadiiAverageOf1Radii] == 25000.0
            @test filter(row -> row.ID == 41, trackProperties)[1,:centralRadiiAverageOf1Radii] == 25000.0
            @test filter(row -> row.ID == 42, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
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
