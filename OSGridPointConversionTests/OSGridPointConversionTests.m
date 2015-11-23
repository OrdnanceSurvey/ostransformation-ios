// The OpenSpace iOS SDK is protected by (c) Crown copyright – Ordnance Survey
// 2012.[https://github.com/OrdnanceSurvey]

// All rights reserved (subject to the BSD licence terms as follows):

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

// * Redistributions of source code must retain the above copyright notice, this
// 	 list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice, this
// 	 list of conditions and the following disclaimer in the documentation and/or
// 	 other materials provided with the distribution.
// * Neither the name of Ordnance Survey nor the names of its contributors may
// 	 be used to endorse or promote products derived from this software without
// 	 specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE

// The OpenSpace iOS SDK includes the Route-Me library.
// The Route-Me library is copyright (c) 2008-2012, Route-Me Contributors
// All rights reserved (subject to the BSD licence terms as follows):

// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:

// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
// OF SUCH DAMAGE.

// Route-Me depends on the Proj4 Library. [
// http://trac.osgeo.org/proj/wiki/WikiStart ]
// Proj4 is copyright (c) 2000, Frank Warmerdam / Gerald Evenden
// Proj4 is subject to the MIT licence as follows:

//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.

// Route-Me depends on the fmdb library. [ https://github.com/ccgus/fmdb ]
// fmdb is copyright (c) 2008 Flying Meat Inc
// fmdb is subject to the MIT licence as follows:

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// OSTN02 test set is © Crown copyright 2002. All rights reserved.

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OSGridPoint.h"
#import <MapKit/MKGeometry.h>

static const double kOSEpsilon = 0.0000001;

// OSTN02 test set
static const struct {
    const char *station;
    double lat, lng, e, n;
} kOSTestCoordinates[] = {
    {"StKilda", 57.8135184216667, -8.57854461027778, 9587.897, 899448.993},
    {"BLAC", 53.7791102569444, -3.04045490694444, 331534.552, 431920.792},
    {"BRIS", 51.4275474336111, -2.54407618611111, 362269.979, 169978.688},
    {"BUT1", 58.5156036180556, -6.26091455638889, 151968.641, 966483.777},
    {"CARL", 54.8954234052778, -2.93827741472222, 339921.133, 556034.759},
    {"CARM", 51.8589089675, -4.30852476611111, 241124.573, 220332.638},
    {"COLC", 51.8943663752778, 0.897243275, 599445.578, 225722.824},
    {"DARE", 53.3448028066667, -2.64049320722222, 357455.831, 383290.434},
    {"DROI", 52.2552938163889, -2.15458614944444, 389544.178, 261912.151},
    {"EDIN", 55.9247826525, -3.29479218777778, 319188.423, 670947.532},
    {"FLA1", 54.1168514433333, -0.077731326666667, 525745.658, 470703.211},
    {"GIR1", 57.1390251930556, -2.04856031611111, 397160.479, 805349.734},
    {"GLAS", 55.8539995297222, -4.29649015555556, 256340.914, 664697.266},
    {"INVE", 57.4862500033333, -4.21926398944444, 267056.756, 846176.969},
    {"IOMN", 54.3291954105556, -4.38849118, 244780.625, 495254.884},
    {"IOMS", 54.0866631808333, -4.634521685, 227778.318, 468847.386},
    {"KING", 52.7513668744444, 0.401535476944444, 562180.535, 319784.993},
    {"LEED", 53.8002151991667, -1.66379167583333, 422242.174, 433818.699},
    {"LIZ1", 49.9600613830556, -5.20304610027778, 170370.706, 11572.404},
    {"LOND", 51.4893656461111, -0.119925564166667, 530624.963, 178388.461},
    {"LYN1", 53.4162851577778, -4.28918069305556, 247958.959, 393492.906},
    {"LYN2", 53.4163092516667, -4.28917792638889, 247959.229, 393495.58},
    {"MALA", 57.0060669652778, -5.82836692638889, 167634.19, 797067.142},
    {"NAS1", 51.4007822038889, -3.55128348722222, 292184.858, 168003.462},
    {"NEWC", 54.97912274, -1.61657684555556, 424639.343, 565012.7},
    {"NFO1", 51.3744702591667, 1.44454730694444, 639821.823, 169565.856},
    {"NORT", 52.2516095091667, -0.91248957, 474335.957, 262047.752},
    {"NOTT", 52.962191095, -1.19747656166667, 454002.822, 340834.941},
    {"OSHQ", 50.9312793775, -1.45051434055556, 438710.908, 114792.248},
    {"PLYM", 50.4388582547222, -4.10864563972222, 250359.798, 62016.567},
    {"SCP1", 50.5756366516667, -1.29782277138889, 449816.359, 75335.859},
    {"SUM1", 59.8540991425, -1.27486911222222, 440725.061, 1107878.445},
    {"THUR", 58.5812046144444, -3.72631021305556, 299721.879, 967202.99},
    {"Scilly", 49.9222639433333, -6.29977752722222, 91492.135, 11318.801},
    {"Flannan", 58.2126224813889, -7.59255563111111, 71713.12, 938516.401},
    {"NorthRona", 59.0967161777778, -5.82799340888889, 180862.449, 1029604.111},
    {"SuleSkerry", 59.0933503508333, -4.41757674166667, 261596.767, 1025447.599},
    {"Foula", 60.1330809208333, -2.07382822361111, 395999.656, 1138728.948},
    {"FairIsle", 59.5347079433333, -1.62516965833333, 421300.513, 1072147.236},
    {"Orkney", 59.03743871, -3.21454001055556, 330398.311, 1017347.013},
    {"Ork_Main(Ork)", 58.7189371830556, -3.07392603527778, 337898.195, 981746.359},
    {"Ork_Main(Main)", 58.7210828644444, -3.13788287305556, 334198.101, 982046.419},
};

