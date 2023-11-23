using TrackElements
using Test

#include("../src/TrackElements.jl")
# TODO aktuelles PRoblem: die DAtei unter TRackElements/test/data wird nicht gefunden. In der IDE kann man aber mit ctrl*klick dem Pfad genau an die richtige STelle folgen. Der Dateipfad stimmt also. Aber Julia kann nicht drauf zugreifen
print(isfile("TrackElements.jl/test/data/R200m_Punktabstand100m.pt"))

@testset "TrackElements.jl" begin
    @testset "nodes on track axis" begin
        @testset "200m radius, 100m node distance" begin
            
            trackProperties = TrackElements.loadNodes("data/R200m_Punktabstand100m.pt", "PT")
            sortNodeOrder!(trackProperties)
            calculateAverageOfDifferentCentralRadii!(trackProperties, 1, "centralRadiiAverageOf1Radii")
            @test filter(row -> row.ID == 1, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
            @test filter(row -> row.ID == 2, trackProperties)[1,:centralRadiiAverageOf1Radii] == 200.0
            @test filter(row -> row.ID == 3, trackProperties)[1,:centralRadiiAverageOf1Radii] == 200.0
            @test filter(row -> row.ID == 4, trackProperties)[1,:centralRadiiAverageOf1Radii] == 200.0
            @test filter(row -> row.ID == 5, trackProperties)[1,:centralRadiiAverageOf1Radii] == 200.0
            @test filter(row -> row.ID == 6, trackProperties)[1,:centralRadiiAverageOf1Radii] == 0.0
        end
    end
end
