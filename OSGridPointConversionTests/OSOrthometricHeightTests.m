//
//  OSOrthometricHeightTests.m
//  OSGridPointConversion
//
//  Created by Dave Hardiman on 04/06/2015.
//  Copyright (c) 2015 Ordnance Survey. All rights reserved.
//

@import XCTest;
@import CoreLocation;
@import OSGridPointConversion;

@interface OSOrthometricHeightTestCase : NSObject
@property (nonatomic, copy) NSString *stationName;
@property (nonatomic, strong) CLLocation *inputLocation;
@property (nonatomic, assign) CLLocationDistance expectedHeight;

+ (instancetype)testCaseWithStationName:(NSString *)stationName
                                  latNS:(NSString *)latNS
                                 latDeg:(NSInteger)latDeg
                                 latMin:(NSInteger)latMin
                                 latSec:(double)latSec
                                  lonEW:(NSString *)lonEW
                                 lonDeg:(NSInteger)lonDeg
                                 lonMin:(NSInteger)lonMin
                                 lonSec:(double)lonSec
                           etrs89Height:(double)etrs89Height
                              odnHeight:(double)odnHeight;

@end

@interface OSOrthometricHeightTests : XCTestCase
@property (nonatomic, strong) NSArray *testData;
@end

@implementation OSOrthometricHeightTests

- (NSArray *)testData {
    if (!_testData) {
        NSMutableArray *testData = NSMutableArray.array;

        NSString *testCSV = [NSString stringWithContentsOfURL:[[NSBundle bundleForClass:self.class] URLForResource:@"OSTN02_OSGM02Tests_Out" withExtension:@"csv"] encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [testCSV componentsSeparatedByString:@"\r\n"];
        [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
            if (idx == 0 || idx == lines.count - 1) {
                return;
            }
            NSArray *columns = [line componentsSeparatedByString:@","];
            double testCaseHeight = columns.count == 27 ? [columns[25] doubleValue] : OSOrthometricHeightError; // We have two points outside of the data set, so they should return an error
            OSOrthometricHeightTestCase *testCase = [OSOrthometricHeightTestCase testCaseWithStationName:columns[0] latNS:columns[4] latDeg:[columns[5] integerValue] latMin:[columns[6] integerValue] latSec:[columns[7] doubleValue] lonEW:columns[8] lonDeg:[columns[9] integerValue] lonMin:[columns[10] integerValue] lonSec:[columns[11] doubleValue] etrs89Height:[columns[12] doubleValue] odnHeight:testCaseHeight];
            [testData addObject:testCase];
        }];

        _testData = testData.copy;
    }
    return _testData;
}

- (void)testConversionFromEtrs89HeightToOrthometricHeight {
    [self.testData enumerateObjectsUsingBlock:^(OSOrthometricHeightTestCase *testCase, NSUInteger idx, BOOL *stop) {
        CLLocationDistance orthometricHeight = OSOrthomtricHeightForLocation(testCase.inputLocation);
        XCTAssertEqualWithAccuracy(orthometricHeight, testCase.expectedHeight, 0.001, @"%@", testCase.stationName);
    }];
}

@end

@implementation OSOrthometricHeightTestCase

+ (instancetype)testCaseWithStationName:(NSString *)stationName latNS:(NSString *)latNS latDeg:(NSInteger)latDeg latMin:(NSInteger)latMin latSec:(double)latSec lonEW:(NSString *)lonEW lonDeg:(NSInteger)lonDeg lonMin:(NSInteger)lonMin lonSec:(double)lonSec etrs89Height:(double)etrs89Height odnHeight:(double)odnHeight {
    OSOrthometricHeightTestCase *testCase = [[OSOrthometricHeightTestCase alloc] init];
    testCase.stationName = stationName;

    CLLocationDegrees lat = [self degreesForLatNS:latNS latDeg:latDeg latMin:latMin latSec:latSec];
    CLLocationDegrees lon = [self degreesForLonEW:lonEW lonDeg:lonDeg lonMin:lonMin lonSec:lonSec];

    testCase.inputLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:etrs89Height horizontalAccuracy:0.0 verticalAccuracy:0.0 timestamp:NSDate.date];
    testCase.expectedHeight = odnHeight;
    return testCase;
}

+ (CLLocationDegrees)degreesForLatNS:(NSString *)latNS latDeg:(NSInteger)latDeg latMin:(NSInteger)latMin latSec:(double)latSec {
    CLLocationDegrees degrees = [self degreesForDeg:latDeg min:latMin sec:latSec];
    return [latNS isEqualToString:@"S"] ? -1 * degrees : degrees;
}

+ (CLLocationDegrees)degreesForLonEW:(NSString *)lonEW lonDeg:(NSInteger)lonDeg lonMin:(NSInteger)lonMin lonSec:(double)lonSec {
    CLLocationDegrees degrees = [self degreesForDeg:lonDeg min:lonMin sec:lonSec];
    return [lonEW isEqualToString:@"W"] ? -1 * degrees : degrees;
}

double const OSDMSConverterMinutesPerDegree = 60.0;
double const OSDMSConverterSecondsPerMinute = 60.0;
double const OSDMSConverterSecondsPerDegree = 3600.0;

+ (CLLocationDegrees)degreesForDeg:(NSInteger)degrees min:(NSInteger)minutes sec:(double)seconds {
    double result = (degrees * OSDMSConverterSecondsPerDegree) + (minutes * OSDMSConverterMinutesPerDegree) + seconds;
    result /= OSDMSConverterSecondsPerDegree;
    return result;
}

@end
