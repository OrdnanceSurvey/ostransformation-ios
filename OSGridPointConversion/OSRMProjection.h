//
//  RMProjection.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "OSRMFoundation.h"

// Objective-C wrapper for PROJ4 map projection definitions.
@interface OSRMProjection : NSObject

@property (nonatomic, readonly) void *internalProjection;
@property (nonatomic, readonly) OSRMProjectedRect planetBounds;
@property (nonatomic, assign) bool projectionWrapsHorizontally;
@property (nonatomic, assign) bool latLngIsWGS84;

// If #projectionWrapsHorizontally, returns #aPoint with its easting adjusted
// modulo Earth's diameter to be within projection's planetBounds. if
// !#projectionWrapsHorizontally, returns #aPoint unchanged.
- (OSRMProjectedPoint)wrapPointHorizontally:(OSRMProjectedPoint)aPoint;

// applies #wrapPointHorizontally to aPoint, and then clamps northing (Y
// coordinate) to projection's planetBounds
- (OSRMProjectedPoint)constrainPointToBounds:(OSRMProjectedPoint)aPoint;

+ (OSRMProjection *)googleProjection;
+ (OSRMProjection *)WGS84LatLong;
+ (OSRMProjection *)OSGB36NationalGrid; // Uses OSTN02
+ (OSRMProjection *)OSGB36NationalGridSevenParam; // Uses standard proj4 string

- (id)initWithString:(NSString *)proj4String inBounds:(OSRMProjectedRect)projectedBounds;

// inverse project meters, return latitude/longitude
- (CLLocationCoordinate2D)projectedPointToCoordinate:(OSRMProjectedPoint)aPoint;

// forward project latitude/longitude, return meters
- (OSRMProjectedPoint)coordinateToProjectedPoint:(CLLocationCoordinate2D)aLatLong;

@end
