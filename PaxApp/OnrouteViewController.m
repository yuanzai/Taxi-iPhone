//
//  OnrouteViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OnrouteViewController.h"
#import "DriverPositionPoller.h"
#import "UserLocationAnnotation.h"
#import "CoreLocationManager.h"
#import "GlobalVariables.h"
#import "JobStatusPoller.h"
#import "RatingAlert.h"
#import "Job.h"
#import "CancelJobAlert.h"


#import "DriverAnnotation.h"
#import "JobQuery.h"
#import "JobInfoUIVIew.h"
#import "DriverInfoModel.h"
#import "JobCycleQuery.h"
#import "CustomNavBar.h"
#import "HTTPQueryModel.h"
#import <AudioToolbox/AudioServices.h>


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
    [[GlobalVariables myGlobalVariables] setGGoto:nil];
    [[GlobalVariables myGlobalVariables]setGDriverList:nil];
    
    //init UIView jobinfo
    myJobInfoUIView = [[JobInfoUIVIew alloc]init];
    [myJobInfoUIView setLicense:license];
    [myJobInfoUIView setDestination:destination];
    [myJobInfoUIView setDriver:driver];
    [myJobInfoUIView setLabels];
    
    [self registerNotification];
    mySound = [self createSoundID: @"Alert.wav"];
    driverIsHere = NO;
    
    [mapView setDelegate:self];
    
    downloader = [[DriverPositionPoller alloc]initDriverPositionPollWithDriverID:[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"driver_id"]];
    myStatusReceiver = [[JobStatusPoller alloc]initStatusReceiverTimerWithJobID:[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"id"]];
    myStatusReceiver.delegate = self;
    
    //Custom Navbar
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:[NSString stringWithFormat:@"%@ %@",[[[GlobalVariables myGlobalVariables] gCurrentForm] objectForKey:@"currency"], [[[GlobalVariables myGlobalVariables] gCurrentForm] objectForKey:@"fare"]]  subtitle:@""];
    
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
    if (myStatusReceiver) {
        [myStatusReceiver stopStatusReceiverTimer];
        myStatusReceiver = nil;
    }
    
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
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_latitude"]floatValue];
    coordinate.longitude = [[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_longitude"]floatValue];
    
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
    [confirmCancel launchConfirmBox:self];
}

-(IBAction)callButton:(id)sender
{
    if ([[[GlobalVariables myGlobalVariables] gCurrentForm]objectForKey:@"driver_mobile_number"])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[[GlobalVariables myGlobalVariables] gCurrentForm]objectForKey:@"driver_mobile_number"]]];
    
}

-(void)actionArrivedStatus:(NSNotification *)notification
{
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:@"Driver is here"  subtitle:@""];
    
    if (!driverIsHere) {
        [self performSelectorOnMainThread:@selector(playSound) withObject:nil waitUntilDone:YES ];
        UIAlertView* driverArrivedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Your driver is here!", @"") message:NSLocalizedString(@"Please proceed to pickup point", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [driverArrivedAlert show];
        driverIsHere = YES;
    }
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    cancelBox = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"\n\nCancelling...", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [cancelBox show];
    
    HTTPQueryModel* myQuery;
    NSMutableDictionary* formData = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"id"] , @"job_id",nil];
    
    myQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"postCancelJob" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
        
        if (data && ([httpResponse statusCode] == 200)){
            
            [self performSelectorOnMainThread:@selector(closeBox) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(gotoMain:) withObject:nil waitUntilDone:YES];
        } else {
            [cancelBox dismissWithClickedButtonIndex:0 animated:YES];
            cancelBox = nil;
            cancelBox = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"Cannot connect to server", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        
    } failHandler:^{
        [cancelBox dismissWithClickedButtonIndex:0 animated:YES];
        cancelBox = nil;
        cancelBox = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"Cannot connect to server", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }];
}


- (void) closeBox
{
    [cancelBox dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)gotoEndtrip:(id)sender
{
    [self performSegueWithIdentifier:@"gotoEndtrip" sender:nil];
}

-(void)jobStatusChangedTo:(NSString *)status info:(NSDictionary *)jobInfo
{
    if ([status isEqualToString:@"arrived"] || [status isEqualToString:@"reached"])
    {
        NSLog(@"%@ - %@ - %@",self.class,NSStringFromSelector(_cmd), status);
        
        NSString* driverID = [jobInfo objectForKey:@"driver_id"];
        NSString* driver_name = [jobInfo objectForKey:@"driver_name"];
        NSString* license_plate_number = [jobInfo objectForKey:@"license_plate_number"];
        [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:driverID forKey:@"driver_id"];
        [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:driver_name forKey:@"driver_name"];
        [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:license_plate_number forKey:@"license_plate_number"];
        
        //[self performSelectorOnMainThread:@selector(playSound) withObject:nil waitUntilDone:YES ];
        [self performSelectorOnMainThread:@selector(actionArrivedStatus:) withObject:nil waitUntilDone:YES];
    }
    
}

- (SystemSoundID) createSoundID: (NSString*)name
{
    NSURL* filePath = [[NSBundle mainBundle] URLForResource:@"arrivedAlert" withExtension:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

- (void) playSound
{
    AudioServicesPlaySystemSound(mySound);
    
}
@end
