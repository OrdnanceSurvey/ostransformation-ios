// The OpenSpace iOS SDK is protected by (c) Crown copyright – Ordnance Survey
// 2012.[https://github.com/OrdnanceSurvey]

// All rights reserved (subject to the BSD licence terms as follows):

// Redistribution and use in source and binary forms, with or without
// modification,
// are permitted provided that the following conditions are met:

// * Redistributions of source code must retain the above copyright notice, this
// 	 list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
// this
// 	 list of conditions and the following disclaimer in the documentation
// and/or
// 	 other materials provided with the distribution.
// * Neither the name of Ordnance Survey nor the names of its contributors may
// 	 be used to endorse or promote products derived from this software
// without
// 	 specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE

// The OpenSpace iOS SDK includes the Route-Me library.
// The Route-Me library is copyright (c) 2008-2012, Route-Me Contributors
// All rights reserved (subject to the BSD licence terms as follows):

// Redistribution and use in source and binary forms, with or without
// modification,
// are permitted provided that the following conditions are met:

// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED.
// IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY
// DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA,
// OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
// OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY
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

// TEST_COORDINATES[] are © Crown copyright 2002. All rights reserved.
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "OSGridPoint.h"

#import <MapKit/MKGeometry.h>

// OSTN02 test set from
// http://www.ordnancesurvey.co.uk/oswebsite/gps/osnetfreeservices/furtherinfo/questdeveloper.html
static const struct {
    const char *station;
    double lat, lng, e, n;
} TEST_COORDINATES[] = {
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

// Helper function
static double distanceBetweenCoords(CLLocationCoordinate2D a, CLLocationCoordinate2D b) {
    CLLocation *aa = [[CLLocation alloc] initWithCoordinate:a altitude:0 horizontalAccuracy:-1 verticalAccuracy:-1 timestamp:nil];
    CLLocation *bb = [[CLLocation alloc] initWithCoordinate:b altitude:0 horizontalAccuracy:-1 verticalAccuracy:-1 timestamp:nil];
    return [aa distanceFromLocation:bb];
}

@interface OSGridPointCoversionTests : XCTestCase

@end

@implementation OSGridPointCoversionTests

- (void)testLatLngToOSGridPoint {
    double sumX = 0;
    double sumY = 0;
    double sumXX = 0;
    double sumYY = 0;
    double sumD = 0;
    double sumDD = 0;
    double maxdist = 0;
    size_t n = sizeof(TEST_COORDINATES) / sizeof(TEST_COORDINATES[0]);

    for (size_t i = 0; i < n; i++) {
        OSGridPoint p = OSGridPointForCoordinate((CLLocationCoordinate2D){.latitude = TEST_COORDINATES[i].lat, TEST_COORDINATES[i].lng});
        double diffX = p.easting - TEST_COORDINATES[i].e;
        double diffY = p.northing - TEST_COORDINATES[i].n;
        XCTAssertEqualWithAccuracy(diffX, 0.0, 6, @"Error");
        XCTAssertEqualWithAccuracy(diffY, 0.0, 6, @"Error");
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
    double avgD = sumD / n;
    double rmsD = sqrt(sumDD / n);
    NSLog(@"Average offset (%g±%g m, %g±%g m)", avgX, sdX, avgY, sdY);
    NSLog(@"Average dist %g m, RMS %g m", avgD, rmsD);
    NSLog(@"Maximum error dist: %g m", maxdist);
    XCTAssertEqualWithAccuracy(avgX, 0.0, 2.0, @"Easting error avg");
    XCTAssertEqualWithAccuracy(avgY, 0.0, 2.0, @"Northing error avg avg");
    XCTAssertEqualWithAccuracy(sdX, 0.0, 2.0, @"Easting error sd");
    XCTAssertEqualWithAccuracy(sdY, 0.0, 2.0, @"Northing error sd");
    // Maximum error is a bit poor
    XCTAssertEqualWithAccuracy(maxdist, 0.0, 5.0, @"Maximum error dist");
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
    size_t n = sizeof(TEST_COORDINATES) / sizeof(TEST_COORDINATES[0]);
    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = OSCoordinateForGridPoint((OSGridPoint){TEST_COORDINATES[i].e, TEST_COORDINATES[i].n});
        OSGridPoint p = OSGridPointForCoordinate(coord);

        // Calculate distance on the ground this point differs from the reference dataset
        double diffX = p.easting - TEST_COORDINATES[i].e;
        double diffY = p.northing - TEST_COORDINATES[i].n;
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
    double avgD = sumD / n;
    double rmsD = sqrt(sumDD / n);
    NSLog(@"Average offset (%g±%g m, %g±%g m)", avgX, sdX, avgY, sdY);
    NSLog(@"Average dist %g m, RMS %g m", avgD, rmsD);
    NSLog(@"Maximum error dist: %g m", maxdist);
    XCTAssertEqualWithAccuracy(avgX, 0.0, 0.1, @"Easting error avg");
    XCTAssertEqualWithAccuracy(avgY, 0.0, 0.1, @"Northing error avg avg");
    XCTAssertEqualWithAccuracy(sdX, 0.0, 0.1, @"Easting error sd");
    XCTAssertEqualWithAccuracy(sdY, 0.0, 0.1, @"Northing error sd");
    XCTAssertEqualWithAccuracy(maxdist, 0.0, 0.1, @"Maximum error dist");
}

- (void)testOSGridPointToLatLng {
    double sumX = 0;
    double sumY = 0;
    double sumXX = 0;
    double sumYY = 0;
    double sumD = 0;
    double sumDD = 0;
    double maxdist = 0;
    size_t n = sizeof(TEST_COORDINATES) / sizeof(TEST_COORDINATES[0]);
    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = OSCoordinateForGridPoint((OSGridPoint){TEST_COORDINATES[i].e, TEST_COORDINATES[i].n});
        double diffX = coord.longitude - TEST_COORDINATES[i].lng;
        double diffY = coord.latitude - TEST_COORDINATES[i].lat;
        double dist = distanceBetweenCoords(coord, (CLLocationCoordinate2D){TEST_COORDINATES[i].lat, TEST_COORDINATES[i].lng});

        XCTAssertEqualWithAccuracy(0.0, dist, 5.5, @"error distance");

        maxdist = MAX(maxdist, dist);
        sumX += diffX;
        sumY += diffY;
        sumXX += diffX * diffX;
        sumYY += diffY * diffY;
        sumD += dist;
        sumDD += dist * dist;
        // NSLog(@"Station %s diff %g °N, %g °E, %g m", TEST_COORDINATES[i].station,
        // diffX, diffY, dist);
    }
    double avgX = sumX / n;
    double avgY = sumY / n;
    double sdX = sqrt((sumXX - n * avgX * avgX) / (n - 1));
    double sdY = sqrt((sumYY - n * avgY * avgY) / (n - 1));
    double avgD = sumD / n;
    double rmsD = sqrt(sumDD / n);
    NSLog(@"Average offset %g±%g °N %g±%g °E", avgX, sdX, avgY, sdY);
    NSLog(@"Average dist %g m, RMS %g m", avgD, rmsD);
    NSLog(@"Maximum error dist: %g m", maxdist);
}

- (void)testRoundTripConversion {
    size_t n = sizeof(TEST_COORDINATES) / sizeof(TEST_COORDINATES[0]);
    for (size_t i = 0; i < n; i++) {
        OSGridPoint gp = (OSGridPoint){TEST_COORDINATES[i].e, TEST_COORDINATES[i].n};
        CLLocationCoordinate2D coord = OSCoordinateForGridPoint(gp);
        OSGridPoint gp2 = OSGridPointForCoordinate(coord);
        XCTAssertEqualWithAccuracy((gp.easting - gp2.easting), (float)0.0, .001, @"Error E");
        XCTAssertEqualWithAccuracy((gp.northing - gp2.northing), (float)0.0, .001, @"Error N");
        // NSLog(@"Station %s diff %g °N %g °E", TEST_COORDINATES[i].station, diffX,
        // diffY);
    }
}

- (void)testOSCoordinateRegionMakeWithDistance {
    size_t n = sizeof(TEST_COORDINATES) / sizeof(TEST_COORDINATES[0]);
    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = (CLLocationCoordinate2D){.latitude = TEST_COORDINATES[i].lat, TEST_COORDINATES[i].lng};

        double sizeX = 1000;
        double sizeY = 2000;
        OSCoordinateRegion region = OSCoordinateRegionMakeWithDistance(coord, sizeY, sizeX);
        OSGridRect gridRect = OSGridRectForCoordinateRegion(region);

        double DEG2RAD = 3.1415926535 / 180.0;

        // Sanity check the region against a very approximate conversion
        XCTAssertEqualWithAccuracy(region.span.latitudeDelta * 111000, sizeY, 10.0, @"Verify latitude delta");
        XCTAssertEqualWithAccuracy(region.span.longitudeDelta * 111000 * cos(DEG2RAD * region.center.latitude), sizeX, 10.0, @"Verify latitude delta");

        XCTAssertEqual((double)gridRect.size.height, sizeY, @"Verify northing span");
        XCTAssertEqual((double)gridRect.size.width, sizeX, @"Verify easting span");
    }
}

