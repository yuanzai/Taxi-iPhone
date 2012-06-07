//
//  OnrouteViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
@class DriverPosition;
@class UserLocationAnnotation;
@class CoreLocationManager;
@class Job;
@class JobStatusReceiver;
@class RatingAlert;
@class CancelJobAlert;
@class JobInfoUIVIew;

@interface OnrouteViewController : UIViewController <MKMapViewDelegate> 
{
    IBOutlet MKMapView	*mapView;
    DriverPosition *downloader;
    UserLocationAnnotation* userLocationAnnotation;
    CoreLocationManager *clManager;
    NSMutableArray* driverList;
    
    Job *currentJob;
    
    JobStatusReceiver *myStatusReceiver;
    
    RatingAlert *myRatingAlert;
    CancelJobAlert *confirmCancel;
    
    
    IBOutlet UILabel *license;
    IBOutlet UILabel *destination;
    IBOutlet UILabel *driver;
    IBOutlet UIView *thisJobInfoUIView;
    JobInfoUIVIew *myJobInfoUIView;

    IBOutlet UIButton *onBoard;
    IBOutlet UIButton *cancel;

    IBOutlet UILabel *testStatus;
}
@property (nonatomic,strong) IBOutlet MKMapView *mapView;

- (void)registerNotification;
- (void)getUserLocation;
- (IBAction)button:(id)sender;
- (IBAction)confirmCancel:(id)sender;
- (void)backToMain:(NSNotification*)Notification;
- (void)updateUserMarker;

- (IBAction)testPicked:(id)sender;
- (IBAction)testReached:(id)sender;


- (void)actionPickedStatus:(NSNotification *)notification;
- (void)updateMapMarkers: (NSNotification *) notification;

- (IBAction)onboardButton:(id)sender;
- (void)onBoard;


@end
