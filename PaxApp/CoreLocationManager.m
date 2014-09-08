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
        locationManager.distanceFilter = 50; // whenever we move

        locationManager.desiredAccuracy = kCLLocationAccuracyBest; //best
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        [locationManager startUpdatingLocation];  
        
    } else {
        NSLog(@"Location Services disabled");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services required" 
                                                        message:@"Enable your location services to get your current position!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
    }
}




- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%f",newLocation.horizontalAccuracy);

    clLatitude = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
    clLongitude = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
    
    //Writing location to global variable
    [[[GlobalVariables myGlobalVariables] gCurrentForm] setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude] forKey:@"pickup_latitude"];
    [[[GlobalVariables myGlobalVariables] gCurrentForm] setObject:[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude] forKey:@"pickup_longitude"];
    
    [[GlobalVariables myGlobalVariables] setGUserCoordinate:newLocation.coordinate];
    
    
    GetGeocodedAddress *getGeo = [[GetGeocodedAddress alloc]init];
    [getGeo geocodeLocation:newLocation];
    
    
    NSLog(@"CL New Latitude - %@, CL New Longitude - %@",clLatitude,clLongitude);
    //[locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLocationUpdated" object: nil ];

}

-(void)stopUpdating
{
    [locationManager stopUpdatingLocation];
}
@end