static double distanceBetweenCoords(CLLocationCoordinate2D a, CLLocationCoordinate2D b) {
    CLLocation *aa = [[CLLocation alloc] initWithCoordinate:a altitude:0 horizontalAccuracy:-1 verticalAccuracy:-1 timestamp:NSDate.date];
    CLLocation *bb = [[CLLocation alloc] initWithCoordinate:b altitude:0 horizontalAccuracy:-1 verticalAccuracy:-1 timestamp:NSDate.date];
    return [aa distanceFromLocation:bb];
}

@interface OSGridPointCoversionTests : XCTestCase

@end

@implementation OSGridPointCoversionTests

- (void)testAKnownCoordinate {
    CLLocationCoordinate2D testCoordinate = CLLocationCoordinate2DMake(51.8589089675, -4.30852476611111);
    OSGridPoint testGridPoint = OSGridPointMake(241124.5732599, 220332.6360795);
    XCTAssert([self verifyOneLatLong:testCoordinate againstGridPoint:testGridPoint withAccuracy:0.000000029016519]);
}

- (void)testItIsPossibleToMakeAValidGridPoint {
    OSGridDistance easting = 600;
    OSGridDistance northing = 400;

    OSGridPoint testPoint = OSGridPointMake(easting, northing);
    XCTAssertTrue(OSGridPointIsValid(testPoint), @"Grid point should be valid.");
    XCTAssertEqual(testPoint.easting, easting, @"Eastings should be equal.");
    XCTAssertEqual(testPoint.northing, northing, @"Northings should be equal.");
}

- (void)testLatLngToOSGridPoint {
    double totalEastingError = 0;
    double totalNorthingError = 0;
    double sumXSquared = 0;
    double sumYSquared = 0;
    double sumDistance = 0;
    double sumDistanceSquared = 0;
    double maxDistanceError = 0;
    size_t numberOfTestPoints = sizeof(kOSTestCoordinates) / sizeof(kOSTestCoordinates[0]);

    for (size_t i = 0; i < numberOfTestPoints; i++) {
        OSGridPoint p = OSGridPointForCoordinate((CLLocationCoordinate2D){.latitude = kOSTestCoordinates[i].lat, kOSTestCoordinates[i].lng});
        double diffX = p.easting - kOSTestCoordinates[i].e;
        double diffY = p.northing - kOSTestCoordinates[i].n;
        XCTAssertEqualWithAccuracy(diffX, 0.0, 0.01763, @"Error");
        XCTAssertEqualWithAccuracy(diffY, 0.0, 0.006457, @"Error");
        double distsq = diffX * diffX + diffY * diffY;
        double dist = sqrt(distsq);
        maxDistanceError = MAX(maxDistanceError, dist);
        totalEastingError += diffX;
        totalNorthingError += diffY;
        sumXSquared += diffX * diffX;
        sumYSquared += diffY * diffY;
        sumDistance += dist;
        sumDistanceSquared += distsq;
    }

    double avgX = totalEastingError / numberOfTestPoints;
    double avgY = totalNorthingError / numberOfTestPoints;
    double sdX = sqrt((sumXSquared - numberOfTestPoints * avgX * avgX) / (numberOfTestPoints - 1));
    double sdY = sqrt((sumYSquared - numberOfTestPoints * avgY * avgY) / (numberOfTestPoints - 1));

    XCTAssertEqualWithAccuracy(avgX, 0.0, 0.0005, @"Easting error average");
    XCTAssertEqualWithAccuracy(avgY, 0.0, 0.0003, @"Northing error average");
    XCTAssertEqualWithAccuracy(sdX, 0.0, 0.00332, @"Easting error standard deviation");
    XCTAssertEqualWithAccuracy(sdY, 0.0, 0.00177, @"Northing error standard deviation");
    XCTAssertEqualWithAccuracy(maxDistanceError, 0.0, 0.0187721, @"Maximum error distance");
}

