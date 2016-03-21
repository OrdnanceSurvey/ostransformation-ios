// The OSTransformation SDK is protected by (c) Crown copyright – Ordnance Survey
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

// OSTN02 data is given in the rect with bottom-left (0,0) and top-right
// (700000,1250000).
// This ends up being off by ~100m, but all of that is sea.
//   http://www.ordnancesurvey.co.uk/oswebsite/gps/osnetfreeservices/furtherinfo/questdeveloper.html
//   http://www.ordnancesurvey.co.uk/oswebsite/gps/osnetfreeservices/furtherinfo/ostn02_ntv2.html
// Map tiles:
//   OV0/OV1/OV2 are 700000x1300000 m (280x520 at 2500 mpp, etc)
// Documentation:
//   http://www.ordnancesurvey.co.uk/oswebsite/web-services/os-openspace/pro/index.html
//   says 700000,1300000
enum {
    OSGridWidth = 700000,
    OSGridHeight = 1300000,
};

/*
 *  OSGridDistance
 *
 *  Discussion:
 *    Type used to represent a distance in meters.
 */
typedef double OSGridDistance;

/**
** Represents a point on the OSGB36 National Grid (EPSG:27700) as a pair of
*floats.
**
** Floats should be accurate enough for mapping purposes:
**   nextafterf(1250000,0) = 1249999.875
**   So the maximum spacing is 12.5 cm
**   So it can represent points to ±6.25 cm
*/
typedef struct {
    OSGridDistance easting;
    OSGridDistance northing;
} OSGridPoint;

/// @name Coordinate conversions
/**
 *  Converts a CLLocationCoordinate2D to an OSGB36 grid point
 *  Uses OSTN02 grid shift for sub 0.01m accuracy
 */
OSGridPoint OSGridPointForCoordinate(CLLocationCoordinate2D coordinate);
/**
 *  Converts an OSGB36 grid point to a CLLocationCoordinate2D
 *  Uses OSTN02 grid shift for sub 0.01m accuracy
 */
CLLocationCoordinate2D OSCoordinateForGridPoint(OSGridPoint gridPoint);
/**
 *  Converts an OSGB36 grid point to a CLLocationCoordinate2D
 *  Uses OSGB36 datum for 5-7m accuracy. Lower accuracy than above
 *  but may well provide better results when overlaying data on a source
 *  that wasn't created using OSTN02.
 */
CLLocationCoordinate2D OSCoordinateForGridPointUsing7Parameter(OSGridPoint gridPoint);
/**
 *  Converts a CLLocationCoordinate2D to a OSGB36 grid point.
 *  Uses OSGB36 datum for 5-7m accuracy. Lower accuracy than above
 *  but may well provide better results when overlaying data on a source
 *  that wasn't created using OSTN02.
 */
OSGridPoint OSGridPointForCoordinateUsing7Parameter(CLLocationCoordinate2D coordinate);

/// @name Formatting strings

/**
** Formats an OSGridPoint as a string.
**
** The output format depends on the specified `digitsPerDimension`. For the
*example grid point `(OSGridPoint){212345,767890}`,
**  -1: "212345,767890"
**   0: "NN"
**   1: "NN 1 6"
**   2: "NN 12 67"
**   3: "NN 123 678"
**   4: "NN 1234 6789"
**   5: "NN 12345 67890"
**
** For output without spaces, use `[NSStringFromOSGridPoint(...)
*stringByReplacingOccurrencesOfString:@" " withString:@""]`.
**
** @param point  The grid point to format.
** @param digitsPerDimension  The number of digits *per dimension* (max. 5), or
*-1 for digits-only output.
*/
NSString *NSStringFromOSGridPoint(OSGridPoint point, NSInteger digitsPerDimension);

OSGridPoint OSGridPointFromString(NSString *gridRef, NSInteger *outDigits);

static inline OSGridPoint OSGridPointMake(OSGridDistance easting, OSGridDistance northing) {
    OSGridPoint point;
    point.easting = easting;
    point.northing = northing;
    return point;
}

static inline bool OSGridPointEqualToPoint(OSGridPoint p1, OSGridPoint p2) {
    return (p1.easting == p2.easting && p1.northing == p2.northing);
}

extern OSGridPoint const OSGridPointZero;
extern OSGridPoint const OSGridPointInvalid;

static inline bool OSGridPointIsValid(OSGridPoint p) {
    return isfinite(p.northing) && isfinite(p.easting);
}

bool OSGridPointIsWithinBounds(OSGridPoint p);
OSGridDistance OSMetersBetweenGridPoints(OSGridPoint gp1, OSGridPoint gp2);

typedef struct {
    OSGridDistance width;
    OSGridDistance height;
} OSGridSize;

static inline bool OSGridSizeEqualToSize(OSGridSize s1, OSGridSize s2) {
    return (s1.width == s2.width && s1.height == s2.height);
}

typedef struct {
    OSGridPoint originSW;
    OSGridSize size;
} OSGridRect;

