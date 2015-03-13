//
//  RMFoundation.h
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

#ifndef _OSRMFOUNDATION_H_
#define _OSRMFOUNDATION_H_

#include <stdbool.h>

#if __OBJC__
#import <CoreLocation/CoreLocation.h>
#endif

/*! \struct RMProjectedPoint
 \brief coordinates, in projected meters, paralleling CGPoint */
typedef struct { double x, y; } OSRMProjectedPoint;

/*! \struct RMProjectedSize
 \brief width/height struct, in projected meters, paralleling CGSize */
typedef struct { double width, height; } OSRMProjectedSize;

/*! \struct RMProjectedRect
 \brief location and size, in projected meters, paralleling CGRect */
typedef struct {
    OSRMProjectedPoint origin;
    OSRMProjectedSize size;
} OSRMProjectedRect;

#if __OBJC__
/*! \struct RMSphericalTrapezium
 \brief a rectangle, specified by two corner coordinates */
typedef struct {
    CLLocationCoordinate2D southWest;
    CLLocationCoordinate2D northEast;
} OSRMSphericalTrapezium;
#endif

#pragma mark -

OSRMProjectedPoint OSRMScaleProjectedPointAboutPoint(OSRMProjectedPoint point, float factor, OSRMProjectedPoint pivot);
OSRMProjectedRect OSRMScaleProjectedRectAboutPoint(OSRMProjectedRect rect, float factor, OSRMProjectedPoint pivot);
OSRMProjectedPoint OSRMTranslateProjectedPointBy(OSRMProjectedPoint point, OSRMProjectedSize delta);
OSRMProjectedRect OSRMTranslateProjectedRectBy(OSRMProjectedRect rect, OSRMProjectedSize delta);

#pragma mark -

bool OSRMProjectedPointEqualToProjectedPoint(OSRMProjectedPoint point1, OSRMProjectedPoint point2);

bool OSRMProjectedRectIntersectsProjectedRect(OSRMProjectedRect rect1, OSRMProjectedRect rect2);
bool OSRMProjectedRectContainsProjectedRect(OSRMProjectedRect rect1, OSRMProjectedRect rect2);
bool OSRMProjectedRectContainsProjectedPoint(OSRMProjectedRect rect, OSRMProjectedPoint point);

bool OSRMProjectedSizeContainsProjectedSize(OSRMProjectedSize size1, OSRMProjectedSize size2);

#pragma mark -

// Union of two rectangles
OSRMProjectedRect OSRMProjectedRectUnion(OSRMProjectedRect rect1, OSRMProjectedRect rect2);

OSRMProjectedPoint OSRMProjectedPointMake(double x, double y);
OSRMProjectedRect OSRMProjectedRectMake(double x, double y, double width, double height);
OSRMProjectedSize OSRMProjectedSizeMake(double width, double heigth);

OSRMProjectedRect OSRMProjectedRectZero();
bool OSRMProjectedRectIsZero(OSRMProjectedRect rect);

#pragma mark -

double OSRMEuclideanDistanceBetweenProjectedPoints(OSRMProjectedPoint point1, OSRMProjectedPoint point2);

#pragma mark -

void OSRMLogProjectedPoint(OSRMProjectedPoint point);
void OSRMLogProjectedRect(OSRMProjectedRect rect);

#endif
