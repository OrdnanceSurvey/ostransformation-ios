//
//  OSBNGTransformation.h
//  OSTransformation
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
 *  Returns the proj 4 string to use for converting to BNG.
 *  Uses OSTN02 to ensure highest accuracy transformation.
 */
+ (NSString *)proj4String;

/**
 *  Returns the proj 4 string not referencing OSTN02
 */
+ (NSString *)sevenParamProj4String;

@end
