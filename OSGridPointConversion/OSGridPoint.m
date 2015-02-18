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

#import "OSGridPoint.h"
#import "OSRMProjection.h"

#pragma mark validity

OSGridPoint const OSGridPointInvalid = {-INFINITY, -INFINITY};
OSGridRect const OSNationalGridBounds = {{0, 0}, {OSGridWidth, OSGridHeight}};
OSGridRect const OSGridRectNull = {{-INFINITY, -INFINITY}, {0, 0}};

// From
// http://www.ordnancesurvey.co.uk/oswebsite/gps/information/coordinatesystemsinfo/guidetonationalgrid/page9.html
// Going left-to-right, bottom-to-top.
static const char NATGRID_LETTERS[5][5] = {"VWXYZ", "QRSTU", "LMNOP", "FGHJK", "ABCDE"};

bool OSGridPointIsWithinBounds(OSGridPoint p) {
    return OSGridRectContainsPoint(OSNationalGridBounds, p);
}

bool OSGridRectIsNull(OSGridRect gr) {
    return !OSGridPointIsValid(gr.originSW);
}

#pragma mark -

OSGridPoint OSGridPointForCoordinate(CLLocationCoordinate2D coordinate) {
    if (!CLLocationCoordinate2DIsValid(coordinate)) {
        return OSGridPointInvalid;
    }

    OSRMProjectedPoint p = [[OSRMProjection OSGB36NationalGrid] coordinateToProjectedPoint:coordinate];
    return (OSGridPoint){p.x, p.y};
}

CLLocationCoordinate2D OSCoordinateForGridPoint(OSGridPoint gridPoint) {
    if (!OSGridPointIsValid(gridPoint)) {
        return kCLLocationCoordinate2DInvalid;
    }

    return [[OSRMProjection OSGB36NationalGrid] projectedPointToCoordinate:(OSRMProjectedPoint){gridPoint.easting, gridPoint.northing}];
}

OSGridDistance OSMetersBetweenGridPoints(OSGridPoint gp1, OSGridPoint gp2) {
    OSGridDistance dx = (gp1.easting - gp2.easting);
    OSGridDistance dy = (gp1.northing - gp2.northing);
    return sqrtf(dx * dx + dy * dy);
}

// Convert long/lat to meters at a particular location assuming locally flat
// earth.
OSGridSize OSGridSizeForRegion(OSCoordinateRegion region) {
    // Local flat earth approximation. Good enough for OS Coordinate area

    // WGS84 values
    double a = 6378137;
    double f = 1.0 / 298.257223563;
    double e2 = f * (2 - f);
    double DEG2RAD = M_PI / 180;
    double s = sin(region.center.latitude * DEG2RAD);
    double s2 = s * s;
    double R1 = a * (1 - e2) / pow((1 - e2 * s2), 1.5);
    double R2 = a / sqrt(1 - e2 * s2);

    OSGridSize size;
    size.height = region.span.latitudeDelta * R1 * DEG2RAD;
    size.width = region.span.longitudeDelta * R2 * DEG2RAD * cos(region.center.latitude * DEG2RAD);
    return size;
}

// Convert meters to long/lat at a particular location assuming locally flat
// earth.
OSCoordinateRegion OSCoordinateRegionMakeWithDistance(CLLocationCoordinate2D centerCoordinate, CLLocationDistance latitudinalMeters, CLLocationDistance longitudinalMeters) {
    // Local flat earth approximation. Good enough for OS Coordinate area
    OSCoordinateRegion region;
    region.center = centerCoordinate;

    // WGS84 values
    double a = 6378137;
    double f = f = 1.0 / 298.257223563;
    double e2 = f * (2 - f);
    double DEG2RAD = M_PI / 180.0;
    double RAD2DEG = 1 / DEG2RAD;
    double s = sin(centerCoordinate.latitude * DEG2RAD);
    double s2 = s * s;
    double R1 = a * (1 - e2) / pow((1 - e2 * s2), 1.5);
    double R2 = a / sqrt(1 - e2 * s2);

    region.span.latitudeDelta = RAD2DEG * latitudinalMeters / R1;
    region.span.longitudeDelta = RAD2DEG * longitudinalMeters / (R2 * cos(centerCoordinate.latitude * DEG2RAD));

    return region;
}

OSGridRect OSGridRectMake(OSGridDistance easting, OSGridDistance northing, OSGridDistance width, OSGridDistance height) {
    OSGridRect rect;
    rect.originSW.easting = easting;
    rect.originSW.northing = northing;
    rect.size.width = width;
    rect.size.height = height;
    return rect;
}

OSGridRect OSGridRectOffset(OSGridRect rect, OSGridDistance dx, OSGridDistance dy) {
    rect.originSW.easting += dx;
    rect.originSW.northing += dy;
    return rect;
}

OSGridRect OSGridRectInset(OSGridRect rect, OSGridDistance dx, OSGridDistance dy) {
    if (OSGridRectIsNull(rect)) {
        return rect;
    }

    rect.originSW.easting += dx;
    rect.originSW.northing += dy;
    rect.size.width -= 2 * dx;
    rect.size.height -= 2 * dy;
    if (rect.size.width <= 0 || rect.size.height <= 0) {
        return OSGridRectNull;
    }
    return rect;
}

