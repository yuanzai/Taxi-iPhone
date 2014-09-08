//
//  SelectedTripViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 21/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedTripViewController.h"
#import "CustomNavBar.h"
#import "JobCycleQuery.h"
#import "HTTPQueryModel.h"


@implementation SelectedTripViewController
@synthesize selectedDict, tripType;

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
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];    
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:NSLocalizedString(@"Selected Trip", @"") subtitle:@""];
    self.navigationItem.hidesBackButton = YES;
    [self setFields];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setFields
{
    if ([selectedDict objectForKey:@"dropoff_address"]!= (id)[NSNull null])
    dropoffField.text = [selectedDict objectForKey:@"dropoff_address"];
    
    if ([selectedDict objectForKey:@"pickup_address"]!= (id)[NSNull null])
    pickupField.text = [selectedDict objectForKey:@"pickup_address"];
    
    if ([selectedDict objectForKey:@"trip_datetime"]!= (id)[NSNull null])
    datetimeField.text = [selectedDict objectForKey:@"trip_datetime"];

    if ([selectedDict objectForKey:@"driver_name"]!= (id)[NSNull null]) {
    driverField.text = [selectedDict objectForKey:@"driver_name"];
    } else {
    driverField.text =  NSLocalizedString(@"Pending", @"");
    }
        

    if ([selectedDict objectForKey:@"license_plate_number"]!= (id)[NSNull null]) {
    licenseField.text = [selectedDict objectForKey:@"license_plate_number"];
    } else {
        
    licenseField.text =  @"";
    }

    if ([tripType isEqualToString:@"past"]) {
        callButton.enabled = NO;
        callButton.hidden = YES;
        cancelButton.hidden = YES;
    }
        
    NSLog(@"%@",selectedDict);
}

- (IBAction) cancelButton
{
    cancelBox = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"\n\nCancelling...", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [cancelBox show];
    
    HTTPQueryModel* myQuery;
    NSMutableDictionary* formData = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[selectedDict objectForKey:@"id"], @"job_id",nil];
    
    myQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"postCancelJob" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
        
        if (data && ([httpResponse statusCode] == 200)){
            
            [self performSelectorOnMainThread:@selector(closeBox) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(simulateBackButton) withObject:nil waitUntilDone:YES];
        } else {
            [cancelBox dismissWithClickedButtonIndex:0 animated:YES];
            cancelBox = nil;
            cancelBox = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Cannot connect to server", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }

    } failHandler:^{
        [cancelBox dismissWithClickedButtonIndex:0 animated:YES];
        cancelBox = nil;
        cancelBox = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"Cannot connect to server", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }];
    

}

- (void) closeBox
{
    [cancelBox dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) simulateBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoMytrips:(id)sender{
    [self performSegueWithIdentifier:@"gotoMytrips" sender:nil];
}

-(IBAction)callButton:(id)sender
{
    if ([selectedDict objectForKey:@"driver_mobile_number"] && [selectedDict objectForKey:@"driver_mobile_number"]!= (id)[NSNull null])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[selectedDict objectForKey:@"driver_mobile_number"]]];
    
}
@end
