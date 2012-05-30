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
#import "JobStatusReceiver.h"
#import "RatingAlert.h"
#import "Job.h"
#import "DriverInfo.h"
#import "CancelJob.h"
#import "JobView.h"


#import "DriverAnnotation.h"
#import "JobQuery.h"


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
    
    [self registerNotification];
    [mapView setDelegate:self];
    downloader = [[DownloadDriverData alloc]init];
    downloader.driver_id = [[GlobalVariables myGlobalVariables]gDriver_id];
    [self startStatusReceiver];
    [self updateUserMarker];
    myJobView = [[JobView alloc]init]; 
    myJobView.infoView = infoView;
    [downloader startDriverDataDownloadTimer];
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
    [showMoreButton setHidden:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [downloader stopDownloadDriverDataTimer];
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
     selector:@selector(gotoMain:)
     name:@"gotoMain"
     object:nil ];
        
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(actionPickedStatus:)
     name:@"NotifyPickedStatus"
     object:nil ];

}

- (void)updateMapMarkers: (NSNotification *) notification
{    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [mapView addAnnotations:[[[GlobalVariables myGlobalVariables] gDriverList] allValues]];
    [self displayInfo];

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
        annView.image = [UIImage imageNamed:@"userdot"];
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
    [currentJob getJobInfo_useJobID:[[GlobalVariables myGlobalVariables] gJob_id]];
    
    NSMutableDictionary* array = [[GlobalVariables myGlobalVariables]gDriverList];
    DriverAnnotation* thisDriver = [array objectForKey:[[GlobalVariables myGlobalVariables]gDriver_id]];
    
    NSDictionary* thisDriverInfo = thisDriver.driverInfo;
    
    carModel.text = [thisDriverInfo objectForKey:@"model"];
    licenseNumber.text = [thisDriverInfo objectForKey:@"license"];

}

-(void)startStatusReceiver
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    myStatusReceiver = [[JobStatusReceiver alloc]init];
    myStatusReceiver.job_id = [[GlobalVariables myGlobalVariables]gJob_id];
    [myStatusReceiver startStatusReceiverTimer];
    
}

-(IBAction)button:(id)sender
{
    myRatingAlert = [[RatingAlert alloc]init];
    [myRatingAlert launchMainBox:nil];
    
}

-(void)gotoMain:(NSNotification*)Notification
{
    [self performSegueWithIdentifier:@"gotoMain" sender:self];
}

-(IBAction)confirmCancel:(id)sender
{
    confirmCancel = [[CancelJob alloc]init];
    [confirmCancel launchConfirmBox];
}

-(IBAction)hideInfoView:(id)sender
{   
    [showMoreButton setHidden:NO];
    [myJobView hideInfoView];
}

-(IBAction)showInfoView:(id)sender
{
    [showMoreButton setHidden:YES];
    [myJobView showInfoView];
}


-(IBAction)testPicked:(id)sender
{
    JobQuery *newQuery=[[JobQuery alloc]init];
    [newQuery submitJobQuerywithMsgType:@"driverpicked" job_id:[[GlobalVariables myGlobalVariables]gJob_id] rating:nil driver_id:nil];    
}

-(void)actionPickedStatus:(NSNotification *)notification
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    [self performSegueWithIdentifier:@"gotoOnTrip" sender:self];
}


@end
