//
//  OnrouteViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnrouteViewController.h"
#import "DriverPosition.h"
#import "UserLocationAnnotation.h"
#import "CoreLocationManager.h"
#import "GlobalVariables.h"
#import "JobStatusReceiver.h"
#import "RatingAlert.h"
#import "Job.h"
#import "CancelJobAlert.h"


#import "DriverAnnotation.h"
#import "JobQuery.h"
#import "JobInfoUIVIew.h"
#import "DriverInfoModel.h"
#import "JobCycleQuery.h"
#import "CustomNavBar.h"

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
    [[GlobalVariables myGlobalVariables]setGDriverList:nil];    

    //init UIView jobinfo
    myJobInfoUIView = [[JobInfoUIVIew alloc]init];
    [myJobInfoUIView setLicense:license];
    [myJobInfoUIView setDestination:destination];
    [myJobInfoUIView setDriver:driver];
    [myJobInfoUIView setLabels];

    DriverInfoModel *getDriverInfo = [[DriverInfoModel alloc]init];
    [getDriverInfo getDriverInfoWithDriverID:[[GlobalVariables myGlobalVariables]gDriver_id]];
     
    

    [self registerNotification];
    [mapView setDelegate:self];
    
    downloader = [[DriverPosition alloc]initDriverPositionPollWithDriverID:[[GlobalVariables myGlobalVariables]gDriver_id]];
    myStatusReceiver = [[JobStatusReceiver alloc]initStatusReceiverTimerWithJobID:[[GlobalVariables myGlobalVariables]gJob_id] TargettedStatus:@"picked"];

    //Custom Navbar
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initTwoRowBar];    
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:@"Fare: RM 0.00" subtitle:@"Please enter droppoff address"];
    [thisNavBar addRightLogo];
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    
    [self updateUserMarker];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewWillAppear:(BOOL)animated
{
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [downloader stopDriverPositionPoll];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)registerNotification
{
    //map markers to load upon global variable update
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMapMarkers:) name:@"driverListUpdated" object:nil];
    
    //gotoMain
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMain:) name:@"gotoMain" object:nil];
    
    //jobstatusreceiver
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionPickedStatus:) name:@"picked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionReachedStatus:) name:@"driverreached" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDriverLabel:) name:@"driverInfoUpdated" object:nil];
}

- (void)setDriverLabel: (NSNotification *) notification
{
    [myJobInfoUIView updateDriver];
}

- (void)updateMapMarkers: (NSNotification *) notification
{    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [mapView addAnnotations:[[[GlobalVariables myGlobalVariables] gDriverList] allValues]];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"driverListUpdated" object:nil];
}

-(void)updateUserMarker
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    userLocationAnnotation = [[UserLocationAnnotation alloc]init];
    CLLocationCoordinate2D coordinate=[[GlobalVariables myGlobalVariables] gUserCoordinate];    
    
    MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.01;
	span.longitudeDelta=0.01;	 
	region.span=span;
    region.center=coordinate;
    
    [mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
    
    [userLocationAnnotation setCoordinateWithGV];
    [mapView addAnnotation:userLocationAnnotation];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    
    if (annotation.title == @"User Location")
    {
        NSLog(@"MKAnnotationView Called - User Location");
    	MKAnnotationView *annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"userloc"];
        annView.image = [UIImage imageNamed:@"passengerMarker"];
        annView.centerOffset = CGPointMake(0, -20);
        annView.canShowCallout = NO;
        
        return annView;
    }else{
        NSLog(@"MKAnnotationView Called - Drivers");
        
        MKAnnotationView *annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"selecteddriverloc"];
        annView.image = [UIImage imageNamed:@"selectedDriverMarker"];
        annView.centerOffset = CGPointMake(0, -20);
        annView.canShowCallout = NO;
        
        return annView;
        
    }
}

-(void)gotoMain:(NSNotification*)Notification
{
    [self performSegueWithIdentifier:@"gotoMain" sender:self];
}

-(void)gotoEndTrip:(NSNotification*)Notification
{
    [self performSegueWithIdentifier:@"gotoEndTrip" sender:self];
}

-(IBAction)confirmCancel:(id)sender
{
    confirmCancel = [[CancelJobAlert alloc]init];
    [confirmCancel launchConfirmBox];
}

-(IBAction)testPicked:(id)sender
{
    JobQuery *newQuery=[[JobQuery alloc]init];
    [newQuery submitJobQuerywithMsgType:@"driverpicked" job_id:[[GlobalVariables myGlobalVariables]gJob_id] rating:nil driver_id:nil];    
}

-(IBAction)testReached:(id)sender
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    JobQuery *newQuery=[[JobQuery alloc]init];
    [newQuery submitJobQuerywithMsgType:@"driverreached" job_id:[[GlobalVariables myGlobalVariables]gJob_id] rating:nil driver_id:nil];    
}

-(IBAction)onboardButton:(id)sender
{    
    [JobCycleQuery onboardJobCalledByPassenger_jobID:[[GlobalVariables myGlobalVariables] gJob_id] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [self performSelectorOnMainThread:@selector(onBoard) withObject:nil waitUntilDone:YES];
    }];
}

-(void)onBoard
{
    [onBoard setHidden:YES];
    [cancel setHidden:YES];
    self.navigationItem.title=@"Onboard";  
    if ([myStatusReceiver.targettedStatus isEqualToString:@"picked"]){
        [myStatusReceiver stopStatusReceiverTimer];
    }

    testStatus.text = @"Onboard";

    
    [myStatusReceiver startStatusReceiverTimerWithJobID:[[GlobalVariables myGlobalVariables]gJob_id] TargettedStatus:@"driverreached"];
}

-(void)actionPickedStatus:(NSNotification *)notification
{
    self.navigationItem.title=@"Driver Arrived";  
    testStatus.text = @"Arrived";

    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

}

-(void)actionReachedStatus:(NSNotification *)notification
{
    testStatus.text = @"Onboard";

    [self performSegueWithIdentifier:@"gotoEndTrip" sender:self];

}

@end
