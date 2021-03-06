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
#import "OSRMProjection.h"
#import "OSGridPoint.h"
#import "OSBNGTransformation.h"

@implementation OSRMProjection {
    projCtx _projContext;
    // The internal projection that has been setup
    projPJ _internalProjection;

    // The size of the earth, in projected units (meters, most often)
    OSRMProjectedRect _planetBounds;

    // Hardcoded to YES in #initWithString:InBounds:
    bool _projectionWrapsHorizontally : 1;
    bool _latLngIsWGS84 : 1;
}

- (id)initWithString:(NSString *)proj4String inBounds:(OSRMProjectedRect)projectedBounds {
    if (!(self = [super init]))
        return nil;

    _projContext = pj_ctx_alloc();
    _internalProjection = pj_init_plus_ctx(_projContext, [proj4String UTF8String]);

    if (_internalProjection == NULL) {
        NSLog(@"Unhandled error creating projection. String is %@", proj4String);
        return nil;
    }

    _planetBounds = projectedBounds;
    _projectionWrapsHorizontally = YES;

    return self;
}

- (id)initWithString:(NSString *)proj4String {
    OSRMProjectedRect theBounds;
    theBounds = OSRMProjectedRectMake(0, 0, 0, 0);

    return [self initWithString:proj4String inBounds:theBounds];
}

- (id)init {
    return [self initWithString:@"+proj=latlong +ellps=WGS84"];
}

- (void)dealloc {
    if (self.internalProjection) {
        pj_free(self.internalProjection);
    }
    if (_projContext) {
        pj_ctx_free(_projContext);
    }
}

- (OSRMProjectedPoint)wrapPointHorizontally:(OSRMProjectedPoint)aPoint {
    if (!self.projectionWrapsHorizontally || self.planetBounds.size.width == 0.0f || self.planetBounds.size.height == 0.0f)
        return aPoint;

    while (aPoint.x < self.planetBounds.origin.x)
        aPoint.x += self.planetBounds.size.width;

    while (aPoint.x > (self.planetBounds.origin.x + self.planetBounds.size.width))
        aPoint.x -= self.planetBounds.size.width;

    return aPoint;
}

- (OSRMProjectedPoint)constrainPointToBounds:(OSRMProjectedPoint)aPoint {
    if (self.planetBounds.size.width == 0.0f || self.planetBounds.size.height == 0.0f)
        return aPoint;

    [self wrapPointHorizontally:aPoint];

    if (aPoint.y < self.planetBounds.origin.y)
        aPoint.y = self.planetBounds.origin.y;
    else if (aPoint.y > (self.planetBounds.origin.y + self.planetBounds.size.height))
        aPoint.y = self.planetBounds.origin.y + self.planetBounds.size.height;

    return aPoint;
}

- (OSRMProjectedPoint)coordinateToProjectedPoint:(CLLocationCoordinate2D)aLatLong {
    projUV uv = {aLatLong.longitude * DEG_TO_RAD, aLatLong.latitude * DEG_TO_RAD};
    int projErrorCode = 0;
    projUV result;
    @synchronized(self) {
        if (self.latLngIsWGS84) {
            result = pj_fwd(uv, _internalProjection);
        } else {
            projErrorCode = pj_transform([[self class] WGS84LatLong]->_internalProjection, self.internalProjection, 1, 1, &(uv.u), &(uv.v), NULL);
            if (projErrorCode != 0) {
                NSLog(@"Proj4 error: %s", pj_strerrno(projErrorCode));
            }
            result = uv;
        }
    }

    OSRMProjectedPoint result_point = {
        result.u, result.v,
    };

    return result_point;
}

- (CLLocationCoordinate2D)projectedPointToCoordinate:(OSRMProjectedPoint)aPoint {
    projUV uv = {
        aPoint.x, aPoint.y,
    };

    int projErrorCode = 0;
    projUV result;
    @synchronized(self) {
        if (self.latLngIsWGS84) {
            result = pj_inv(uv, self.internalProjection);
        } else {
            projErrorCode = pj_transform(_internalProjection, [[self class] WGS84LatLong]->_internalProjection, 1, 1, &(uv.u), &(uv.v), NULL);
            if (projErrorCode != 0) {
                NSLog(@"Proj4 error: %s", pj_strerrno(projErrorCode));
            }
            result = uv;
        }
    }

    CLLocationCoordinate2D result_coordinate = {
        result.v * RAD_TO_DEG, result.u * RAD_TO_DEG,
    };

    return result_coordinate;
}

+ (OSRMProjection *)googleProjection {
    assert([NSThread isMainThread]);
    static OSRMProjection *_googleProjection = nil;

    if (_googleProjection) {
        return _googleProjection;
    } else {
        OSRMProjectedRect theBounds = OSRMProjectedRectMake(-20037508.34, -20037508.34, 20037508.34 * 2, 20037508.34 * 2);

        _googleProjection =
            [[OSRMProjection alloc] initWithString:@"+title= Google Mercator EPSG:900913 +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs"
                                          inBounds:theBounds];
        return _googleProjection;
    }
}

+ (OSRMProjection *)WGS84LatLong {
    static OSRMProjection *_latitudeLongitudeProjection;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OSRMProjectedRect theBounds = OSRMProjectedRectMake(-kMaxLong, -kMaxLat, 360.0, kMaxLong);

        _latitudeLongitudeProjection = [[OSRMProjection alloc] initWithString:@"+proj=latlong +ellps=WGS84 +datum=WGS84" inBounds:theBounds];
    });

    return _latitudeLongitudeProjection;
}

+ (OSRMProjection *)OSGB36NationalGrid {
    static OSRMProjection *proj;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OSRMProjectedRect bounds = {{0, 0}, {OSGridWidth, OSGridHeight}};
        proj = [[OSRMProjection alloc] initWithString:OSBNGTransformation.proj4String
                                             inBounds:bounds];
    });

    return proj;
}

+ (OSRMProjection *)OSGB36NationalGridSevenParam {
    static OSRMProjection *proj;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OSRMProjectedRect bounds = {{0, 0}, {OSGridWidth, OSGridHeight}};
        proj = [[OSRMProjection alloc] initWithString:OSBNGTransformation.sevenParamProj4String
                                             inBounds:bounds];
    });

    return proj;
}

@end
