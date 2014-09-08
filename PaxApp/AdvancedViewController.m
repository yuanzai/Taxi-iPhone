//
//  AdvancedViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdvancedViewController.h"
#import "CustomNavBar.h"
#import "DateTimePicker.h"
#import "TaxiTypePicker.h"
#import "AdvancedBookingQuery.h"
#import "GlobalVariables.h"
#import "ChooseLocationViewController.h"
#import "FavouritesViewController.h"
#import "Toast+UIView.h"
#import "HTTPQueryModel.h"


@implementation AdvancedViewController

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
    if (![[GlobalVariables myGlobalVariables]gAdvancedForm])
        [[GlobalVariables myGlobalVariables]setGAdvancedForm:[[NSMutableDictionary alloc]init]];
    
    NSLog(@"Advanced Form - %@",[[GlobalVariables myGlobalVariables]gAdvancedForm]);
    //set top navBar
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];    
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:NSLocalizedString(@"Advanced Booking", @"") subtitle:@""];
    [thisNavBar addRightLogo];
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;

    preferences = [NSUserDefaults standardUserDefaults];

    bookingForm = [[NSMutableDictionary alloc] init];
    escapeButton.enabled = false;

    locationField.delegate = self;
    mobileField.delegate = self;
    
    myPicker = [[DateTimePicker alloc]init];
    [myPicker newPickerWithTarget:self];
    
    
    dateField.enabled = NO;
    
    taxiType.enabled = NO;

    [self setFields];
    [super viewDidLoad];
}

-(void)viewDidDisappear:(BOOL)animated
{
    bookingForm = nil;
    myPicker = nil;
    taxiPicker = nil;
}

- (void) setFields
{
    if (![[[GlobalVariables myGlobalVariables]gAdvancedForm]objectForKey:@"pickup_latitude"] && ![[[GlobalVariables myGlobalVariables]gAdvancedForm]objectForKey:@"pickup_longitude"]) {
        if ( [[GlobalVariables myGlobalVariables]gUserCoordinate].latitude && [[GlobalVariables myGlobalVariables]gUserCoordinate].longitude && [[GlobalVariables myGlobalVariables]gUserAddress]) {
            pickupField.text = [[[GlobalVariables myGlobalVariables] gAdvancedForm] objectForKey:@"pickup_address"];
            [[[GlobalVariables myGlobalVariables]gAdvancedForm]setValue:[[GlobalVariables myGlobalVariables]gUserAddress] forKey:@"pickup_address"];
            [[[GlobalVariables myGlobalVariables]gAdvancedForm]setValue:[NSString stringWithFormat:@"%f", [[GlobalVariables myGlobalVariables]gUserCoordinate].latitude] forKey:@"pickup_latitude"];
            [[[GlobalVariables myGlobalVariables]gAdvancedForm]setValue:[NSString stringWithFormat:@"%f", [[GlobalVariables myGlobalVariables]gUserCoordinate].longitude] forKey:@"pickup_longitude"];           
            
        }
    
    } else {
        if ([[GlobalVariables myGlobalVariables]gUserCoordinate].latitude && [[GlobalVariables myGlobalVariables]gUserCoordinate].longitude && [[GlobalVariables myGlobalVariables]gUserAddress]) {
            pickupField.text = [[[GlobalVariables myGlobalVariables] gAdvancedForm] objectForKey:@"pickup_address"];
            float gpsLatitude = [[GlobalVariables myGlobalVariables]gUserCoordinate].latitude;
            float gpsLongitude = [[GlobalVariables myGlobalVariables]gUserCoordinate].longitude;
            
            float savedLatitude = [[[[GlobalVariables myGlobalVariables]gAdvancedForm]objectForKey:@"pickup_latitude"]floatValue];
            float savedLongitude = [[[[GlobalVariables myGlobalVariables]gAdvancedForm]objectForKey:@"pickup_longitude"]floatValue];
            
            if (abs(gpsLatitude - savedLatitude) > 0.002 || abs(gpsLongitude - savedLongitude) > 0.002){
                
            }
        }
    }
    
    
    if ([[GlobalVariables myGlobalVariables] gAdvancedForm]){
            pickupField.text = [[[GlobalVariables myGlobalVariables] gAdvancedForm] objectForKey:@"pickup_address"];
        
        
        locationField.text = [[[GlobalVariables myGlobalVariables] gAdvancedForm] objectForKey:@"pickup_point"];
        dropoffField.text = [[[GlobalVariables myGlobalVariables] gAdvancedForm] objectForKey:@"dropoff_address"];
        taxiType.text = [[[GlobalVariables myGlobalVariables] gAdvancedForm] objectForKey:@"taxitype"];
        dateField.text = [[[GlobalVariables myGlobalVariables] gAdvancedForm] objectForKey:@"pickup_datetime"];
        
    }
    
    if (![bookingForm valueForKey:@"taxitype"]) {
        taxiType.text = @"Budget";
    }
    
    mobileField.text = [preferences objectForKey:@"ClientNumber"];
}

-(IBAction) openDatePicker:(id)sender
{
    [myPicker showPicker];
    escapeButton.enabled = true;
}

