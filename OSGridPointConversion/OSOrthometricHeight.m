//
//  OSOrthometricHeight.m
//  OSGridPointConversion
//
//  Created by Dave Hardiman on 03/06/2015.
//  Copyright (c) 2015 Ordnance Survey. All rights reserved.
//

#import "OSOrthometricHeight.h"
#import "OSRMProjection.h"

typedef struct {
    int etrs89Easting;
    int etrs89Northing;
    float geoidUndulation;
} _OSGM02Record;

_OSGM02Record _OSGM02RecordAtIndex(NSUInteger index) {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:[[NSBundle bundleForClass:OSRMProjection.class] pathForResource:@"OSGM02" ofType:nil]];
    NSInteger location = sizeof(_OSGM02Record) * index;
    [handle seekToFileOffset:location];
    NSData *recordData = [handle readDataOfLength:sizeof(_OSGM02Record)];
    [handle closeFile];
    _OSGM02Record record;
    [recordData getBytes:&record length:sizeof(_OSGM02Record)];
    return record;
}

_OSGM02Record _OSGM02RecordForPoint(OSRMProjectedPoint point) {
    NSInteger eastIndex = (int)(point.x / 1000);
    NSInteger northIndex = (int)(point.y / 1000);
    NSInteger recordIndex = eastIndex + (northIndex * 701);
    return _OSGM02RecordAtIndex(recordIndex);
}

CLLocationDistance OSOrthomtricHeightForLocation(CLLocation *location) {
    OSRMProjectedRect theBounds = OSRMProjectedRectMake(-180.0, -90, 360.0, 180.0);
    OSRMProjection *proj = [[OSRMProjection alloc] initWithString:@"+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=GRS80" inBounds:theBounds];
    OSRMProjectedPoint point = [proj coordinateToProjectedPoint:location.coordinate];
    NSInteger eastIndex0 = (int)(point.x / 1000);
    NSInteger northIndex0 = (int)(point.y / 1000);
    double x0 = eastIndex0 * 1000;
    double y0 = northIndex0 * 1000;
    OSRMProjectedPoint point0 = OSRMProjectedPointMake(x0, y0);
    _OSGM02Record record0 = _OSGM02RecordForPoint(point0);
    _OSGM02Record record1 = _OSGM02RecordForPoint(OSRMProjectedPointMake(point.x + 1, point.y));
    _OSGM02Record record2 = _OSGM02RecordForPoint(OSRMProjectedPointMake(point.x + 1, point.y + 1));
    _OSGM02Record record3 = _OSGM02RecordForPoint(OSRMProjectedPointMake(point.x, point.y + 1));

    double dx = point.x - x0;
    double dy = point.y - y0;
    double t = dx / 1000;
    double u = dy / 1000;
    double shiftGeoid = ((1 - t) * (1 - u) * record0.geoidUndulation) + (t * (1 - u) * record1.geoidUndulation) + (t * u * record2.geoidUndulation) + ((1 - t) * u * record3.geoidUndulation);
    return location.altitude - shiftGeoid;
}
