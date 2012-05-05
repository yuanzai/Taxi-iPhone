//
//  ChooseLocationViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 04/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface ChooseLocationViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet MKMapView *mapView;    
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (assign) BOOL dirty;
@property (assign) BOOL loading;
@property (nonatomic, strong) NSMutableArray* suggestions;
@property (nonatomic, strong) NSMutableArray* references;
- (void) loadSearchSuggestions;
@end