- (void)testOSGridPointToLatLngToGridPoint {
    // Round-trip test.
    double sumX = 0;
    double sumY = 0;
    double sumXX = 0;
    double sumYY = 0;
    double sumD = 0;
    double sumDD = 0;
    double maxdist = 0;
    size_t n = sizeof(kOSTestCoordinates) / sizeof(kOSTestCoordinates[0]);

    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = OSCoordinateForGridPoint((OSGridPoint){kOSTestCoordinates[i].e, kOSTestCoordinates[i].n});
        OSGridPoint p = OSGridPointForCoordinate(coord);

        // Calculate distance on the ground this point differs from the reference dataset
        double diffX = p.easting - kOSTestCoordinates[i].e;
        double diffY = p.northing - kOSTestCoordinates[i].n;
        double distsq = diffX * diffX + diffY * diffY;
        double dist = sqrt(distsq);

        maxdist = MAX(maxdist, dist);
        sumX += diffX;
        sumY += diffY;
        sumXX += diffX * diffX;
        sumYY += diffY * diffY;
        sumD += dist;
        sumDD += distsq;
    }

    double avgX = sumX / n;
    double avgY = sumY / n;
    double sdX = sqrt((sumXX - n * avgX * avgX) / (n - 1));
    double sdY = sqrt((sumYY - n * avgY * avgY) / (n - 1));

    XCTAssertEqualWithAccuracy(avgX, 0.0, 0.000022, @"Easting error average");
    XCTAssertEqualWithAccuracy(avgY, 0.0, 0.0000335, @"Northing error average");
    XCTAssertEqualWithAccuracy(sdX, 0.0, 0.00011676, @"Easting error standard deviation");
    XCTAssertEqualWithAccuracy(sdY, 0.0, 0.00013858, @"Northing error standard deviation");
    XCTAssertEqualWithAccuracy(maxdist, 0.0, 0.00114, @"Maximum error dist");
}

- (void)testOSGridPointToLatLng {
    double sumX = 0;
    double sumY = 0;
    double sumXX = 0;
    double sumYY = 0;
    double sumD = 0;
    double sumDD = 0;
    double maxdist = 0;
    size_t n = sizeof(kOSTestCoordinates) / sizeof(kOSTestCoordinates[0]);

    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = OSCoordinateForGridPoint((OSGridPoint){kOSTestCoordinates[i].e, kOSTestCoordinates[i].n});
        double diffX = coord.longitude - kOSTestCoordinates[i].lng;
        double diffY = coord.latitude - kOSTestCoordinates[i].lat;
        double dist = distanceBetweenCoords(coord, (CLLocationCoordinate2D){kOSTestCoordinates[i].lat, kOSTestCoordinates[i].lng});
        maxdist = MAX(maxdist, dist);
        sumX += diffX;
        sumY += diffY;
        sumXX += diffX * diffX;
        sumYY += diffY * diffY;
        sumD += dist;
        sumDD += dist * dist;
    }

    double avgX = sumX / n;
    double avgY = sumY / n;
    double sdX = sqrt((sumXX - n * avgX * avgX) / (n - 1));
    double sdY = sqrt((sumYY - n * avgY * avgY) / (n - 1));

    XCTAssertEqualWithAccuracy(avgX, 0.0, 0.000000007131, @"Latitude error average");
    XCTAssertEqualWithAccuracy(avgY, 0.0, 0.000000003479, @"Longitude error average");
    XCTAssertEqualWithAccuracy(sdX, 0.0, 0.000000050892, @"Latitude error standard deviation");
    XCTAssertEqualWithAccuracy(sdY, 0.0, 0.000000018087, @"Northing error standard deviation");
    XCTAssertEqualWithAccuracy(maxdist, 0.0, 0.018372, @"Maximum error distance");
}

- (void)testRoundTripConversion {
    size_t n = sizeof(kOSTestCoordinates) / sizeof(kOSTestCoordinates[0]);
    for (size_t i = 0; i < n; i++) {
        OSGridPoint gp = (OSGridPoint){kOSTestCoordinates[i].e, kOSTestCoordinates[i].n};
        CLLocationCoordinate2D coord = OSCoordinateForGridPoint(gp);
        OSGridPoint gp2 = OSGridPointForCoordinate(coord);
        XCTAssertEqualWithAccuracy((gp.easting - gp2.easting), (double)0.0, .0015, @"Error E");
        XCTAssertEqualWithAccuracy((gp.northing - gp2.northing), (double)0.0, .0015, @"Error N");
    }
}

