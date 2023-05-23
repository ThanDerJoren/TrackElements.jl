function calculateRightsideRadiiFromTrack!(coordinates::AbstractDataFrame, trackProperties::AbstractDataFrame)
    rightsideRadii = fill(0.0, size(coordinates,1)) ## es muss sichergestellt werden, dass alle Arrays, die trackProperties hinzugefügt werden sollen, die gleiche Länge haben
    for i in 1:size(coordinates, 1)-2
        rightsideRadii[i] = getRadiusOfThreePoints(coordinates[i,:], coordinates[i+1,:], coordinates[i+2,:])
    end ##for
    trackProperties[!, :rightsideRadii] = rightsideRadii ## hier wird das vorher berechnete Array, dass genauso lang ist wie der Koordinaten DataFrame, als Spalte zu dem DataFrame trackProperties hinzugefügt.
end ##calculateRadiiFromTrack

function calculateAverageOfDifferentCentralRadii!(coordinates::AbstractDataFrame, trackProperties::AbstractDataFrame)
    #= Es werden mehrere Radien aus 3 Koordinaten berechnet. Dabei bleibt eine Koordinate immer gleich(central).
    Es wird immer eine Koordinate rechts und eine links von der Zentralen Koordinate gewählt.
    Bei dem ersten radius werden die Koordinaten direkt je rechts und links von der Zentralen Koordinate gewählt.
    Bei jedem weiteren Radius, der berechnet wird, wird der Abstand zur Zentralen Koordinate immer um eine Koordinate vergrößert.
    Der Parameter "radiiPerCoordinate" gibt dabei an wie viele Radien pro Zentraler Koordinate berechnet werden.
    Wie viele Koordinaten also maximal nach links und rechts gewandert werden.
    Am Ende wird das arithmetische Mittel aus allen berechneten Radien gebildet.
    =#
    centralRadiiAverage = fill(0.0, size(coordinates,1))
    radiiPerCoordinate = 3 ##Aus wie vielen Radien der Mittelwert berechnet werden soll
    for center in radiiPerCoordinate+1:size(coordinates,1)-radiiPerCoordinate ## es werden z.B. 3 Radien gebildet, von der letzten zentralen Koordinate braucht man noch 3 Koordinaten zu jedem Rand
        radiusAverage = 0
        for i in 1:radiiPerCoordinate
            radiusAverage = radiusAverage+getRadiusOfThreePoints(coordinates[center-i,:], coordinates[center,:], coordinates[center+i,:])
        end ## for i
        radiusAverage = radiusAverage/radiiPerCoordinate
        centralRadiiAverage[center] = round(radiusAverage) ##ACHTUNG hier wird gerundet
    end ##for center
    trackProperties[!, :centralRadiiAverage] = centralRadiiAverage
end ##calculateAverageRadiiOfDifferentCentralRadii

function calculateAverageOfLeftsideCentralRightsideRadii!(coordinates::AbstractDataFrame, trackProperties::AbstractDataFrame)
    #= Es werden 3 Radien aus je 3 Koordinaten berechnet. Dabei betrachtet man eine Koordinate als Zentral.
    Die beiden weiteren Koordinaten sind
    a) die beiden nächsten Koordinaten direkt links von der zentralen Koordinate (linksseitiger Radius)
    b) direkt links und rechts neben der zentralen Koordinate (zentraler Radius)
    c) die beiden nächsten Koordinaten direkt rechts von der zentralen Koordinate (rechtsseitiger Radius)
    Aus diesen 3 Radien wird dann das arithmetische Mittel gebildet.
    =#
    leftCentralRightRadiiAverage = fill(0.0, size(coordinates,1))
    for center in 3:size(coordinates,1)-2 ## Am Rand müssen neben dem letzten zu berechnenden center noch 2 Koordinaten verfügbar sein
        radiusAverage = 0
        leftsideRadius = getRadiusOfThreePoints(coordinates[center-2,:], coordinates[center-1,:], coordinates[center,:])
        centralRadius = getRadiusOfThreePoints(coordinates[center-1,:], coordinates[center,:], coordinates[center+1,:])
        rightsideRadius = getRadiusOfThreePoints(coordinates[center,:], coordinates[center+1,:], coordinates[center+2,:])
        radiusAverage = (leftsideRadius+centralRadius+rightsideRadius)/3
        leftCentralRightRadiiAverage[center] = round(radiusAverage) ##ACHTUNG hier wird gerundet
    end ## for center
    trackProperties[!, :leftCentralRightRadiiAverage] = leftCentralRightRadiiAverage
end## calculateAverageOfLeftsideCenterRightsideRadii

function calculateRadiusWithLeastSquareFittingOfCircles!(coordinates::AbstractDataFrame, trackProperties::AbstractDataFrame)
    #=hier soll der Radius durch eine Regression anngenähert werden.
    Dafür gibt es wieder eine Zentrale Koordinate. Mit dem parameter limit kann geregelt werden, wie viele Koordinaten je links und rechts vom Zentrum mit in die Regression mit einfließen soll.
    ACHTUNG: Die berechneten Radien sind komplett unrealistisch!!
    =#
    radiusThroughRegression = fill(0.0, size(coordinates,1))
    limit = 6
    for center in limit+1:size(coordinates,1)-limit
        A = [coordinates[center-limit:center+limit,:x] coordinates[center-limit:center+limit,:y] fill(1, limit*2+1)]
        B = [(coordinates[center-limit:center+limit,:x]).^2+(coordinates[center-limit:center+limit,:y]).^2] ## hier ist dim(B) = (1,1)
        B = B[1] ## vorher liegt der gesamte vektor in einem Eintrag, dem ersten. Jetz ist dim(B)=(7,1)
        x = pinv(A)*B
        radiusThroughRegression[center] = round(sqrt(4*(x[3])^2+x[1]^2+x[2]^2)/2) ## ACHTUNG hier wird gerundet
    end ## for center
    trackProperties[!, :radiusThroughRegression] = radiusThroughRegression
end##calculateRadiusWithLeastSquareFittingOfCircles
        