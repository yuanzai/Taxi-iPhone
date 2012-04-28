//
//  OnrouteViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
@class DownloadDriverData;
@class UserLocationAnnotation;
@class CoreLocationManager;
@class Job;
@class DriverInfo;
@class PickedUpReceiver;
@class RatingAlert;
@class CancelJob;
@interface OnrouteViewController : UIViewController <MKMapViewDelegate> 
{
    IBOutlet MKMapView	*mapView;
    DownloadDriverData *downloader;
    UserLocationAnnotation* userLocationAnnotation;
    CoreLocationManager *clManager;
    NSMutableArray* driverList;
    
    Job *currentJob;
    DriverInfo *currentDriverInfo;
    
    PickedUpReceiver *myPickupReceiver;
    
    RatingAlert *myRatingAlert;
    
    CancelJob *confirmCancel;

}
@property (nonatomic,strong) IBOutlet MKMapView *mapView;

- (void)registerNotification;
- (void)getUserLocation;
- (void)displayInfo;
- (void)startPickupReceiver;
- (IBAction)button:(id)sender;
- (IBAction)confirmCancel:(id)sender;
-(void)backToMain:(NSNotification*)Notification;



@end
