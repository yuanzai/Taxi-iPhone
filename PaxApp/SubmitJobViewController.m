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
#import "ChooseLocationViewController.h"
#import "FavouritesViewController.h"


//remove after testing
#import "JobQuery.h"

@implementation SubmitJobViewController
@synthesize pickupString, destinationString, pickup, destination, mapaddress;

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

    [super viewDidLoad];
}




- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    pickup.text =[[GlobalVariables myGlobalVariables] gPickupString];
    destination.text =[[GlobalVariables myGlobalVariables] gDestinationString];
    [self registerNotifications];
    [self updateGeoAddress];
    [destination setDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    [self performSegueWithIdentifier:@"gotoOnroute" sender:nil];
}

-(IBAction)gotoMain:(id)sender
{
    [self performSegueWithIdentifier:@"gotoMain" sender:sender];

}

-(IBAction)testButton:(id)sender
{

    JobQuery *newQuery=[[JobQuery alloc]init];
    [newQuery submitJobQuerywithMsgType:@"driveraccept" job_id:[[GlobalVariables myGlobalVariables]gJob_id] rating:nil driver_id:@"1"];
    [[GlobalVariables myGlobalVariables]setGDriver_id:@"1"];
    
    [self performSegueWithIdentifier:@"gotoOnroute" sender:self];
}

-(void) updateGeoAddress
{
    if(!geoAddress)
        geoAddress = [[UILabel alloc]init];

    [mapaddress setText:[NSString stringWithFormat:[[GlobalVariables myGlobalVariables]gUserAddress]]];
    [geoAddress setText:[NSString stringWithFormat:[[GlobalVariables myGlobalVariables]gUserAddress]]];    
}

-(IBAction)chooseLocation:(id)sender
{
    [self performSegueWithIdentifier:@"gotoChooseLocation" sender:sender];
}


-(IBAction)chooseFavourites:(id)sender
{
    [self performSegueWithIdentifier:@"gotoFavourites" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    if ([[segue identifier] isEqualToString:@"gotoChooseLocation"]) {
        
        NSLog(@"Sender Tag - %i", [sender tag]);    
        
        ChooseLocationViewController *clVC = [segue destinationViewController];
        clVC.referer = [sender currentTitle];
        clVC.refererTag = [sender tag];
        
        
        NSLog(@"%@ - %@ - Sender name : %@",self.class,NSStringFromSelector(_cmd),[sender currentTitle]);
        //sender tag 11 = top chooselocation button, tag 12 = bottom choose location button
    } else if  ([[segue identifier] isEqualToString:@"gotoFavourites"]) {
        
        NSLog(@"Sender Tag - %i", [sender tag]);    
        
        FavouritesViewController *fVC = [segue destinationViewController];
        fVC.refererTag = [sender tag];
        
    }
    
}




-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CLLocationCoordinate2D loc = [[GlobalVariables myGlobalVariables] gDestiCoordinate];
    
    if (textField == destination && loc.latitude != 0.000000 && loc.longitude != 0.000000) {
// && (loc.latitude >= -90.0f && loc.latitude <= 90.0f && loc.longitude >= -180.0f && loc.longitude <= 180.0f)
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setDelegate:self];
        [alert setTitle:@"Remove current destination"];
        
        [alert addButtonWithTitle:@"Yes"];
        [alert addButtonWithTitle:@"No"];
        
        [alert show];
        
       

    }
    
    return YES; 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%i", buttonIndex);
    if (buttonIndex == 0) {
        CLLocationCoordinate2D loc;
        loc.latitude = 0;
        loc.longitude = 0;
        [[GlobalVariables myGlobalVariables] setGDestinationString:@""];
        [[GlobalVariables myGlobalVariables] setGDestiCoordinate:loc];
        destination.text = @"";
        
        [destination becomeFirstResponder];
        
        
        
    } else if (buttonIndex == 1){
        
        [destination resignFirstResponder];
        

    } 
}


@end
