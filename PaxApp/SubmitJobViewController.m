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
#import "CustomNavBar.h"
#import "TaxiTypePicker.h"
#import "Toast+UIView.h"

#import "JobDispatchQuery.h"
#import "OtherQuery.h"
//remove after testing
#import "JobQuery.h"

@implementation SubmitJobViewController
@synthesize pickupString, destinationString, pickup, destination, mapaddress;

#pragma mark Initialisation

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    //Custom Navbar
        [self setTitle];
    if ([[GlobalVariables myGlobalVariables]gPickupString]){
        pickup.text =[[GlobalVariables myGlobalVariables] gPickupString];
    } else {
        pickup.placeholder = @"Please enter a pickup location";
    }
    
    if ([[GlobalVariables myGlobalVariables]gDestinationString]) {
        destination.text =[[GlobalVariables myGlobalVariables] gDestinationString];
    } else {
        destination.placeholder = @"Please enter a destination";
    }
    
    taxiType.enabled = NO;

    if ([[GlobalVariables myGlobalVariables]gUserAddress]){
        mapaddress.text=[NSString stringWithFormat:[[GlobalVariables myGlobalVariables]gUserAddress]];
    } else {
        mapaddress.placeholder = @"Please enter an address";
    }

    
    [self registerNotifications];

    [destination setDelegate:self];
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

#pragma mark Buttons/IBActions

- (IBAction)clickedNextButton:(id)sender
{
    [pickup resignFirstResponder]; 
    [destination resignFirstResponder];
    [mapaddress resignFirstResponder];
    

    [[GlobalVariables myGlobalVariables] setGPickupString:pickup.text];
    [[GlobalVariables myGlobalVariables] setGDestinationString:destination.text];
    

    if ([mapaddress.text isEqualToString:@""] || !(mapaddress.text)){
        [self.view makeToast:@"Please enter your current address!" duration:1.5 position:@"center"];
    } else if ([destination.text isEqualToString:@""] || !(destination.text)){
        [self.view makeToast:@"Please enter a destination!" duration:1.5 position:@"center"];
    } else {
    
        
        pickupString = [[NSString alloc]initWithString:pickup.text];
        destinationString = [[NSString alloc]initWithString:destination.text];
    newSubmitClass = [[SubmitClass alloc]init];
    
    [newSubmitClass startSubmitProcesswithdriverID:[[GlobalVariables myGlobalVariables] gDriver_id]
                                     pickupAddress:[[GlobalVariables myGlobalVariables] gPickupString] 
                                destinationAddress:[[GlobalVariables myGlobalVariables] gDestinationString]];
    
    NSLog(@"%@ - pickup: %@, destination: %@",self.class,pickup.text, destination.text);
    }
}

- (IBAction)escapeKeyboard:(id)sender
{
    [self setTitle];
    [destination resignFirstResponder];
    [pickup resignFirstResponder];
    [mapaddress resignFirstResponder];
    [mobileNumber resignFirstResponder];
    if (picker)
        [picker hidePicker];
    
    taxiType.text = [[GlobalVariables myGlobalVariables] gTaxiType];

    
}

- (IBAction)setTextfields:(id)sender
{
    [sender resignFirstResponder];    
    
    [[GlobalVariables myGlobalVariables] setGPickupString:pickup.text];
    [[GlobalVariables myGlobalVariables] setGDestinationString:destination.text];
    
    //pickupString = [[NSString alloc]initWithString:pickup.text];
    //destinationString = [[NSString alloc]initWithString:destination.text];
}


-(void)gotoOnroute:(NSNotification *)notification
{
    [self performSegueWithIdentifier:@"gotoOnroute" sender:nil];
}

-(IBAction)gotoMain:(id)sender
{
    [self performSegueWithIdentifier:@"gotoMain" sender:sender];

}

-(IBAction)chooseLocation:(id)sender
{
    [self performSegueWithIdentifier:@"gotoChooseLocation" sender:sender];
}