OSGridRect OSGridRectUnion(OSGridRect rect1, OSGridRect rect2) {
    if (OSGridRectIsNull(rect1)) {
        return rect2;
    }
    if (OSGridRectIsNull(rect2)) {
        return rect2;
    }

    OSGridRect r = rect1;
    r.originSW.easting = fmin(rect1.originSW.easting, rect2.originSW.easting);
    r.originSW.northing = fmin(rect1.originSW.northing, rect2.originSW.northing);
    r.size.width = fmax(rect1.originSW.easting + rect1.size.width, rect2.originSW.easting + rect2.size.width) - r.originSW.easting;
    r.size.height = fmax(rect1.originSW.northing + rect1.size.height, rect2.originSW.northing + rect2.size.height) - r.originSW.northing;
    return r;
}

OSGridRect OSGridRectIntersection(OSGridRect rect1, OSGridRect rect2) {
    if (OSGridRectIsNull(rect1)) {
        return rect2;
    }
    if (OSGridRectIsNull(rect2)) {
        return rect2;
    }

    OSGridRect r = rect1;
    r.originSW.easting = fmax(rect1.originSW.easting, rect2.originSW.easting);
    r.originSW.northing = fmax(rect1.originSW.northing, rect2.originSW.northing);
    r.size.width = fmin(rect1.originSW.easting + rect1.size.width, rect2.originSW.easting + rect2.size.width) - r.originSW.easting;
    r.size.height = fmin(rect1.originSW.northing + rect1.size.height, rect2.originSW.northing + rect2.size.height) - r.originSW.northing;

    if (r.size.width <= 0 || r.size.height <= 0) {
        return OSGridRectNull;
    }

    return r;
}

OSGridRect OSGridRectForCoordinateRegion(OSCoordinateRegion region) {
    OSGridRect gridRect;

    // We preserve the center, the width and the height. The actual orientation of
    // the rectangle may rotate due to grid north not being the same as true north.

    // Ensure sane input
    double latitude = region.center.latitude;
    region.center.latitude = fmax(-90.0, fmin(latitude, 90.0));

    double latitudeDelta = region.span.latitudeDelta;

    latitudeDelta = fmax(0.0, latitudeDelta);
    latitudeDelta = fmin(latitudeDelta, 2.0 * (90.0 - latitude));
    latitudeDelta = fmin(latitudeDelta, 2.0 * (90.0 + latitude));
    region.span.latitudeDelta = latitudeDelta;

    double longitude = region.center.longitude;
    region.center.longitude = fmax(-180.0, fmin(longitude, 180));

    double longitudeDelta = region.span.longitudeDelta;
    longitudeDelta = fmax(-180.0, longitudeDelta);
    longitudeDelta = fmin(longitudeDelta, 2.0 * (180.0 - longitude));
    longitudeDelta = fmin(longitudeDelta, 2.0 * (180.0 + longitude));
    region.span.longitudeDelta = longitudeDelta;

    // Input now sanitised
    OSGridPoint center = OSGridPointForCoordinate(region.center);

    gridRect.size = OSGridSizeForRegion(region);

    OSGridPoint originSW = center;
    originSW.easting -= gridRect.size.width / 2;
    originSW.northing -= gridRect.size.height / 2;
    gridRect.originSW = originSW;

    /*
     Note that center.northing - gridRect.size.height / 2 +
     gridRect.size.height / 2 is not necessarily the same as
     center.northing. The accuracy of a float means we may end up
     rounding off when we calculate originSW, by up to 0.0625m.
     */
    return gridRect;
}

OSCoordinateRegion OSCoordinateRegionForGridRect(OSGridRect gridRect) {
    OSGridPoint center = OSGridRectGetCenter(gridRect);
    CLLocationCoordinate2D center2D = OSCoordinateForGridPoint(center);
    return OSCoordinateRegionMakeWithDistance(center2D, gridRect.size.height, gridRect.size.width);
}

NSString *NSStringFromOSGridPoint(OSGridPoint point, NSInteger digits) {
    int e = roundf(point.easting);
    int n = roundf(point.northing);
    if (digits < 0) {
        return [NSString stringWithFormat:@"%d,%d", e, n];
    }
    // We can actually handle negative E and N in the lettered case, but that's
    // more effort.
    if (e < 0 || n < 0) {
        return nil;
    }

    char buf[17];
    char *p = buf;

    // The following code doesn't correctly handle e<0 or n<0 due to problems with
    // / and %.
    int big = 500000;
    int small = big / 5;
    int firstdig = small / 10;

    int es = e / big;
    int ns = n / big;
    e = e % big;
    n = n % big;
    // move to the S square
    es += 2;
    ns += 1;
    if (es > 4 || ns > 4) {
        return nil;
    }
    *p++ = NATGRID_LETTERS[ns][es];

    es = e / small;
    ns = n / small;
    e = e % small;
    n = n % small;
    *p++ = NATGRID_LETTERS[ns][es];

    // Only add spaces if there are digits too. This lets us have "zero-figure"
    // grid references, e.g. "SK"
    if (digits) {
        *p++ = ' ';

        for (int dig = firstdig, i = 0; dig != 0 && i < digits; i++, dig /= 10) {
            *p++ = '0' + (e / dig % 10);
        }

        *p++ = ' ';

        for (int dig = firstdig, i = 0; dig != 0 && i < digits; i++, dig /= 10) {
            *p++ = '0' + (n / dig % 10);
        }
    }

    *p++ = 0;

    assert(p - buf <= sizeof(buf));

    return [NSString stringWithUTF8String:buf];
}

