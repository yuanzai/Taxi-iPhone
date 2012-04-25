//
//  CoreLocation.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CoreLocationManager : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    NSNumber* clLatitude;
    NSNumber* clLongitude;
}
@property (nonatomic, strong) NSNumber* clLatitude;
@property (nonatomic, strong) NSNumber* clLongitude;


-(void)startLocationManager:(id)delegateSelect;
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation;
@end