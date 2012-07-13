//
//  CoreLocation.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationManager.h"
#import "UserLocationAnnotation.h"
#import "GlobalVariables.h"
#import "GetGeocodedAddress.h"

@implementation CoreLocationManager
@synthesize clLatitude,clLongitude;

-(void)startLocationManager:(id)delegateSelect{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.purpose =@"Locate yourself on the map!";
     
    if([CLLocationManager locationServicesEnabled] && 
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        locationManager.delegate = self; //delegateSelect;
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        [locationManager startUpdatingLocation];  
        
    } else {
        NSLog(@"Location Services disabled");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services required" 
                                                        message:@"We need you to enable location services!"
                                                       delegate:self
                                              cancelButtonTitle:@"Goto Settings" 
                                              otherButtonTitles:@"Cancel",nil];
        
        [alert show];
    }
    

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"prefs:root=LOCATION_SERVICES"]];    
    }     
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    clLatitude = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
    clLongitude = [NSNumber numberWithDouble:newLocation.coordinate.longitude];

    
    //Writing location to global variable
    [[GlobalVariables myGlobalVariables] setGUserCoordinate:newLocation.coordinate];
    [[[GlobalVariables myGlobalVariables] gCurrentForm] setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude] forKey:@"pickup_latitude"];
    [[[GlobalVariables myGlobalVariables] gCurrentForm] setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude] forKey:@"pickup_longitude"];
    
    GetGeocodedAddress *getGeo = [[GetGeocodedAddress alloc]init];
    [getGeo geocodeLocation:newLocation];
    
    
    NSLog(@"CL New Latitude - %@, CL New Longitude - %@",clLatitude,clLongitude);
    [locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLocationUpdated" object: nil ];

}

@end