-(IBAction)chooseFavourites:(id)sender
{
    [self performSegueWithIdentifier:@"gotoFavourites" sender:sender];
}

- (IBAction)chooseTaxiType:(id)sender
{
    if (!picker) {
        picker = [[TaxiTypePicker alloc]init];
        [picker newPickerWithTarget:self];
    }
    [picker showPicker];
}

#pragma mark Simulate Conditions
-(IBAction)testButton:(id)sender
{
    if (![[GlobalVariables myGlobalVariables] gDestinationString])
        [[GlobalVariables myGlobalVariables]setGDestinationString:@"Somewhere over the rainbow!"];
    
    
    
    [JobDispatchQuery submitJobWithPickupLocation:[[GlobalVariables myGlobalVariables] gPickupString] Destination:[[GlobalVariables myGlobalVariables] gDestinationString] TaxiType:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [[GlobalVariables myGlobalVariables] setGJob_id:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        JobQuery *newQuery=[[JobQuery alloc]init];
        [[GlobalVariables myGlobalVariables]setGDriver_id:@"1"];

        [newQuery submitJobQuerywithMsgType:@"driveraccept" job_id:[[GlobalVariables myGlobalVariables]gJob_id] rating:nil driver_id:@"1"];
        [self performSelectorOnMainThread:@selector(gotoOnroute:) withObject:nil waitUntilDone:YES];
    }];
    

    
}

#pragma mark Functional Methods

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



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [destination resignFirstResponder];
    [pickup resignFirstResponder];
    [mapaddress resignFirstResponder];
    [mobileNumber resignFirstResponder];
    if (picker)
        [picker hidePicker];
    
    taxiType.text = [[GlobalVariables myGlobalVariables] gTaxiType];
 
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CLLocationCoordinate2D loc = [[GlobalVariables myGlobalVariables] gDestiCoordinate];
    
    if (textField == destination && loc.latitude != 0.000000 && loc.longitude != 0.000000) {
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
        [[GlobalVariables myGlobalVariables] setGDestinationString:nil];
        [[GlobalVariables myGlobalVariables] setGDestiCoordinate:loc];
        destination.text = @"";
        [self setTitle];
        [destination becomeFirstResponder];
    } else if (buttonIndex == 1){
        
        [destination resignFirstResponder];
    } 
}

-(void) setTitle
{
    if([[GlobalVariables myGlobalVariables]gUserAddress] && ([[GlobalVariables myGlobalVariables]gDestinationString] || [[GlobalVariables myGlobalVariables] gDestiCoordinate].latitude != 0.000000 ||[[GlobalVariables myGlobalVariables] gDestiCoordinate].longitude != 0.000000) ) {
        

        
        [OtherQuery getFareWithlocation:[[GlobalVariables myGlobalVariables]gUserCoordinate] destination:[[GlobalVariables myGlobalVariables]gDestiCoordinate] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            NSMutableDictionary* olddict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];  

            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:[NSString stringWithFormat:@"Fare: RM  %.02f", [[olddict objectForKey:@"fare"]floatValue]] forKey:@"fare"];
             
            [dict setObject:[NSString stringWithFormat:@"Distance: %@ KM",[olddict objectForKey:@"distance"]] forKey:@"distance"];
            
            
            [self performSelectorOnMainThread:@selector(setFare:) withObject:dict waitUntilDone:YES];
        }];  
    } else {
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"Fare: RM 0.00" forKey:@"fare"];
        [dict setObject:@"Please enter droppoff address" forKey:@"distance"];
        
        
        [self performSelectorOnMainThread:@selector(setFare:) withObject:dict waitUntilDone:YES];         
        
    }
}

-(void) setFare:(NSMutableDictionary*) dict
{

    
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initTwoRowBar];    
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:[dict objectForKey:@"fare"] subtitle:[dict objectForKey:@"distance"]];
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

@end
