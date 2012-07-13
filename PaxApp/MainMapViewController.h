//
//  ViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class UserLocationAnnotation;
@class CoreLocationManager;
@class GetETA;
@class DriverPositionPoller;
@class CalloutBar;
@class ActivityProgressView;

@interface MainMapViewController : UIViewController<MKMapViewDelegate> 
{
    NSArray *oldDriverList;
    NSArray *newDriverList;
    IBOutlet MKMapView	*mapView;
    
    id <MKAnnotation> selectedAnnotation;
    
    UserLocationAnnotation* userLocationAnnotation;
    CoreLocationManager *clManager;
    GetETA *callGetETA;
    DriverPositionPoller *downloader;
    
    IBOutlet UILabel *mainTopBar;
    IBOutlet UILabel *mainBottomBar;
    CalloutBar *myBar;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    IBOutlet UIButton* nextButton;

    ActivityProgressView* activityContainer;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;


- (void) getUserLocation;
- (void) updateMapMarkers: (NSNotification *) notification;
- (void) updateUserMarker: (NSNotification *) notification;
- (void) updateGeoAddress:(NSNotification*) notification;
- (void) addAnnotationUserMarker;
- (void) setNearestDriverTimeText:(NSString*) time;
- (void) showActivityView:(NSNotification*) notification;
- (void) hideActivityView:(NSNotification*) notification;
- (void) registerNotification;



//choose location things
@property (assign) BOOL dirty;
@property (assign) BOOL loading;
@property (nonatomic, strong) NSMutableArray* suggestions;
@property (nonatomic, strong) NSMutableArray* references;
- (void) loadSearchSuggestions;


@end
