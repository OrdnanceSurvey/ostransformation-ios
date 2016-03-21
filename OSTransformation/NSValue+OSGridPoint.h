//
//  NSValue+OSGridPoint.h
//  OSTransformation
//
//  Created by Shrikantreddy Tekale on 15/01/2015.
//  Copyright (c) 2015 Ordnance Survey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSGridPoint.h"

@interface NSValue (OSGridPoint)

/**
 *  Wraps an OSGridPoint in an NSValue for use in arrays.
 *
 *  @param gridPoint The grid point to wrap
 *
 *  @return An NSValue wrapping the grid point
 */
+ (instancetype)valueWithGridPoint:(OSGridPoint)gridPoint;

/**
 *  The wrapped grid point
 */
@property (nonatomic, readonly) OSGridPoint gridPointValue;

@end
