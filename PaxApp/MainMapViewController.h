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
@class DownloadDriverData;
@class CalloutBar;


@interface MainMapViewController : UIViewController<MKMapViewDelegate> 
{
    NSMutableArray *oldDriverList;
    NSMutableArray *newDriverList;
    IBOutlet MKMapView	*mapView;
    
    NSString* selectedDriver;
    NSString* tempSelectedDriver;
    id <MKAnnotation> selectedAnnotation;
    
    UserLocationAnnotation* userLocationAnnotation;
    CoreLocationManager *clManager;
    GetETA *callGetETA;
    DownloadDriverData *downloader;
    
    IBOutlet UILabel *mainTopBar;
    IBOutlet UILabel *mainBottomBar;
    CalloutBar *myBar;

}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *mainBottomBar;
- (void) getUserLocation;
- (void) registerNotification;
- (void) updateMapMarkers: (NSNotification *) notification;
- (void) updateUserMarker: (NSNotification *) notification;
- (void) updateETA: (NSNotification *) notification;
-(void) updateGeoAddress:(NSNotification*) notification;

- (IBAction) setGDriver_id:(id)sender;

@end
