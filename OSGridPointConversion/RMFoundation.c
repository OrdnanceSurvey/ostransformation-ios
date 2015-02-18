//
//  RMFoundation.c
//
// Copyright (c) 2008-2012, Route-Me Contributors
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "RMFoundation.h"
#import <math.h>
#import <stdio.h>

bool OSRMProjectedPointEqualToProjectedPoint(OSRMProjectedPoint point1, OSRMProjectedPoint point2) {
    return point1.x == point2.x && point2.y == point2.y;
}

bool OSRMProjectedRectIntersectsProjectedRect(OSRMProjectedRect rect1, OSRMProjectedRect rect2) {
    double minX1 = rect1.origin.x;
    double maxX1 = rect1.origin.x + rect1.size.width;
    double minY1 = rect1.origin.y;
    double maxY1 = rect1.origin.y + rect1.size.height;

    double minX2 = rect2.origin.x;
    double maxX2 = rect2.origin.x + rect2.size.width;
    double minY2 = rect2.origin.y;
    double maxY2 = rect2.origin.y + rect2.size.height;

    return ((minX1 <= minX2 && minX2 <= maxX1) || (minX2 <= minX1 && minX1 <= maxX2)) &&
           ((minY1 <= minY2 && minY2 <= maxY1) || (minY2 <= minY1 && minY1 <= maxY2));
}

bool OSRMProjectedRectContainsProjectedRect(OSRMProjectedRect rect1, OSRMProjectedRect rect2) {
    double minX1 = rect1.origin.x;
    double maxX1 = rect1.origin.x + rect1.size.width;
    double minY1 = rect1.origin.y;
    double maxY1 = rect1.origin.y + rect1.size.height;

    double minX2 = rect2.origin.x;
    double maxX2 = rect2.origin.x + rect2.size.width;
    double minY2 = rect2.origin.y;
    double maxY2 = rect2.origin.y + rect2.size.height;

    return ((minX2 >= minX1 && maxX2 <= maxX1) && (minY2 >= minY1 && maxY2 <= maxY1));
}

bool OSRMProjectedRectContainsProjectedPoint(OSRMProjectedRect rect, OSRMProjectedPoint point) {
    if (rect.origin.x > point.x || rect.origin.x + rect.size.width < point.x || rect.origin.y > point.y || rect.origin.y + rect.size.height < point.y) {
        return false;
    }

    return true;
}

bool OSRMProjectedSizeContainsProjectedSize(OSRMProjectedSize size1, OSRMProjectedSize size2) {
    return (size1.width >= size2.width && size1.height >= size2.height);
}

OSRMProjectedPoint OSRMScaleProjectedPointAboutPoint(OSRMProjectedPoint point, float factor, OSRMProjectedPoint pivot) {
    point.x = (point.x - pivot.x) * factor + pivot.x;
    point.y = (point.y - pivot.y) * factor + pivot.y;

    return point;
}

OSRMProjectedRect OSRMScaleProjectedRectAboutPoint(OSRMProjectedRect rect, float factor, OSRMProjectedPoint pivot) {
    rect.origin = OSRMScaleProjectedPointAboutPoint(rect.origin, factor, pivot);
    rect.size.width *= factor;
    rect.size.height *= factor;

    return rect;
}

OSRMProjectedPoint OSRMTranslateProjectedPointBy(OSRMProjectedPoint point, OSRMProjectedSize delta) {
    point.x += delta.width;
    point.y += delta.height;

    return point;
}

OSRMProjectedRect OSRMTranslateProjectedRectBy(OSRMProjectedRect rect, OSRMProjectedSize delta) {
    rect.origin = OSRMTranslateProjectedPointBy(rect.origin, delta);

    return rect;
}

OSRMProjectedPoint OSRMProjectedPointMake(double x, double y) {
    OSRMProjectedPoint point = {x, y};

    return point;
}

OSRMProjectedRect OSRMProjectedRectMake(double x, double y, double width, double height) {
    OSRMProjectedRect rect = {{x, y}, {width, height}};

    return rect;
}

OSRMProjectedSize OSRMProjectedSizeMake(double width, double heigth) {
    OSRMProjectedSize size = {width, heigth};

    return size;
}

OSRMProjectedRect OSRMProjectedRectZero() {
    return OSRMProjectedRectMake(0.0, 0.0, 0.0, 0.0);
}

bool OSRMProjectedRectIsZero(OSRMProjectedRect rect) {
    return (rect.origin.x == 0.0) && (rect.origin.y == 0.0) && (rect.size.width == 0.0) && (rect.size.height == 0.0);
}

#if !defined(RMMIN)
#define RMMIN(a, b) ((a) < (b) ? (a) : (b))
#endif

#if !defined(RMMAX)
#define RMMAX(a, b) ((a) > (b) ? (a) : (b))
#endif

OSRMProjectedRect OSRMProjectedRectUnion(OSRMProjectedRect rect1, OSRMProjectedRect rect2) {
    bool rect1IsZero = OSRMProjectedRectIsZero(rect1);
    bool rect2IsZero = OSRMProjectedRectIsZero(rect2);

    if (rect1IsZero)
        return (rect2IsZero ? OSRMProjectedRectZero() : rect2);

    if (rect2IsZero)
        return rect1;

    double minX = RMMIN(rect1.origin.x, rect2.origin.x);
    double minY = RMMIN(rect1.origin.y, rect2.origin.y);
    double maxX = RMMAX(rect1.origin.x + rect1.size.width, rect2.origin.x + rect2.size.width);
    double maxY = RMMAX(rect1.origin.y + rect2.size.height, rect2.origin.y + rect2.size.height);

    return OSRMProjectedRectMake(minX, minY, maxX - minX, maxY - minY);
}

// apparently, this doesn't work well with coordinates on a sphere, but it might
// be appropriate for a quick estimation
double OSRMEuclideanDistanceBetweenProjectedPoints(OSRMProjectedPoint point1, OSRMProjectedPoint point2) {
    double xd = point2.x - point1.x;
    double yd = point2.y - point1.y;

    return sqrt(xd * xd + yd * yd);
}

#pragma mark -

void OSRMLogProjectedPoint(OSRMProjectedPoint point) {
    printf("ProjectedPoint at (%.0f,%.0f)\n", point.x, point.y);
}

void OSRMLogProjectedRect(OSRMProjectedRect rect) {
    printf("ProjectedRect at (%.0f,%.0f), size (%.0f,%.0f)\n", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}
