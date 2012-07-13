//
//  OnTripViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 29/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class DriverPositionPoller;
@class UserLocationAnnotation;
@class CoreLocationManager;
@class Job;
@class JobStatusPoller;
@class CancelJob;
@class MeterReceiver;
@interface OnTripViewController : UIViewController <MKMapViewDelegate> 
{
    IBOutlet MKMapView	*mapView;
    DriverPositionPoller *downloader;
    UserLocationAnnotation* userLocationAnnotation;
    CoreLocationManager *clManager;
    
    Job *currentJob;
    
    JobStatusPoller *myStatusReceiver;
    
    CancelJob *confirmCancel;
    MeterReceiver *myMeter;
    
    IBOutlet UILabel* fareLabel;

}
@property (nonatomic,strong) IBOutlet MKMapView *mapView;
-(void)registerNotification;
-(void)startStatusReceiver;
-(void)updateUserMarker;
-(void)updateMapMarkers: (NSNotification *) notification;
-(IBAction)startTrip;
-(IBAction)testReached:(id)sender;
-(IBAction)confirmCancel:(id)sender;
-(void)gotoMain:(NSNotification*) notification;





@end
