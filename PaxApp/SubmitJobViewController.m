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
#import "Constants.h"
#import "SubmitForm.h"


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
    NSLog(@"Booking Form - %@",[[GlobalVariables myGlobalVariables]gCurrentForm]);

    //Custom Navbar
    thisNavBar = [[CustomNavBar alloc] initTwoRowBar];
    self.navigationItem.titleView = thisNavBar;
    self.navigationItem.hidesBackButton = YES;

    [self setInitialTextfields];
    [self setTitle];
    [self registerNotifications];
    if (!thisForm)
        thisForm = [[SubmitForm alloc]initWithData];
    
    //check if there is an open job
    

    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSLog(@"Last start time - %@", [preferences objectForKey:@"JobStartTime"]);
    
    /*use when loginmodel is active
     if ([[GlobalVariables myGlobalVariables] gGoto]){
     [self performSegueWithIdentifier:@"gotoSubmitJob" sender:self];
     [thisForm startCountdownWithJobID:[bookingForm objectForKey:@"id"]];
     }     
     */
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoOnroute:) name:@"accepted" object:nil];

}

- (void) setInitialTextfields
{
    //Set textboxes
    if ([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_address"]){
        mapaddress.text=[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_address"];
    } else {
        mapaddress.placeholder = @"Please enter an address";
    }
    
    if ([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_point"]){
        pickup.text =[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_point"];
    } else {
        pickup.placeholder = @"Please enter a pickup location";
    }
    
    if ([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"dropoff_address"]) {
        destination.text =[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"dropoff_address"];
    } else {
        destination.placeholder = @"Please enter a destination";
    }
    
    taxiType.enabled = NO;
    taxiType.text = @"Budget";
    
    NSUserDefaults *preferences = [[NSUserDefaults alloc]init];
    if ([preferences objectForKey:@"ClientNumber"])
    mobileNumber.text = [preferences objectForKey:@"ClientNumber"];
    
}


#pragma mark Buttons/IBActions

- (IBAction)clickedNextButton:(id)sender
{
    [pickup resignFirstResponder]; 
    [destination resignFirstResponder];
    [mapaddress resignFirstResponder];
    

    if (!fare) 
        fare = @"";
    
    NSMutableDictionary* bookingForm =[[GlobalVariables myGlobalVariables]gCurrentForm];
    [bookingForm setObject:pickup.text forKey:@"pickup_point"];
    [bookingForm setObject:mobileNumber.text forKey:@"mobile_number"];
    [bookingForm setObject:fare forKey:@"fare"];
    [bookingForm setObject:taxiType.text forKey:@"taxitype"];
    [[GlobalVariables myGlobalVariables]setGCurrentForm:bookingForm];
    
    if ([mapaddress.text isEqualToString:@""] || !(mapaddress.text)){
        [self.view makeToast:@"Please enter your current address!" duration:1.5 position:@"center"];
    } else if ([destination.text isEqualToString:@""] || !(destination.text)){
        [self.view makeToast:@"Please enter a destination!" duration:1.5 position:@"center"];
    } else if ([mobileNumber.text isEqualToString:@""] || !(mobileNumber.text)){
        [self.view makeToast:@"Please enter your mobile number!" duration:1.5 position:@"center"];
    } else{
        [thisForm submitForm];
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
    
    [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:pickup.text forKey:@"pickup_point"];
}

-(void)gotoOnroute:(NSNotification *)notification
{
    NSString* driverID = [notification.userInfo objectForKey:@"driver_id"];
    [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:driverID forKey:@"driver_id"];
    [thisForm jobAccepted];
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
        picker = [[TaxiTypePicker alloc]initWithTarget:self dataSource:nil delegate:self];
    }
    [picker showPicker];
}


#pragma mark Functional Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"gotoChooseLocation"]) {
        
        NSLog(@"Sender Tag - %i", [sender tag]);            
        ChooseLocationViewController *clVC = [segue destinationViewController];
        clVC.refererTag = [sender tag];
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
    
    //taxiType.text = [[GlobalVariables myGlobalVariables] gTaxiType];
    
    if (pickup.text)
    [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:pickup.text forKey:@"pickup_point"];
    
}


-(void) setTitle
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    if([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_address"] && ([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_address"] || [[[GlobalVariables myGlobalVariables] gCurrentForm]objectForKey:@"dropoff_address"])) {
        
        CLLocationCoordinate2D startLoc;
        CLLocationCoordinate2D endLoc;
        startLoc.latitude = [[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_latitude"]floatValue];
        startLoc.longitude = [[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_longitude"]floatValue];
        endLoc.latitude = [[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"dropoff_latitude"]floatValue];
        endLoc.longitude = [[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"dropoff_longitude"]floatValue];
        
        
        
        [OtherQuery getFareWithlocation:startLoc destination:endLoc taxitype:taxiType.text completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            
            NSLog(@"%@ - %@ - set fare",self.class,NSStringFromSelector(_cmd));
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
            
            if (response && data){            
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
                
                if ([httpResponse statusCode] == 200) {
                    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
                    NSMutableDictionary* olddict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];  
                    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:[NSString stringWithFormat:@"Fare: %@", [[olddict objectForKey:@"fare"]floatValue]] forKey:@"fare"];  
                    [dict setObject:[NSString stringWithFormat:@"Distance: %@",[olddict objectForKey:@"distance"]] forKey:@"distance"];
                    [self performSelectorOnMainThread:@selector(setFare:) withObject:dict waitUntilDone:YES];
                } else {
                    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:@"Fare: RM 0.00" forKey:@"fare"];
                    [dict setObject:@"Please enter droppoff address" forKey:@"distance"];
                    [self performSelectorOnMainThread:@selector(setFare:) withObject:dict waitUntilDone:YES];   
                }
            } else {
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:@"Fare: RM 0.00" forKey:@"fare"];
                [dict setObject:@"Please enter droppoff address" forKey:@"distance"];
                [self performSelectorOnMainThread:@selector(setFare:) withObject:dict waitUntilDone:YES];   
            }
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
    
    [thisNavBar setCustomNavBarTitle:[dict objectForKey:@"fare"] subtitle:[dict objectForKey:@"distance"]];
    fare = [dict objectForKey:@"fare"];
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}


#pragma mark Picker View delegates

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        taxiType.text = @"Budget";
    } else if (row == 1) {
        taxiType.text = @"Premium";        
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    if (row == 0){
        
        return [NSString stringWithFormat: @"Budget"];
    } else{
        return [NSString stringWithFormat: @"Premium"];
    }  
}

@end
