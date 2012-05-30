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
@class JobStatusReceiver;
@class RatingAlert;
@class CancelJob;
@class JobView;
@interface OnrouteViewController : UIViewController <MKMapViewDelegate> 
{
    IBOutlet MKMapView	*mapView;
    DownloadDriverData *downloader;
    UserLocationAnnotation* userLocationAnnotation;
    CoreLocationManager *clManager;
    NSMutableArray* driverList;
    
    Job *currentJob;
    
    JobStatusReceiver *myStatusReceiver;
    
    RatingAlert *myRatingAlert;
    
    CancelJob *confirmCancel;
    
    JobView *myJobView;
    IBOutlet UIView *infoView;
    IBOutlet UIButton *showMoreButton;
    
    IBOutlet UILabel *licenseNumber;
    IBOutlet UILabel *carModel;

}
@property (nonatomic,strong) IBOutlet MKMapView *mapView;

- (void)registerNotification;
- (void)getUserLocation;
- (void)displayInfo;
- (void)startStatusReceiver;
- (IBAction)button:(id)sender;
- (IBAction)confirmCancel:(id)sender;
-(void)backToMain:(NSNotification*)Notification;
-(void)updateUserMarker;
-(IBAction)testPicked:(id)sender;
-(void)actionPickedStatus:(NSNotification *)notification;
- (void)updateMapMarkers: (NSNotification *) notification;



@end
