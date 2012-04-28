//
//  GetGeocodedAddress.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetGeocodedAddress.h"
#import "GlobalVariables.h"


@implementation GetGeocodedAddress

- (NSString*)geocodeLocation:(CLLocation*)location
{
    if (!geocoder)
        geocoder = [[CLGeocoder alloc] init];
    geoaddress = @"";
    
    [geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             NSLog(@"Placemarks - %@", [placemarks objectAtIndex:0]);
             
             CLPlacemark* thisPlacemark = [placemarks objectAtIndex:0];
             geoaddress = [thisPlacemark.addressDictionary objectForKey:@"Name"];
             
             //Global Var 
             [[GlobalVariables myGlobalVariables]setGUserAddress:geoaddress];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"GeoAddress" object:nil];
             
         }
     }];
    
    return geoaddress;
}
@end