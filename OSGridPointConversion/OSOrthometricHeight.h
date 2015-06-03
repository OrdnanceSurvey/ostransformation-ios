//
//  OSOrthometricHeight.h
//  OSGridPointConversion
//
//  Created by Dave Hardiman on 03/06/2015.
//  Copyright (c) 2015 Ordnance Survey. All rights reserved.
//

@import CoreLocation;

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