OSGridPoint OSGridPointFromString(NSString *gridRef, NSInteger *outDigits) {
    gridRef = [gridRef uppercaseString];
    gridRef = [gridRef stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([gridRef length] < 2) {
        return OSGridPointInvalid;
    }

    {
        NSScanner *scanner = [NSScanner scannerWithString:gridRef];
        float easting;
        float northing;
        bool success = true;
        success &= (bool)[scanner scanFloat:&easting];
        [scanner scanString:@"," intoString:NULL];
        success &= (bool)[scanner scanFloat:&northing];
        success &= (bool)[scanner isAtEnd];
        if (success) {
            if (*outDigits) {
                *outDigits = -1;
            }
            OSGridPoint point;
            point.easting = easting;
            point.northing = northing;
            return point;
        }
    }

    int big = 500000;
    int small = big / 5;

    // Read the first two digits, converting them into an easting and northing
    // "index".
    unichar c0 = [gridRef characterAtIndex:0];
    unichar c1 = [gridRef characterAtIndex:1];
    int e0 = -1, e1 = -1;
    int n0 = -1, n1 = -1;
    for (int n = 0; n < 5; n++) {
        for (int e = 0; e < 5; e++) {
            if (NATGRID_LETTERS[n][e] == c0) {
                // Offset relative to the S square. This means we immediately discard
                // coordinates south/west of S.
                e0 = e - 2;
                n0 = n - 1;
            }
            if (NATGRID_LETTERS[n][e] == c1) {
                e1 = e;
                n1 = n;
            }
        }
    }

    if (!(e0 >= 0 && e1 >= 0 && n0 >= 0 && n1 >= 0)) {
        return OSGridPointInvalid;
    }

    OSGridPoint p = {.easting = e0 * big + e1 * small, .northing = n0 * big + n1 * small};

    // If it's off the grid, we also want to reject it.
    // We also want to reject coordinates on 700000e or 1300000n, since those
    // would use grid letters off the map.
    // Use the contrapositive to ensure NAN-safety.
    if (!(p.easting < OSGridWidth && p.northing < OSGridHeight)) {
        return OSGridPointInvalid;
    }

    if ([gridRef length] <= 2) {
        // We'll fail to scan any digits below if there are no digits to scan, as
        // with the bare (digitless) "SV".
        // Handle it here.
        if (outDigits) {
            *outDigits = 0;
        }
        return p;
    }

    // Do not use [NSCharacterSet digitCharacterSet], which includes various
    // Unicode digits too.
    NSCharacterSet *asciiDigits = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];

    assert([gridRef length] >= 2);
    gridRef = [gridRef substringFromIndex:2];
    gridRef = [gridRef stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSScanner *scanner = [NSScanner scannerWithString:gridRef];
    NSString *__autoreleasing eastingDigits = nil;
    NSString *__autoreleasing northingDigits = nil;
    bool success = true;
    // We must scan some digits.
    success &= (bool)[scanner scanCharactersFromSet:asciiDigits intoString:&eastingDigits];
    // If the northing and easting are separated by a space, handle that too.
    [scanner scanCharactersFromSet:asciiDigits intoString:&northingDigits];
    // We should be at the end of the string.
    success &= (bool)[scanner isAtEnd];

    // We should be "successful". We should also have some digits.
    if (!success || !eastingDigits) {
        return OSGridPointInvalid;
    }

    NSUInteger ndigs = [eastingDigits length];

    // If we don't have separate northing digits, attempt to split the easting
    // digits in half.
    if (!northingDigits) {
        ndigs /= 2;
        northingDigits = [eastingDigits substringFromIndex:ndigs];
        eastingDigits = [eastingDigits substringToIndex:ndigs];
        // This should still be true.
        assert(ndigs == [eastingDigits length]);
    }

    // Handle an odd number of digits (NN123) or an inconsistent number of digits
    // (NN 12 3456).
    // Also handle too few digits (NN), which should be taken care of above, or
    // too many digits (NN 123456 123456).
    if (ndigs != [northingDigits length] || ndigs < 1 || ndigs > 5) {
        return OSGridPointInvalid;
    }

    p.easting += small / powf(10, ndigs) * [eastingDigits integerValue];
    p.northing += small / powf(10, ndigs) * [northingDigits integerValue];

    if (outDigits) {
        *outDigits = ndigs;
    }
    return p;
}