- (void)testOSCoordinateRegionMakeWithDistance {
    size_t n = sizeof(kOSTestCoordinates) / sizeof(kOSTestCoordinates[0]);
    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = (CLLocationCoordinate2D){.latitude = kOSTestCoordinates[i].lat, kOSTestCoordinates[i].lng};

        OSGridDistance sizeX = 1000;
        OSGridDistance sizeY = 2000;
        OSCoordinateRegion region = OSCoordinateRegionMakeWithDistance(coord, sizeY, sizeX);
        OSGridRect gridRect = OSGridRectForCoordinateRegion(region);

        double DEG2RAD = M_PI / 180.0;

        // Sanity check the region against a very approximate conversion
        XCTAssertEqualWithAccuracy(region.span.latitudeDelta * 111000, sizeY, 10.0, @"Verify latitude delta");
        XCTAssertEqualWithAccuracy(region.span.longitudeDelta * 111000 * cos(DEG2RAD * region.center.latitude), sizeX, 10.0, @"Verify latitude delta");

        XCTAssertEqualWithAccuracy(gridRect.size.height, sizeY, kOSEpsilon, @"Verify northing span");
        XCTAssertEqualWithAccuracy(gridRect.size.width, sizeX, kOSEpsilon, @"Verify easting span");
    }
}

- (void)testOSCoordinateRegionToGridRect {
    size_t n = sizeof(kOSTestCoordinates) / sizeof(kOSTestCoordinates[0]);
    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = (CLLocationCoordinate2D){.latitude = kOSTestCoordinates[i].lat, kOSTestCoordinates[i].lng};

        double sizeX = 1000;
        double sizeY = 2000;
        OSCoordinateRegion region = OSCoordinateRegionMakeWithDistance(coord, sizeY, sizeX);
        // Sanity chck
        XCTAssertEqual(coord.latitude, region.center.latitude, @"Verify central location");
        XCTAssertEqual(coord.longitude, region.center.longitude, @"Verify central location");

        OSGridRect gridRect = OSGridRectForCoordinateRegion(region);
        OSGridPoint gridRectCenter = OSGridRectGetCenter(gridRect);

        // Check the center coordinate matches. It may be off slightly, since the
        // center of a grid
        // rect involves dividing the span by 2, which can cause a rounding error.
        // Grid point
        // accuracy is +/- 6.25cm, so center points should match to within that.
        OSGridPoint directCenter = OSGridPointForCoordinate(region.center);
        float diffE = gridRectCenter.easting - directCenter.easting;
        XCTAssertEqualWithAccuracy(diffE, 0.0, kOSEpsilon, @"Central point calculation easting %zu", i);
        float diffN = gridRectCenter.northing - directCenter.northing;
        XCTAssertEqualWithAccuracy(diffN, 0.0, kOSEpsilon, @"Central point calculation northing %zu", i);

        // We know that our projection is slightly inaccurate, by up to 6 metres, so
        // don't bother
        // checking the center coordinate against the real centeral coordinate, as
        // that's covered
        // by other tests.
        double diffSX = sizeX - gridRect.size.width;
        double diffSY = sizeY - gridRect.size.height;
        const char *stn = kOSTestCoordinates[i].station;
        XCTAssertEqualWithAccuracy(diffSX, 0.0, kOSEpsilon, @"Span easting accuracy %s", stn);
        XCTAssertEqualWithAccuracy(diffSY, 0.0, kOSEpsilon, @"Span northing accuracy %s", stn);
    }
}

- (void)testLargeSpan {
    CLLocationCoordinate2D coord;
    coord.longitude = 2;
    coord.latitude = 52;

    OSCoordinateRegion region;
    region.center = coord;
    region.span.latitudeDelta = 90;
    region.span.longitudeDelta = 90;
    // This test checks for a crash, not for accuracy
    OSGridRect gridRect = OSGridRectForCoordinateRegion(region);

    XCTAssertTrue(OSGridPointIsValid(gridRect.originSW), @"It should be a valid grid rect...");
    XCTAssertFalse(OSGridPointIsWithinBounds(gridRect.originSW), @"... but outside the National Grid boundary");
}

- (void)testOSGridRectToCoordinateRegion {
    size_t n = sizeof(kOSTestCoordinates) / sizeof(kOSTestCoordinates[0]);
    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = (CLLocationCoordinate2D){.latitude = kOSTestCoordinates[i].lat, kOSTestCoordinates[i].lng};
        OSGridPoint gp = (OSGridPoint){kOSTestCoordinates[i].e, kOSTestCoordinates[i].n};
        OSGridRect gridRect;
        gridRect.originSW = gp;
        double sizeX = 1000;
        double sizeY = 2000;
        gridRect.size.width = sizeX;
        gridRect.size.height = sizeY;
        gridRect.originSW.easting -= sizeX / 2;
        gridRect.originSW.northing -= sizeY / 2;

        OSCoordinateRegion region = OSCoordinateRegionForGridRect(gridRect);

        double scalingFactor = ABS((cos(2 * M_PI * coord.latitude / 360.0)));
        double degreeLatitude = 1854.46 * 60;
        double degreeLongitude = degreeLatitude * scalingFactor;

        double longitudeDelta = sizeX / degreeLongitude;
        double latitudeDelta = sizeY / degreeLatitude;

        double diffX = coord.longitude - region.center.longitude;
        double diffY = coord.latitude - region.center.latitude;
        double diffSX = longitudeDelta - region.span.longitudeDelta;
        double diffSY = latitudeDelta - region.span.latitudeDelta;
        double accuracy = 10;
        XCTAssertEqualWithAccuracy(diffX, 0.0, accuracy / degreeLongitude, @"Central longitude accuracy");
        XCTAssertEqualWithAccuracy(diffY, 0.0, accuracy / degreeLatitude, @"Central latitude accuracy");
        XCTAssertEqualWithAccuracy(diffSX, 0.0, accuracy / longitudeDelta, @"Span longitude accuracy");
        XCTAssertEqualWithAccuracy(diffSY, 0.0, accuracy / latitudeDelta, @"Span latitude accuracy");
    }
}

