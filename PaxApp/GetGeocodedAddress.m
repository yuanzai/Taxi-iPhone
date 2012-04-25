//
//  GetGeocodedAddress.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetGeocodedAddress.h"

@implementation GetGeocodedAddress

- (void)geocodeLocation:(CLLocation*)location
{
    if (!geocoder)
        geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             NSLog(@"%@", [placemarks objectAtIndex:0]);

         }
     }];
}
@end