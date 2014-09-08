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
#import "CountDownBox.h"
#import "HTTPQueryModel.h"


@implementation SubmitJobViewController
@synthesize pickupString, destinationString, pickup, destination, mapaddress;

#pragma mark Initialisation

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
    [super viewDidLoad];
    
    if ([[[GlobalVariables myGlobalVariables] gGoto] isEqualToString:@"gotoOnroute"]){
        [self gotoOnroute:nil];
        return;
    } else {
        [[GlobalVariables myGlobalVariables]setGGoto:nil];
    }
    
    NSLog(@"Booking Form - %@",[[GlobalVariables myGlobalVariables]gCurrentForm]);

    //Custom Navbar
    thisNavBar = [[CustomNavBar alloc] initTwoRowBar];
    self.navigationItem.titleView = thisNavBar;
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.userInteractionEnabled = NO;

    
    [self setInitialTextfields];
    if (!thisForm)
        thisForm = [[SubmitForm alloc]initWithData];
    thisForm.delegate = self;
    
    [pickup setDelegate:self];

    //use when loginmodel is active
     if ([[[GlobalVariables myGlobalVariables] gGoto] isEqualToString:@"gotoSubmitJob"]){
         [thisForm startCountdownWithJobID:[[[GlobalVariables myGlobalVariables]gCurrentForm] objectForKey:@"id"]];
         [[[GlobalVariables myGlobalVariables]gCurrentForm]setObject:@"" forKey:@"starttime"];    
     }     
     [self setTitle];
    escapeButton.enabled = NO;
    
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setInitialTextfields
{
    //Set textboxes
    if ([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_address"]){
        mapaddress.text=[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_address"];
    } else {
        mapaddress.placeholder = NSLocalizedString(@"Please enter an address", @"");
    }
    
    if ([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_point"]){
        pickup.text =[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_point"];
    } else {
        pickup.placeholder = NSLocalizedString(@"Please enter a pickup location", @"");
    }
    
    if ([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"dropoff_address"]) {
        destination.text =[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"dropoff_address"];
    } else {
        destination.placeholder = NSLocalizedString(@"Please enter a destination", @"");
    }
    
    taxiType.enabled = NO;
    taxiType.text = @"Budget";
    if(![[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"taxi_type"]) {
    [[[GlobalVariables myGlobalVariables]gCurrentForm]setObject:@"Budget" forKey:@"taxi_type"];
    }
    
    NSUserDefaults *preferences = [[NSUserDefaults alloc]init];
    if ([preferences objectForKey:@"ClientNumber"]){
        mobileNumber.text = [preferences objectForKey:@"ClientNumber"];
        [[[GlobalVariables myGlobalVariables]gCurrentForm]setObject:mobileNumber.text forKey:@"mobile_number"];
    }
    
}


#pragma mark Buttons/IBActions

- (IBAction)clickedNextButton:(id)sender
{
    [pickup resignFirstResponder]; 
    [destination resignFirstResponder];
    [mapaddress resignFirstResponder];

    
    [[[GlobalVariables myGlobalVariables]gCurrentForm] setObject:pickup.text forKey:@"pickup_point"];
    [[[GlobalVariables myGlobalVariables]gCurrentForm] setObject:mobileNumber.text forKey:@"mobile_number"];
    //[[[GlobalVariables myGlobalVariables]gCurrentForm] setObject:fare forKey:@"fare"];
    [[[GlobalVariables myGlobalVariables]gCurrentForm] setObject:taxiType.text forKey:@"taxi_type"];
    
    if ([mapaddress.text isEqualToString:@""] || !(mapaddress.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your current address!", @"") duration:1.5 position:@"center"];
    } else if ([destination.text isEqualToString:@""] || !(destination.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your destination!", @"") duration:1.5 position:@"center"];
    } else if ([mobileNumber.text isEqualToString:@""] || !(mobileNumber.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your mobile number!", @"") duration:1.5 position:@"center"];
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
    
    if (pickup.text)
    [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:pickup.text forKey:@"pickup_point"];
    [[[GlobalVariables myGlobalVariables]gCurrentForm]setObject:taxiType.text forKey:@"taxi_type"];
    escapeButton.enabled = NO;
}

-(void)gotoOnroute:(NSNotification *)notification
{
    if ([[[GlobalVariables myGlobalVariables]gGoto] isEqualToString:@"gotoOnroute"]) {
        [self performSegueWithIdentifier:@"gotoOnroute" sender:nil];
        return;
    }

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
    escapeButton.enabled = YES;
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


-(void) setTitle
{
    [[[GlobalVariables myGlobalVariables]gCurrentForm]setObject:@"" forKey:@"fare"];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:NSLocalizedString(@"Fare: - ", @"") forKey:@"fare"];
    [dict setObject:NSLocalizedString(@"Please enter dropoff address", @"") forKey:@"distance"];
    [self performSelectorOnMainThread:@selector(setFare:) withObject:dict waitUntilDone:YES];  
    
    
    if([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"pickup_address"] && [[[GlobalVariables myGlobalVariables] gCurrentForm]objectForKey:@"dropoff_address"]) {

        NSMutableDictionary* fareForm = [[NSMutableDictionary alloc] initWithDictionary:[[GlobalVariables myGlobalVariables]gCurrentForm]];
        [fareForm setObject:@"" forKey:@"starttime"];
        NSMutableDictionary* dataForm = [[NSMutableDictionary alloc]init];
        [dataForm setObject:fareForm forKey:@"job"];
        
        HTTPQueryModel* newQuery;
        newQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"getFare" Data:dataForm completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if ([httpResponse statusCode] == 200) {
                NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
                NSMutableDictionary* fareDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                NSLog(@"get Fare - %@",fareDict);
                
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                [dict setObject:[NSString stringWithFormat:NSLocalizedString(@"Fare: %@ %@", @""), [fareDict objectForKey:@"currency"], [fareDict objectForKey:@"fare"]] forKey:@"fare"];
                [dict setObject:[NSString stringWithFormat:NSLocalizedString(@"Distance: %@", @""),[fareDict objectForKey:@"distance"]] forKey:@"distance"];
                [[[GlobalVariables myGlobalVariables]gCurrentForm]setObject:[fareDict objectForKey:@"fare"] forKey:@"fare"];
                [[[GlobalVariables myGlobalVariables]gCurrentForm]setObject:[fareDict objectForKey:@"currency"] forKey:@"currency"];
                [self performSelectorOnMainThread:@selector(setFare:) withObject:dict waitUntilDone:YES];
            } 

        } failHandler:^{
            
        }];

        
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
        taxiType.text = @"Executive";        
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
        return [NSString stringWithFormat: @"Executive"];
    }  
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    escapeButton.enabled = NO;
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    escapeButton.enabled = YES;
}

-(void)shouldGoToOnRoute:(BOOL)status
{
    [self performSegueWithIdentifier:@"gotoOnroute" sender:nil];

}
@end