- (IBAction) escapeKeyboard:(id)sender
{
    NSLog(@"escapeKeyboard");
    [locationField resignFirstResponder];
    [mobileField resignFirstResponder];
    
    
    if (myPicker.isOpen){
    [myPicker hidePicker];
    dateField.text = [myPicker selectedDate];
    }
    
    [taxiPicker hidePicker];
    

    if (![preferences objectForKey:@"ClientName"])
        [preferences setObject:@"" forKey:@"ClientName"];
    
    [[[GlobalVariables myGlobalVariables] gAdvancedForm] setObject:[preferences objectForKey:@"ClientName"] forKey:@"passenger_name"];

    
    if (pickupField.text)
    [[[GlobalVariables myGlobalVariables] gAdvancedForm] setObject:pickupField.text forKey:@"pickup_address"];

    if (dropoffField.text)
    [[[GlobalVariables myGlobalVariables] gAdvancedForm] setObject:dropoffField.text forKey:@"dropoff_address"];

    [[[GlobalVariables myGlobalVariables] gAdvancedForm] setObject:@"ios" forKey:@"platform"];

    if (locationField.text)
    [[[GlobalVariables myGlobalVariables] gAdvancedForm] setObject:locationField.text forKey:@"pickup_point"];

    if (mobileField.text)
    [[[GlobalVariables myGlobalVariables] gAdvancedForm] setObject:mobileField.text forKey:@"mobile_number"];
    
    [[[GlobalVariables myGlobalVariables] gAdvancedForm] setObject:@"" forKey:@"fare"];
    
    [[[GlobalVariables myGlobalVariables] gAdvancedForm] setObject:taxiType.text forKey:@"taxi_type"];
    
    if ([myPicker selectedDateProperString] && dateField.text)
    [[[GlobalVariables myGlobalVariables] gAdvancedForm] setObject:[myPicker selectedDateProperString]forKey:@"pickup_datetime"];


    escapeButton.enabled = false;
    
    

}

- (IBAction)openTaxiPicker:(id)sender
{
    if (!taxiPicker) {
        taxiPicker = [[TaxiTypePicker alloc]initWithTarget:self dataSource:nil delegate:self];
    }
    [taxiPicker showPicker];
    escapeButton.enabled = true;
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

-(IBAction)pressedSubmitButton:(id)sender
{

    if ([pickupField.text isEqualToString:@""] || !(pickupField.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your current address!", @"") duration:1.5 position:@"center"];
        return;
    } else if ([dropoffField.text isEqualToString:@""] || !(dropoffField.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your destination!", @"") duration:1.5 position:@"center"];
        return;
    } else if ([mobileField.text isEqualToString:@""] || !(mobileField.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your mobile number!", @"") duration:1.5 position:@"center"];
        return;
    } else if ([dateField.text isEqualToString:@""] || !(dateField.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your pickup date and time!", @"") duration:1.5 position:@"center"];
        return;
    } 
    
    UIAlertView* submittedAlert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"\n\n%@",NSLocalizedString(@"Connecting...", @"")] delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [submittedAlert show];
    
    NSMutableDictionary* formData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[GlobalVariables myGlobalVariables] gAdvancedForm],@"job",nil ] ;
                                                                                                                                            
    HTTPQueryModel* myQuery;
    myQuery = [[HTTPQueryModel alloc] initURLConnectionWithMethod:@"postAdvancedJob" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
        
        if ([httpResponse statusCode] == 201) {
            [submittedAlert dismissWithClickedButtonIndex:0 animated:YES];
            [[GlobalVariables myGlobalVariables]setGAdvancedForm:[[NSMutableDictionary alloc]init]];
            UIAlertView* submittedAlert = [[UIAlertView alloc] initWithTitle:@"Submitted" message:NSLocalizedString(@"\nYour booking has been submitted.\nPlease see the My Trips tab for booking information.", @"") delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
            [submittedAlert show];
        } else {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"Error - %@",dict);
            
            [submittedAlert dismissWithClickedButtonIndex:0 animated:YES];
            
            UIAlertView* submittedAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"Your booking was not submited.\nPlease try again.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:nil];
            [submittedAlert show];
        }
    } failHandler:^{
        [submittedAlert dismissWithClickedButtonIndex:0 animated:YES];
        
        UIAlertView* submittedAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"Your booking was not submited.\nPlease try again.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:nil];
        [submittedAlert show];
    }];
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
        clVC.refererTag = [sender tag];
        //sender tag 11 = top chooselocation button, tag 12 = bottom choose location button
    } else if  ([[segue identifier] isEqualToString:@"gotoFavourites"]) {
        
        NSLog(@"Sender Tag - %i", [sender tag]);    
        
        FavouritesViewController *fVC = [segue destinationViewController];
        fVC.refererTag = [sender tag];
    }
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == locationField || textField == mobileField) {
        escapeButton.enabled = YES;
    }
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == locationField || textField == mobileField) {
        escapeButton.enabled = NO;
        [locationField resignFirstResponder];

    }
    return YES;

}
@end
