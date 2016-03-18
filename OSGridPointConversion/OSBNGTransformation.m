//
//  OSBNGTransformation.m
//  OSGridPointConversion
//
//  Created by Dave Hardiman on 12/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import "OSBNGTransformation.h"

@implementation OSBNGTransformation

+ (NSString *)proj4String {
    NSString *gridShiftFilePath = [[NSBundle bundleForClass:self] pathForResource:@"OSTN02_NTv2" ofType:@"gsb"];
    return [NSString stringWithFormat:@"+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +nadgrids=%@ +units=m +no_defs", gridShiftFilePath];
}

+ (NSString *)sevenPointProj4String {
    return @"+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs";
}

@end