extern OSGridRect const OSNationalGridBounds;
extern OSGridRect const OSGridRectNull;

OSGridRect OSGridRectMake(OSGridDistance easting, OSGridDistance northing, OSGridDistance width, OSGridDistance height);
OSGridRect OSGridRectEnclosingPoint(OSGridPoint point, OSGridDistance width, OSGridDistance height); // Creates GridRect with exact width and height with the center at the point that's provided.
OSGridRect OSGridRectOffset(OSGridRect rect, OSGridDistance dx, OSGridDistance dy);
OSGridRect OSGridRectInset(OSGridRect rect, OSGridDistance dx, OSGridDistance dy);
OSGridRect OSGridRectUnion(OSGridRect rect1, OSGridRect rect2);
OSGridRect OSGridRectIntersection(OSGridRect rect1, OSGridRect rect2);

bool OSGridRectIsNull(OSGridRect gr);

static inline OSGridDistance OSGridRectMinEasting(OSGridRect rect) {
    return rect.originSW.easting;
}

static inline OSGridDistance OSGridRectMaxEasting(OSGridRect rect) {
    return rect.originSW.easting + rect.size.width;
}

static inline OSGridDistance OSGridRectMinNorthing(OSGridRect rect) {
    return rect.originSW.northing;
}

static inline OSGridDistance OSGridRectMaxNorthing(OSGridRect rect) {
    return rect.originSW.northing + rect.size.height;
}

static inline bool OSGridRectIntersectsRect(OSGridRect r1, OSGridRect r2) {
    return !(OSGridRectMaxEasting(r1) <= OSGridRectMinEasting(r2) ||
             OSGridRectMaxNorthing(r1) <= OSGridRectMinNorthing(r2) ||
             OSGridRectMinEasting(r1) >= OSGridRectMaxEasting(r2) ||
             OSGridRectMinNorthing(r1) >= OSGridRectMaxNorthing(r2));
}

static inline bool OSGridRectContainsPoint(OSGridRect r1, OSGridPoint p) {
    int dx = p.easting - r1.originSW.easting;
    if ((unsigned int)dx >= r1.size.width) {
        return NO;
    }
    int dy = p.northing - r1.originSW.northing;
    if ((unsigned int)dy >= r1.size.height) {
        return NO;
    }
    return YES;
}

static inline bool OSGridRectEqualToRect(OSGridRect r1, OSGridRect r2) {
    return OSGridPointEqualToPoint(r1.originSW, r2.originSW) && OSGridSizeEqualToSize(r1.size, r2.size);
}

static inline OSGridPoint OSGridRectGetCenter(OSGridRect gridRect) {
    return (OSGridPoint){
        gridRect.originSW.easting + gridRect.size.width / 2, gridRect.originSW.northing + gridRect.size.height / 2,
    };
}

/// @name Coordinate spans and regions

typedef struct {
    CLLocationDegrees latitudeDelta;
    CLLocationDegrees longitudeDelta;
} OSCoordinateSpan;

typedef struct {
    CLLocationCoordinate2D center;
    OSCoordinateSpan span;
} OSCoordinateRegion;

OSGridRect OSGridRectForCoordinateRegion(OSCoordinateRegion region);
OSCoordinateRegion OSCoordinateRegionForGridRect(OSGridRect gridRect);

OSCoordinateRegion OSCoordinateRegionMakeWithDistance(CLLocationCoordinate2D centerCoordinate, CLLocationDistance latitudinalMeters, CLLocationDistance longitudinalMeters);

struct OSBoundingBox {
    CLLocationCoordinate2D bottomLeft;
    CLLocationCoordinate2D topRight;
};
typedef struct OSBoundingBox OSBoundingBox;

static inline OSBoundingBox
OSBoundingBoxMake(CLLocationCoordinate2D bottomLeft, CLLocationCoordinate2D topRight) {
    OSBoundingBox p;
    p.bottomLeft = bottomLeft;
    p.topRight = topRight;
    return p;
}

static inline bool OSBoundingBoxEqualToBox(OSBoundingBox b1, OSBoundingBox b2) {
    return (b1.bottomLeft.latitude == b2.bottomLeft.latitude) && (b1.bottomLeft.longitude == b2.bottomLeft.longitude) && (b1.topRight.latitude == b2.topRight.latitude) && (b1.topRight.longitude == b2.topRight.longitude);
}

/**
 *  Returns gridrect for bounding box. This method will return OSGridRectNull if bounding box in invalid.
 *
 *  @param boundingBox boundingBox box for this OSGridRect is required
 *
 *  @return OSGridRect calculated based on bounding box provided
 */
OSGridRect OSGridRectForBoundingBox(OSBoundingBox boundingBox);

/**
 *  Returns Bounding Box for GridRect
 *
 *  @param gridRect OSGridRect for which bounding box is required
 *
 *  @return OSBoundingBox calculated based on grid rect that is provided
 */
OSBoundingBox OSBoundingBoxForGridRect(OSGridRect gridRect);

extern OSBoundingBox const OSBoundingBoxNull;
