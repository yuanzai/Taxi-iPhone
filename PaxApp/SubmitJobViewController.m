//
//  SubmitJobViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubmitJobViewController.h"
#import "GlobalVariables.h"
#import "SubmitClass.h"

@implementation SubmitJobViewController
@synthesize pickupString, destinationString, pickup, destination;

- (IBAction)clickedNextButton:(id)sender
{
    [pickup resignFirstResponder];    
    [destination resignFirstResponder];    
    
    [[GlobalVariables myGlobalVariables] setGPickupString:pickup.text];
    [[GlobalVariables myGlobalVariables] setGDestinationString:destination.text];
    
    //pickupString = [[NSString alloc]initWithString:pickup.text];
    //destinationString = [[NSString alloc]initWithString:destination.text];
    
    newSubmitClass = [[SubmitClass alloc]init];
    
    [newSubmitClass startSubmitProcesswithdriverID:[[GlobalVariables myGlobalVariables] gDriver_id]
                                     pickupAddress:[[GlobalVariables myGlobalVariables] gPickupString] 
                                destinationAddress:[[GlobalVariables myGlobalVariables] gDestinationString]];
    
    NSLog(@"%@ - pickup: %@, destination: %@",self.class,pickup.text, destination.text);
    
    }

- (IBAction)escapeKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)setTextfields:(id)sender
{
    [sender resignFirstResponder];    
    
    [[GlobalVariables myGlobalVariables] setGPickupString:pickup.text];
    [[GlobalVariables myGlobalVariables] setGDestinationString:destination.text];
    
    //pickupString = [[NSString alloc]initWithString:pickup.text];
    //destinationString = [[NSString alloc]initWithString:destination.text];
}

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
    pickup.text =[[GlobalVariables myGlobalVariables] gPickupString];
    destination.text =[[GlobalVariables myGlobalVariables] gDestinationString];
    [self registerNotifications];
    [self updateGeoAddress];
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(gotoOnroute:)
     name:@"gotoOnroute"
     object:nil ];
}

-(void)gotoOnroute:(NSNotification *)notification
{
    [self performSegueWithIdentifier:@"JobAccepted" sender:self];
}

-(IBAction)testButton:(id)sender
{
    NSLog(@"%@",sender);
    [self performSegueWithIdentifier:@"JobAccepted" sender:self];
}

-(void) updateGeoAddress
{
    if(!geoAddress)
        geoAddress = [[UILabel alloc]init];

    [geoAddress setText:[NSString stringWithFormat:[[GlobalVariables myGlobalVariables]gUserAddress]]];    
}

@end