- (void)testInvalidPoints {
    // MKMapPointForCoordinate() seems to return (-1,-1) for invalid inputs
    MKMapPoint const INVALID_MAP_POINT = {-1, -1};
    float invalid[] = {-INFINITY, INFINITY, nanf(0)};
    for (unsigned i = 0; i < 10; i++) {
        CLLocationCoordinate2D coord = (i < 9 ? (CLLocationCoordinate2D){invalid[i / 3], invalid[i % 3]} : kCLLocationCoordinate2DInvalid);
        XCTAssertFalse(CLLocationCoordinate2DIsValid(coord));
        OSGridPoint gp = OSGridPointForCoordinate(coord);
        XCTAssertFalse(OSGridPointIsValid(gp));
        MKMapPoint mp = MKMapPointForCoordinate(coord);

        XCTAssertTrue(MKMapPointEqualToPoint(mp, INVALID_MAP_POINT), @"MKMapPointForCoordinate() seems to return (-1,-1) for invalid inputs.");
    }
    for (unsigned i = 0; i < 10; i++) {
        OSGridPoint p = (i < 9 ? (OSGridPoint){invalid[i / 3], invalid[i % 3]} : OSGridPointInvalid);
        XCTAssertFalse(OSGridPointIsValid(p));
        CLLocationCoordinate2D coord = OSCoordinateForGridPoint(p);
        XCTAssertFalse(CLLocationCoordinate2DIsValid(coord));

        OSGridRect gr = (OSGridRect){p, {0, 0}};
        XCTAssertTrue(OSGridRectIsNull(gr));

        OSGridRect r = {{gr.originSW.easting, -gr.originSW.northing}, {gr.size.width, -gr.size.height}};
        XCTAssertTrue(OSGridRectIsNull(r));
    }
    for (unsigned i = 0; i < 9; i++) {
        MKMapPoint mp = (MKMapPoint){invalid[i / 3], invalid[i % 3]};
        CLLocationCoordinate2D coord = MKCoordinateForMapPoint(mp);
        bool result = CLLocationCoordinate2DIsValid(coord);
        XCTAssertFalse(result);
    }
}

- (void)testInvalidRects {
    {
        MKMapRect mr = MKMapRectNull;
        MKCoordinateRegion cr = MKCoordinateRegionForMapRect(mr);
        XCTAssertFalse(CLLocationCoordinate2DIsValid(cr.center));
    }

    {
        OSGridRect gr = {OSGridPointInvalid, {0, 0}};
        XCTAssertTrue(OSGridRectIsNull(gr));
        CGRect r = {{gr.originSW.easting, -gr.originSW.northing}, {gr.size.width, -gr.size.height}};
        XCTAssertTrue(CGRectIsNull(r), @"");
        r = CGRectStandardize(r);
        XCTAssertTrue(CGRectIsNull(r), @"");

        OSCoordinateRegion cr = OSCoordinateRegionForGridRect(gr);
        XCTAssertFalse(CLLocationCoordinate2DIsValid(cr.center));
    }

    {
        CGRect r = CGRectNull;
        XCTAssertTrue(CGRectIsNull(r));
        OSGridRect gr = {{r.origin.x, -CGRectGetMaxY(r)}, {r.size.width, fabsf(r.size.height)}};
        XCTAssertTrue(OSGridRectIsNull(gr));
        XCTAssertFalse(OSGridPointIsValid(gr.originSW));
    }
}