- (void)testOSCoordinateRegionToGridRect {
    size_t n = sizeof(TEST_COORDINATES) / sizeof(TEST_COORDINATES[0]);
    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = (CLLocationCoordinate2D){.latitude = TEST_COORDINATES[i].lat, TEST_COORDINATES[i].lng};

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
        XCTAssertEqualWithAccuracy(diffE, (float)0, 0.0625, @"Central point calculation easting %zu", i);
        float diffN = gridRectCenter.northing - directCenter.northing;
        XCTAssertEqualWithAccuracy(diffN, (float)0, 0.0625, @"Central point calculation northing %zu", i);

        // We know that our projection is slightly inaccurate, by up to 6 metres, so
        // don't bother
        // checking the center coordinate against the real centeral coordinate, as
        // that's covered
        // by other tests.
        double diffSX = sizeX - gridRect.size.width;
        double diffSY = sizeY - gridRect.size.height;
        const char *stn = TEST_COORDINATES[i].station;
        XCTAssertEqual(diffSX, 0.0, @"Span easting accuracy %s", stn);
        XCTAssertEqual(diffSY, 0.0, @"Span northing accuracy %s", stn);
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
    size_t n = sizeof(TEST_COORDINATES) / sizeof(TEST_COORDINATES[0]);
    for (size_t i = 0; i < n; i++) {
        CLLocationCoordinate2D coord = (CLLocationCoordinate2D){.latitude = TEST_COORDINATES[i].lat, TEST_COORDINATES[i].lng};
        OSGridPoint gp = (OSGridPoint){TEST_COORDINATES[i].e, TEST_COORDINATES[i].n};
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

        XCTAssertTrue(MKMapPointEqualToPoint(mp, INVALID_MAP_POINT), @"MKMapPointForCoordinate() seems to return (-1,-1) for " @"invalid inputs.");
    }
    for (unsigned i = 0; i < 10; i++) {
        OSGridPoint p = (i < 9 ? (OSGridPoint){invalid[i / 3], invalid[i % 3]} : OSGridPointInvalid);
        XCTAssertFalse(OSGridPointIsValid(p));
        CLLocationCoordinate2D coord = OSCoordinateForGridPoint(p);
        XCTAssertFalse(CLLocationCoordinate2DIsValid(coord));

        OSGridRect gr = (OSGridRect){p, {0, 0}};
        XCTAssertTrue(OSGridRectIsNull(gr));

        CGRect r = {{gr.originSW.easting, -gr.originSW.northing}, {gr.size.width, -gr.size.height}};
        // This is not always true for NANs. We should avoid them.
        XCTAssertTrue(CGRectIsNull(r) || isnan(gr.originSW.easting) || isnan(gr.originSW.northing));
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
                    XCTAssertEqualObjects(normalizedGridRef, NSStringFromOSGridPoint(p2, nzeroes),
                                          @"It should round-trip correctly if the grid point is valid");
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

@end
