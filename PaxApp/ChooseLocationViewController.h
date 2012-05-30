//
//  ChooseLocationViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 04/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class AddressAnnotation;
@class AlertBoxAddressName;
@interface ChooseLocationViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate>
{
    IBOutlet MKMapView *mapView;
    AddressAnnotation *myAA;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    AlertBoxAddressName* nameBox;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (assign) BOOL dirty;
@property (assign) BOOL loading;
@property (nonatomic, strong) NSMutableArray* suggestions;
@property (nonatomic, strong) NSMutableArray* references;
@property (nonatomic, strong) NSString* referer;
@property NSInteger refererTag;
- (void) loadSearchSuggestions;
- (IBAction)saveButton:(id)sender;
- (void) addAnnotations;
- (IBAction)useThisLocationButton:(id)sender;
- (void)gotoSubmitJob;


@end
