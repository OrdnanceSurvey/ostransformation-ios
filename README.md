# OSTransformation
This library allows for conversion to and from British National Grid eastings
and northings and WGS 84 (EPSG:4326) coordinates.

## Usage
There are two methods that can be used to convert between BNG grid points and
WGS 84 coordinates, `OSCoordinateForGridPoint` and its inverse
`OSGridPointForCoordinate`, and `OSCoordinateForGridPointUsing7Parameter` and its
inverse, `OSGridPointForCoordinateUsing7Parameter`. The more concisely named
methods use [OSTN02](https://www.ordnancesurvey.co.uk/business-and-government/help-and-support/navigation-technology/os-net/ostn02-ntv2-format.html)
to provide sub-1mm accuracy. The `7Parameter` methods do not use OSTN02 so the
accuracy of the transformations can be as much as 7m out. However, depending on
your use case, or the data you're using, the 7 parameter functions may well be
the best solution.

```
OSGridPoint gridPoint = OSGridPointFromString(@"SU372155", NULL);
CLLocationCoordinate2D coordinate = OSCoordinateForGridPoint(gridPoint);
```

## Including in your project
OSTransformation can be included in your project using Carthage. Just add:
```
github "OrdnanceSurvey/ostransformation-ios"
```

## Other transformations
### Orthometric height conversion
This library also contains a function to convert a WGS 84 altitude to the Orthometric
height as defined by [OSGM02](http://www.ordnancesurvey.co.uk/business-and-government/help-and-support/navigation-technology/os-net/formats-for-developers.html
). However this should not be used with height values provided by Core Location's
`CLLocationManager`, as this already transforms the GPS height. Apple don't disclose
the source of their transformation, but from inspection, the value is relatively
close to the value you would get using OSGM02. If you wish to use this method,
you will need to include the [OSGM02](OSTransformation/OSGM02) file in the framework.

## License
As with the OSTN02 data file, this library is licensed under the [BSD license](LICENSE).

This project also depends on the [Route-Me project](https://github.com/route-me/route-me),
and on [proj.4](https://github.com/OSGeo/proj.4), so you must adhere to the licenses
of those projects.
