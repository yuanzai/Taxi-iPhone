//
//  OnrouteViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnrouteViewController.h"
#import "DownloadDriverData.h"
#import "UserLocationAnnotation.h"
#import "CoreLocationManager.h"
#import "GlobalVariables.h"
#import "PickedUpReceiver.h"
#import "RatingAlert.h"
#import "Job.h"
#import "DriverInfo.h"
#import "CancelJob.h"


@implementation OnrouteViewController
@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNotification];
    [mapView setDelegate:self];
    downloader = [[DownloadDriverData alloc]init];
    downloader.driver_id = [[GlobalVariables myGlobalVariables]gDriver_id];
    [self displayInfo];
    [self startPickupReceiver];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [downloader startDriverDataDownloadTimer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getUserLocation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
     selector:@selector(backToMain:)
     name:@"backToMain"
     object:nil ];
}

- (void)updateMapMarkers: (NSNotification *) notification
{    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    if (!driverList) {
        driverList = [[NSMutableArray alloc]init];
    } else {
        [mapView removeAnnotations:driverList];
        
    }
    driverList = [[GlobalVariables myGlobalVariables] gDriverList]; 

    [mapView addAnnotations:driverList];
    
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
        
        return annView;
        
    }
}

-(void)displayInfo
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    currentJob = [[Job alloc]init];
    currentDriverInfo = [[DriverInfo alloc]init];
    
    [currentJob getJobInfo_useJobID:[[GlobalVariables myGlobalVariables] gJob_id]];
    [currentDriverInfo getDriverInfo_useDriverID:[[GlobalVariables myGlobalVariables]gDriver_id]];
    
    NSLog(@"%@ - %@ - currentJob:%@",self.class,NSStringFromSelector(_cmd),currentJob);

    NSLog(@"%@ - %@ - currentDriverInfo:%@",self.class,NSStringFromSelector(_cmd),currentDriverInfo);
}

-(void)startPickupReceiver
{
    myPickupReceiver = [[PickedUpReceiver alloc]init];
    myPickupReceiver.job_id = [[GlobalVariables myGlobalVariables]gJob_id];
    [myPickupReceiver startPickupReceiverTimer];
    
}

-(IBAction)button:(id)sender
{
    myRatingAlert = [[RatingAlert alloc]init];
    [myRatingAlert launchMainBox:nil];
    
}

-(void)backToMain:(NSNotification*)Notification
{
    [self performSegueWithIdentifier:@"BackToMain" sender:self];
}

-(IBAction)confirmCancel:(id)sender
{
    confirmCancel = [[CancelJob alloc]init];
    [confirmCancel launchConfirmBox];
    
}
@end