- (void)testGridRefToGridPoint {
    XCTAssertTrue(OSGridPointEqualToPoint(OSGridPointFromString(@"SV", NULL), (OSGridPoint){0, 0}), @"SV should be (0,0)");

    // TODO: Unportable: assumes ASCII-compatible charset.
    unsigned numhits = 0;
    NSString *zeroes[] = {
        @"",
        @"0",
        @"00",
        @"000",
        @"0000",
        @"00000",
    };
    for (char i = 'A'; i <= 'Z'; i++) {
        for (char j = 'A'; j <= 'Z'; j++) {
            NSString *letters = [NSString stringWithCharacters:(const unichar[]) { i, j } length:2];
            NSInteger ndigs = 0;
            OSGridPoint p = OSGridPointFromString(letters, &ndigs);
            XCTAssertTrue(ndigs == 0, @"Should have no digits");
            if (OSGridPointIsValid(p)) {
                numhits++;
            }
            XCTAssertTrue(!OSGridPointIsValid(p) || OSGridPointIsWithinBounds(p), @"Should be within National Grid bounds");
            if (OSGridPointIsValid(p)) {
                XCTAssertEqualObjects(letters, NSStringFromOSGridPoint(p, 0), @"It should round-trip correctly if the grid point is valid");
            }

            for (unsigned nzeroes = 1; nzeroes < 6; nzeroes++) {
                // Init ndigs to make the asserts simpler later.
                ndigs = nzeroes;
                // Not quite "normalized" for a 0-digit grid ref (e.g. "SK").
                NSString *normalizedGridRef = [NSString stringWithFormat:@"%@ %@ %@", letters, zeroes[nzeroes], zeroes[nzeroes]];
                OSGridPoint p2 = OSGridPointFromString(normalizedGridRef, &ndigs);
                XCTAssertTrue(ndigs == nzeroes, @"Should output the right number of digits");
                XCTAssertTrue(OSGridPointEqualToPoint(p, p2), @"Should output the same point");
                if (nzeroes && OSGridPointIsValid(p2)) {
                    // This test isn't valid when nzeroes is 0 (it compares "SK" against
                    // "SK  ").
                    XCTAssertEqualObjects(normalizedGridRef, NSStringFromOSGridPoint(p2, nzeroes), @"It should round-trip correctly if the grid point is valid");
                }

                p2 = OSGridPointFromString([NSString stringWithFormat:@"%@ %@%@", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                XCTAssertTrue(ndigs == nzeroes, @"Should output the right number of digits");
                XCTAssertTrue(OSGridPointEqualToPoint(p, p2), @"Should output the same point");

                p2 = OSGridPointFromString([NSString stringWithFormat:@"%@%@ %@", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                XCTAssertTrue(ndigs == nzeroes, @"Should output the right number of digits");
                XCTAssertTrue(OSGridPointEqualToPoint(p, p2), @"Should output the same point");

                p2 = OSGridPointFromString([NSString stringWithFormat:@"%@%@%@", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                XCTAssertTrue(ndigs == nzeroes, @"Should output the right number of digits");
                XCTAssertTrue(OSGridPointEqualToPoint(p, p2), @"Should output the same point");

                p2 = OSGridPointFromString([NSString stringWithFormat:@"%@ %@ %@0", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");
                p2 = OSGridPointFromString([NSString stringWithFormat:@"%@ %@0 %@", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");
                p2 = OSGridPointFromString([NSString stringWithFormat:@"%@%@ %@0", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");
                p2 = OSGridPointFromString([NSString stringWithFormat:@"%@%@0 %@", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");
                p2 = OSGridPointFromString([NSString stringWithFormat:@"%@%@%@0", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");
                p2 = OSGridPointFromString([NSString stringWithFormat:@"%@%@0%@", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");

                if (nzeroes) {
                    // Add two zeroes! These tests are only valid if we've already added
                    // digits.
                    p2 = OSGridPointFromString([NSString stringWithFormat:@"%@ %@ %@00", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                    XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");
                    p2 = OSGridPointFromString([NSString stringWithFormat:@"%@ %@00 %@", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                    XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");
                    p2 = OSGridPointFromString([NSString stringWithFormat:@"%@%@ %@00", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                    XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");
                    p2 = OSGridPointFromString([NSString stringWithFormat:@"%@%@00 %@", letters, zeroes[nzeroes], zeroes[nzeroes]], &ndigs);
                    XCTAssertFalse(OSGridPointIsValid(p2), @"Odd/inconsistent number of digits");
                }
            }

            p = OSGridPointFromString([NSString stringWithFormat:@"%@ 000000 000000", letters], &ndigs);
            XCTAssertFalse(OSGridPointIsValid(p), @"Too many digits");
            p = OSGridPointFromString([NSString stringWithFormat:@"%@ 000000000000", letters], &ndigs);
            XCTAssertFalse(OSGridPointIsValid(p), @"Too many digits");
            p = OSGridPointFromString([NSString stringWithFormat:@"%@000000 000000", letters], &ndigs);
            XCTAssertFalse(OSGridPointIsValid(p), @"Too many digits");
            p = OSGridPointFromString([NSString stringWithFormat:@"%@000000000000", letters], &ndigs);
            XCTAssertFalse(OSGridPointIsValid(p), @"Too many digits");
        }
    }
    XCTAssertTrue(numhits == 7 * 13, @"Should be 7*13 hits for a 700000mx1300000m grid and 100k squares");
}

- (void)testDistance {
    OSGridPoint gp1 = (OSGridPoint){100, 100};
    OSGridPoint gp2 = (OSGridPoint){400, 500};
    XCTAssertEqualWithAccuracy((float)500.0, OSMetersBetweenGridPoints(gp1, gp2), 0.00001, @"Check distance");
    XCTAssertEqualWithAccuracy((float)500.0, OSMetersBetweenGridPoints(gp2, gp1), 0.00001, @"Check distance");
}

- (void)testOSGridRectEnclosingPoint {
    OSGridPoint gp = (OSGridPoint){2000, 2000};
    OSGridRect gridRect = OSGridRectEnclosingPoint(gp, 2000, 1000);
    XCTAssertTrue(gridRect.originSW.easting == 1000, @"Easting");
    XCTAssertTrue(gridRect.originSW.northing == 1500, @"Northing");
    XCTAssertTrue(gridRect.size.width == 2000, @"Width");
    XCTAssertTrue(gridRect.size.height == 1000, @"Height");
}

- (void)testOSGridRectOffset {
    OSGridRect gr = OSGridRectMake(100, 200, 300, 400);
    gr = OSGridRectOffset(gr, 50, 25);
    XCTAssertTrue(gr.originSW.easting == 150, @"Easting");
    XCTAssertTrue(gr.originSW.northing == 225, @"Northing");
    XCTAssertTrue(gr.size.width == 300, @"Width");
    XCTAssertTrue(gr.size.height == 400, @"Height");
}

- (void)testOSGridRectInset {
    OSGridRect gr = OSGridRectMake(100, 200, 300, 400);
    gr = OSGridRectInset(gr, 50, 25);
    XCTAssertTrue(gr.originSW.easting == 150, @"Easting");
    XCTAssertTrue(gr.originSW.northing == 225, @"Northing");
    XCTAssertTrue(gr.size.width == 200, @"Width");
    XCTAssertTrue(gr.size.height == 350, @"Height");

    gr = OSGridRectInset(gr, 100, 10);
    XCTAssertTrue(OSGridRectIsNull(gr), @"Check for null");
}

- (void)testOSGridRectUnion {
    OSGridRect gr = OSGridRectMake(100, 200, 300, 400);
    OSGridRect gr2 = OSGridRectMake(50, 50, 50, 50);

    gr = OSGridRectUnion(gr, gr2);
    XCTAssertTrue(gr.originSW.easting == 50, @"Easting");
    XCTAssertTrue(gr.originSW.northing == 50, @"Northing");
    XCTAssertTrue(gr.size.width == 350, @"Width");
    XCTAssertTrue(gr.size.height == 550, @"Height");
}

- (void)testOSGridRectIntersection {
    OSGridRect gr = OSGridRectMake(100, 200, 300, 400);
    OSGridRect gr2 = OSGridRectMake(150, 200, 50, 50);

    gr = OSGridRectIntersection(gr, gr2);
    XCTAssertTrue(gr.originSW.easting == 150, @"Easting");
    XCTAssertTrue(gr.originSW.northing == 200, @"Northing");
    XCTAssertTrue(gr.size.width == 50, @"Width");
    XCTAssertTrue(gr.size.height == 50, @"Height");
}

- (void)testOSGridRectIntersectsRect {
    OSGridRect gr = OSGridRectMake(100, 200, 300, 400);
    OSGridRect gr2 = OSGridRectMake(150, 200, 50, 50);
    XCTAssertTrue(OSGridRectIntersectsRect(gr, gr2));
    OSGridRect gr3 = OSGridRectMake(50, 200, 50, 50);
    XCTAssertFalse(OSGridRectIntersectsRect(gr, gr3));
    OSGridRect gr4 = OSGridRectMake(100, 150, 50, 50);
    XCTAssertFalse(OSGridRectIntersectsRect(gr, gr4));
    OSGridRect gr5 = OSGridRectMake(100, 151, 50, 50);
    XCTAssertTrue(OSGridRectIntersectsRect(gr, gr5));
    OSGridRect gr6 = OSGridRectMake(51, 200, 50, 50);
    XCTAssertTrue(OSGridRectIntersectsRect(gr, gr6));
    OSGridRect gr7 = OSGridRectMake(400, 200, 50, 50);
    XCTAssertFalse(OSGridRectIntersectsRect(gr, gr7));
    OSGridRect gr8 = OSGridRectMake(100, 600, 50, 50);
    XCTAssertFalse(OSGridRectIntersectsRect(gr, gr8));
}

/**
 *  Verifies the conversion of one lat/long coordinate to a GriPoint with a tolerance.
 *
 *  @param coordinate      The coordinate to transform
 *  @param knownGridPoint  The known accurate grid point
 *  @param desiredAccuracy The allowed error tolerance
 *
 *  @return true if the calculated grid point easting and northing values are 
 *  accurate within the specified tolerance
 */
- (BOOL)verifyOneLatLong:(CLLocationCoordinate2D)coordinate againstGridPoint:(OSGridPoint)knownGridPoint withAccuracy:(double)desiredAccuracy {
    OSGridPoint calculatedGridPoint = OSGridPointForCoordinate(coordinate);
    double eastingError = calculatedGridPoint.easting - knownGridPoint.easting;
    double northingError = calculatedGridPoint.northing - knownGridPoint.northing;
    bool result = (fabs(eastingError) <= desiredAccuracy) && (fabs(northingError) <= desiredAccuracy);
    return result;
}

- (void)testOSGridRectForBoundingBox {
    CLLocationCoordinate2D bottomLeft = CLLocationCoordinate2DMake(57.8135184216667, -8.57854461027778);
    CLLocationCoordinate2D topRight = CLLocationCoordinate2DMake(58.7210828644444, -3.13788287305556);
    OSBoundingBox boundingBox = OSBoundingBoxMake(bottomLeft, topRight);

    OSGridRect gridRect = OSGridRectForBoundingBox(boundingBox);
    XCTAssertEqualWithAccuracy(gridRect.originSW.easting, 9587.9146269498742, 0.01, @"Easting");
    XCTAssertEqualWithAccuracy(gridRect.originSW.northing, 899448.99945611343, 0.01, @"Northing");
    XCTAssertEqualWithAccuracy(gridRect.size.width, 324610.18636172538, 0.01, @"Width");
    XCTAssertEqualWithAccuracy(gridRect.size.height, 82597.420136745321, 0.01, @"Height");
}

- (void)testOSGridRectForBoundingBoxReturnsNullForInvalidBoundingBox {
    CLLocationCoordinate2D bottomLeft = CLLocationCoordinate2DMake(57.8135184216667, -8.57854461027778);
    CLLocationCoordinate2D topRight = CLLocationCoordinate2DMake(58.7210828644444, -3.13788287305556);
    OSBoundingBox boundingBox = OSBoundingBoxMake(topRight, bottomLeft);

    OSGridRect gridRect = OSGridRectForBoundingBox(boundingBox);
    OSGridRect nullGridRect = OSGridRectNull;
    XCTAssertEqual(gridRect.originSW.easting, nullGridRect.originSW.easting);
    XCTAssertEqual(gridRect.originSW.northing, nullGridRect.originSW.northing);
    XCTAssertEqual(gridRect.size.width, nullGridRect.size.width);
    XCTAssertEqual(gridRect.size.height, nullGridRect.size.height);
}

- (void)testOSBoundingBoxForGridRect {
    CLLocationCoordinate2D bottomLeft = CLLocationCoordinate2DMake(57.8135184216667, -8.57854461027778);
    CLLocationCoordinate2D topRight = CLLocationCoordinate2DMake(58.7210828644444, -3.13788287305556);

    OSGridRect gridRect = OSGridRectMake(9587.9146269498742, 899448.99945611343, 324610.18636172538, 82597.420136745321);
    OSBoundingBox bbox = OSBoundingBoxForGridRect(gridRect);
    XCTAssertEqualWithAccuracy(bbox.bottomLeft.latitude, bottomLeft.latitude, 0.01, @"Bottom left Latitude");
    XCTAssertEqualWithAccuracy(bbox.bottomLeft.longitude, bottomLeft.longitude, 0.01, @"Bottom left Longitude");
    XCTAssertEqualWithAccuracy(bbox.topRight.latitude, topRight.latitude, 0.01, @"Top right latitude");
    XCTAssertEqualWithAccuracy(bbox.topRight.longitude, topRight.longitude, 0.01, @"Top right longitude");
}

- (void)testOSBoundingBoxEqualToBox {
    CLLocationCoordinate2D bottomLeft = CLLocationCoordinate2DMake(57.8135184216667, -8.57854461027778);
    CLLocationCoordinate2D topRight = CLLocationCoordinate2DMake(58.7210828644444, -3.13788287305556);
    OSBoundingBox b1 = OSBoundingBoxMake(topRight, bottomLeft);
    OSBoundingBox b2 = OSBoundingBoxMake(bottomLeft, topRight);
    XCTAssertTrue(OSBoundingBoxEqualToBox(b1, b1));
    XCTAssertFalse(OSBoundingBoxEqualToBox(b1, b2));

    topRight = CLLocationCoordinate2DMake(57.8135184216667, -3.13788287305556);
    b1 = OSBoundingBoxMake(topRight, bottomLeft);
    XCTAssertFalse(OSBoundingBoxEqualToBox(b1, b2));

    topRight = CLLocationCoordinate2DMake(58.7210828644444, -8.57854461027778);
    b1 = OSBoundingBoxMake(topRight, bottomLeft);
    XCTAssertFalse(OSBoundingBoxEqualToBox(b1, b2));
}

@end
