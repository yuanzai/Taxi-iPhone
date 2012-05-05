//
//  ViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMapViewController.h"
#import "DownloadDriverData.h"
#import "GlobalVariables.h"
#import "UserLocationAnnotation.h"
#import "CoreLocationManager.h"
#import "GetETA.h"
#import "GetGeocodedAddress.h"
#import "CalloutBar.h"


@implementation MainMapViewController
@synthesize mapView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    [mapView setDelegate:self];
    [[GlobalVariables myGlobalVariables] clearGlobalData];   
    
    [self registerNotification];
    downloader = [[DownloadDriverData alloc]init];
    downloader.driver_id = @"all";
    myBar = [[CalloutBar alloc]init];
    myBar.topBar = mainTopBar;
    myBar.bottomBar = mainBottomBar;
    
    [myBar hideUserBar];
    callGetETA = [[GetETA alloc]init];
    
    [self getUserLocation];
    [downloader startDriverDataDownloadTimer];
    
	// Do any additional setup after loading the view, typically from a nib.

    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    

}

- (void)viewWillAppear:(BOOL)animated
{  
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [downloader stopDownloadDriverDataTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateMapMarkers:)
     name:@"driverListUpdated"
     object:nil ];
 
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateUserMarker:)
     name:@"userLocationUpdated"
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateETA:)
     name:@"ETA"
     object:nil ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateGeoAddress:)
     name:@"GeoAddress"
     object:nil ];
    
}

- (void)updateMapMarkers: (NSNotification *) notification
{    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    if (!newDriverList) {
        newDriverList = [[NSArray alloc]init];
    }    
    newDriverList = [[[GlobalVariables myGlobalVariables] gDriverList] allValues]; 
    
    
    
    if (!tempSelectedDriver)
        tempSelectedDriver = [[NSString alloc]init];

    if (!selectedDriver) 
        selectedDriver = [[NSString alloc]init];
    
    
    tempSelectedDriver = selectedDriver;
    
    if (!oldDriverList) {
        oldDriverList = [[NSArray alloc]init];
        [mapView addAnnotations:newDriverList];

    
    } else {
        //[mapView removeAnnotations:oldDriverList];
        
        NSMutableArray *tempAddList = [[NSMutableArray alloc]init];
        NSMutableArray *tempRemoveList = [[NSMutableArray alloc]init];
        tempAddList = [NSMutableArray arrayWithArray:newDriverList];
        tempRemoveList = [NSMutableArray arrayWithArray:oldDriverList];

        if (![tempAddList containsObject:oldDriverList]) {
            [tempAddList removeObjectsInArray:oldDriverList];
            [mapView addAnnotations:tempAddList];

        }

        if (![tempRemoveList containsObject:newDriverList]) {
            [tempRemoveList removeObjectsInArray:newDriverList];
            [mapView removeAnnotations:tempRemoveList];
        }
       
    }
    oldDriverList = newDriverList;
}

- (void)getUserLocation 
{	
    if (!clManager){
        clManager = [[CoreLocationManager alloc]init];
    }
    
    [clManager startLocationManager:nil];
}

-(void)updateUserMarker: (NSNotification *) notification
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    if (!userLocationAnnotation) {
        userLocationAnnotation = [[UserLocationAnnotation alloc]init];
    } else {
        [mapView removeAnnotation:userLocationAnnotation];
    }
    CLLocationCoordinate2D coordinate=[[GlobalVariables myGlobalVariables] gUserCoordinate];    
    
    MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.01;
	span.longitudeDelta=0.01;	 
	region.span=span;
    region.center=coordinate;
    
    [mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
    
    NSLog(@"%@,%@", [NSNumber numberWithDouble:coordinate.latitude], [NSNumber numberWithDouble:coordinate.longitude]);
    
    [userLocationAnnotation setCoordinateWithGV];
    [mapView addAnnotation:userLocationAnnotation];

}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    selectedDriver = tempSelectedDriver;
    
    if (annotation.title == @"User Location")
    {
        NSLog(@"MKAnnotationView Called - User Location");
    	MKAnnotationView *annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"userloc"];
        annView.image = [UIImage imageNamed:@"userdot"];
        annView.draggable = YES;
        annView.canShowCallout = NO;

         return annView;
    }else{
        NSLog(@"MKAnnotationView Called - Drivers");

        MKAnnotationView *annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"driverloc"];
        annView.image = [UIImage imageNamed:@"taxi"];
        annView.canShowCallout = NO;
        
        
        if ([annotation.title isEqualToString:selectedDriver]) {
            
            selectedAnnotation = annotation;
            
        }
        	return annView;

    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{

        [self.mapView selectAnnotation:selectedAnnotation animated:NO];   
    
}

- (void)mapView:(MKMapView *)sender didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Annotation Selected - %@", view.annotation.title);
    
    if (view.annotation.title != @"User Location") {
        
        [callGetETA startETAThread:view.annotation];
        
        if (!selectedDriver)
            selectedDriver = [[NSString alloc]init ];
        
        view.image = [UIImage imageNamed:@"selected"];
        selectedDriver = view.annotation.title;      
        
        
    }else {
        NSLog(@"No ETA");
        
    }
        
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //selectedDriver = nil;
    if (view.annotation.title != @"User Location")
    view.image = [UIImage imageNamed:@"taxi"];
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
}



- (void) updateETA: (NSNotification *) notification;
{
    NSLog(@"%@ - %@ - Updated ETA - %@",self.class,NSStringFromSelector(_cmd),[callGetETA eta]);
    [myBar showDriverBarWithETA:callGetETA.eta driver_id:nil];
    
}

- (IBAction) setGDriver_id:(id)sender
{
    //BroadCast button
 [[GlobalVariables myGlobalVariables] setGDriver_id:@"0"];  
    
}

-(void) updateGeoAddress:(NSNotification*) notification
{
    [myBar showUserBarWithGeoAddress];
    //[mainBottomBar setText:[NSString stringWithFormat:[[GlobalVariables myGlobalVariables]gUserAddress]]];
    
    
}

@end
