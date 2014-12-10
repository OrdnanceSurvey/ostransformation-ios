//
//  RMProjection.m
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

#import "RMGlobalConstants.h"
#import "proj_api.h"
#import "RMProjection.h"

@implementation RMProjection {
    // The internal projection that has been setup
    projPJ _internalProjection;

    // The size of the earth, in projected units (meters, most often)
    RMProjectedRect _planetBounds;

    // Hardcoded to YES in #initWithString:InBounds:
    bool _projectionWrapsHorizontally : 1;
    bool _latLngIsWGS84 : 1;
}

- (id)initWithString:(NSString *)proj4String inBounds:(RMProjectedRect)projectedBounds {
    if (!(self = [super init]))
        return nil;

    _internalProjection = pj_init_plus([proj4String UTF8String]);

    if (_internalProjection == NULL) {
        NSLog(@"Unhandled error creating projection. String is %@", proj4String);
        return nil;
    }

    _planetBounds = projectedBounds;
    _projectionWrapsHorizontally = YES;

    return self;
}

- (id)initWithString:(NSString *)proj4String {
    RMProjectedRect theBounds;
    theBounds = RMProjectedRectMake(0, 0, 0, 0);

    return [self initWithString:proj4String inBounds:theBounds];
}

- (id)init {
    return [self initWithString:@"+proj=latlong +ellps=WGS84"];
}

- (void)dealloc {
    if (self.internalProjection) {
        pj_free(self.internalProjection);
    }
}

- (RMProjectedPoint)wrapPointHorizontally:(RMProjectedPoint)aPoint {
    if (!self.projectionWrapsHorizontally || self.planetBounds.size.width == 0.0f || self.planetBounds.size.height == 0.0f)
        return aPoint;

    while (aPoint.x < self.planetBounds.origin.x)
        aPoint.x += self.planetBounds.size.width;

    while (aPoint.x > (self.planetBounds.origin.x + self.planetBounds.size.width))
        aPoint.x -= self.planetBounds.size.width;

    return aPoint;
}

- (RMProjectedPoint)constrainPointToBounds:(RMProjectedPoint)aPoint {
    if (self.planetBounds.size.width == 0.0f || self.planetBounds.size.height == 0.0f)
        return aPoint;

    [self wrapPointHorizontally:aPoint];

    if (aPoint.y < self.planetBounds.origin.y)
        aPoint.y = self.planetBounds.origin.y;
    else if (aPoint.y > (self.planetBounds.origin.y + self.planetBounds.size.height))
        aPoint.y = self.planetBounds.origin.y + self.planetBounds.size.height;

    return aPoint;
}

- (RMProjectedPoint)coordinateToProjectedPoint:(CLLocationCoordinate2D)aLatLong {
    projUV uv = {aLatLong.longitude * DEG_TO_RAD, aLatLong.latitude * DEG_TO_RAD};

    projUV result;
    if (self.latLngIsWGS84) {
        result = pj_fwd(uv, _internalProjection);
    } else {
        pj_transform([[self class] WGS84LatLong]->_internalProjection, self.internalProjection, 1, 1, &(uv.u), &(uv.v), NULL);
        result = uv;
    }

    RMProjectedPoint result_point = {
        result.u, result.v,
    };

    return result_point;
}

- (CLLocationCoordinate2D)projectedPointToCoordinate:(RMProjectedPoint)aPoint {
    projUV uv = {
        aPoint.x, aPoint.y,
    };

    projUV result;
    if (self.latLngIsWGS84) {
        result = pj_inv(uv, self.internalProjection);
    } else {
        pj_transform(_internalProjection, [[self class] WGS84LatLong]->_internalProjection, 1, 1, &(uv.u), &(uv.v), NULL);
        result = uv;
    }

    CLLocationCoordinate2D result_coordinate = {
        result.v * RAD_TO_DEG, result.u * RAD_TO_DEG,
    };

    return result_coordinate;
}

+ (RMProjection *)googleProjection {
    assert([NSThread isMainThread]);
    static RMProjection *_googleProjection = nil;

    if (_googleProjection) {
        return _googleProjection;
    } else {
        RMProjectedRect theBounds = RMProjectedRectMake(-20037508.34, -20037508.34, 20037508.34 * 2, 20037508.34 * 2);

        _googleProjection =
            [[RMProjection alloc] initWithString:@"+title= Google Mercator EPSG:900913 +proj=merc " @"+a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 "
                                  @"+x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null " @"+datum=WGS84 +no_defs"
                                        inBounds:theBounds];
        return _googleProjection;
    }
}

+ (RMProjection *)WGS84LatLong {
    static RMProjection *_latitudeLongitudeProjection;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RMProjectedRect theBounds = RMProjectedRectMake(-kMaxLong, -kMaxLat, 360.0, kMaxLong);

        _latitudeLongitudeProjection = [[RMProjection alloc] initWithString:@"+proj=latlong +ellps=WGS84 +datum=WGS84" inBounds:theBounds];
    });

    return _latitudeLongitudeProjection;
}

+ (RMProjection *)OSGB36NationalGrid {
    static RMProjection *proj;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // These bounds correspond to area covered by the OV0/OV1/OV2 map
        // tilesets.
        RMProjectedRect bounds = {{0, 0}, {700000, 1300000}};
        proj = [[RMProjection alloc]
            initWithString:@"+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 " @"+x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 " @"+units=m +no_defs"
                  inBounds:bounds];
    });

    return proj;
}

@end
