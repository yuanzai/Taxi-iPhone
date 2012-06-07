//
//  ViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class UserLocationAnnotation;
@class CoreLocationManager;
@class GetETA;
@class DriverPosition;
@class CalloutBar;


@interface MainMapViewController : UIViewController<MKMapViewDelegate> 
{
    NSArray *oldDriverList;
    NSArray *newDriverList;
    IBOutlet MKMapView	*mapView;
    
    NSString* selectedDriver;
    NSString* tempSelectedDriver;
    id <MKAnnotation> selectedAnnotation;
    
    UserLocationAnnotation* userLocationAnnotation;
    CoreLocationManager *clManager;
    GetETA *callGetETA;
    DriverPosition *downloader;
    
    IBOutlet UILabel *mainTopBar;
    IBOutlet UILabel *mainBottomBar;
    CalloutBar *myBar;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    IBOutlet UIButton* nextButton;

}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (void) getUserLocation;
- (void) registerNotification;
- (void) updateMapMarkers: (NSNotification *) notification;
- (void) updateUserMarker: (NSNotification *) notification;
- (void) updateETA: (NSNotification *) notification;
- (void) updateGeoAddress:(NSNotification*) notification;
- (void) addAnnotationUserMarker;

- (IBAction) setGDriver_id:(id)sender;
- (void) setNearestDriverTimeText:(NSString*) time;

//choose location 
@property (assign) BOOL dirty;
@property (assign) BOOL loading;
@property (nonatomic, strong) NSMutableArray* suggestions;
@property (nonatomic, strong) NSMutableArray* references;
- (void) loadSearchSuggestions;


@end
