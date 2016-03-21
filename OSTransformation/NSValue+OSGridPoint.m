//
//  NSValue+OSGridPoint.m
//  OSTransformation
//
//  Created by Shrikantreddy Tekale on 15/01/2015.
//  Copyright (c) 2015 Ordnance Survey. All rights reserved.
//

#import "NSValue+OSGridPoint.h"

@implementation NSValue (OSGridPoint)

+ (instancetype)valueWithGridPoint:(OSGridPoint)gridPoint {
    return [NSValue value:&gridPoint withObjCType:@encode(OSGridPoint)];
}

- (OSGridPoint)gridPointValue {
    OSGridPoint point;
    [self getValue:&point];
    return point;
}

@end
