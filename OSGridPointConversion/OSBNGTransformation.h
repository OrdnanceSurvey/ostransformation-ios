//
//  OSBNGTransformation.h
//  OSGridPointConversion
//
//  Created by Dave Hardiman on 12/01/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Utilities for converting to BNG coordinates
 */
@interface OSBNGTransformation : NSObject

/**
 *  Returns the proj 4 string to use for converting to BNG
 */
+ (NSString *)proj4String;

@end
