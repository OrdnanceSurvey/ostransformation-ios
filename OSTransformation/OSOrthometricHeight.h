//
//  OSOrthometricHeight.h
//  OSTransformation
//
//  Created by Dave Hardiman on 03/06/2015.
//  Copyright (c) 2015 Ordnance Survey. All rights reserved.
//

@import CoreLocation;

/**
 *  Value returned when the orthometric height can't be determined,
 *  for example if the point is outside of the known polygon.
 */
extern CLLocationDistance const OSOrthometricHeightError;

/**
 *  Conversion of a WGS84 altitude, obtained from the GPS, to the orthometric
 *  height as defined by OSGM02. 
 *  http://www.ordnancesurvey.co.uk/business-and-government/help-and-support/navigation-technology/os-net/formats-for-developers.html
 *
 *  @param location The location to convert. This location should have a valid altitude and coordinate
 *
 *  @return The converted orthometric height
 */
CLLocationDistance OSOrthomtricHeightForLocation(CLLocation *location);
