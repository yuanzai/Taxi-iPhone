//
//  OnrouteViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "JobStatusPoller.h"

@class DriverPositionPoller;
@class UserLocationAnnotation;
@class CoreLocationManager;
@class Job;
@class JobStatusPoller;
@class RatingAlert;
@class CancelJobAlert;
@class JobInfoUIVIew;

@interface OnrouteViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate, JobStatusDelegate>
{
    IBOutlet MKMapView	*mapView;
    DriverPositionPoller *downloader;
    UserLocationAnnotation* userLocationAnnotation;
    CoreLocationManager *clManager;
    NSMutableArray* driverList;
    
    Job *currentJob;
    
    JobStatusPoller *myStatusReceiver;
    
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
    
    UIAlertView* cancelBox;
    
    SystemSoundID mySound;
    
    BOOL driverIsHere;
}
@property (nonatomic,strong) IBOutlet MKMapView *mapView;

- (void)registerNotification;
- (IBAction)confirmCancel:(id)sender;
- (void)updateUserMarker;


- (void)actionArrivedStatus:(NSNotification *)notification;
- (void)updateMapMarkers: (NSNotification *) notification;

- (IBAction)onboardButton:(id)sender;
- (void) closeBox;
- (IBAction)gotoEndtrip:(id)sender;
- (void) gotoMain;
- (SystemSoundID) createSoundID: (NSString*)name;
- (void) playSound;


@end
