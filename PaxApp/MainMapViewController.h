//
//  ViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class UserLocationItem;
@class CoreLocationManager;
@class GetETA;
@class DownloadData;
@interface MainMapViewController : UIViewController<MKMapViewDelegate> 
{
    NSMutableArray *oldDriverList;
    NSMutableArray *newDriverList;
    IBOutlet MKMapView	*mapView;
    
    NSString* selectedDriver;
    NSString* tempSelectedDriver;
    id <MKAnnotation> selectedAnnotation;
    
    UserLocationItem* userLocationAnnotation;
    CoreLocationManager *clManager;
    GetETA *callGetETA;
    DownloadData *downloader;
    
    

}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (void)getUserLocation;
- (void)registerNotification;
- (void)updateMapMarkers: (NSNotification *) notification;
- (void)updateUserMarker: (NSNotification *) notification;
- (void) updateETA: (NSNotification *) notification;

@end
