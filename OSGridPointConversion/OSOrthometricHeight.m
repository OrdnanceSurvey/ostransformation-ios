//
//  OSOrthometricHeight.m
//  OSGridPointConversion
//
//  Created by Dave Hardiman on 03/06/2015.
//  Copyright (c) 2015 Ordnance Survey. All rights reserved.
//

#import "OSOrthometricHeight.h"
#import "OSRMProjection.h"

CLLocationDistance const OSOrthometricHeightError = DBL_MIN;

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

const double OSGM02CellSize = 1000;

_OSGM02Record _OSGM02RecordForPoint(OSRMProjectedPoint point) {
    /*
     See pg13 of transformation user guide pdf in this repository
     To find the record number corresponding to a given ETRS89 easting and northing, use the following algorithm:
     east_index = north_index = record_number =
     integer_part_of (easting/1,000) integer_part_of (northing/1,000) east_index + (north_index x 701) + 1
     */
    NSInteger eastIndex = (NSInteger)(point.x / OSGM02CellSize);
    NSInteger northIndex = (NSInteger)(point.y / OSGM02CellSize);
    NSInteger recordIndex = eastIndex + (northIndex * 701);
    return _OSGM02RecordAtIndex(recordIndex);
}

CLLocationDistance OSOrthomtricHeightForLocation(CLLocation *location) {
    OSRMProjectedRect theBounds = OSRMProjectedRectMake(-180.0, -90, 360.0, 180.0);
    /*
     +proj = transverse mercator projection
     +lat_0/+lon_0 = True origin
     +k = Scale factor on central meridian
     +x_0/+y_0 = Map coordinates of true origin
     +ellps = WGS84 ellipse
     Values obtained from pg23 of Transformation user guide pdf in this repository
     */
    OSRMProjection *proj = [[OSRMProjection alloc] initWithString:@"+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=WGS84" inBounds:theBounds];
    OSRMProjectedPoint point = [proj coordinateToProjectedPoint:location.coordinate];
    NSInteger eastIndex0 = (NSInteger)(point.x / OSGM02CellSize);
    NSInteger northIndex0 = (NSInteger)(point.y / OSGM02CellSize);
    double x0 = eastIndex0 * OSGM02CellSize;
    double y0 = northIndex0 * OSGM02CellSize;
    OSRMProjectedPoint point0 = OSRMProjectedPointMake(x0, y0);
    _OSGM02Record record0 = _OSGM02RecordForPoint(point0);
    _OSGM02Record record1 = _OSGM02RecordForPoint(OSRMProjectedPointMake(point.x + OSGM02CellSize, point.y));
    _OSGM02Record record2 = _OSGM02RecordForPoint(OSRMProjectedPointMake(point.x + OSGM02CellSize, point.y + OSGM02CellSize));
    _OSGM02Record record3 = _OSGM02RecordForPoint(OSRMProjectedPointMake(point.x, point.y + OSGM02CellSize));

    if (record0.geoidUndulation == 0 || record1.geoidUndulation == 0 || record2.geoidUndulation == 0 || record3.geoidUndulation == 0) {
        return OSOrthometricHeightError;
    }

    double dx = point.x - x0;
    double dy = point.y - y0;
    double t = dx / OSGM02CellSize;
    double u = dy / OSGM02CellSize;
    double shiftGeoid = ((1 - t) * (1 - u) * record0.geoidUndulation) + (t * (1 - u) * record1.geoidUndulation) + (t * u * record2.geoidUndulation) + ((1 - t) * u * record3.geoidUndulation);
    return location.altitude - shiftGeoid;
}
