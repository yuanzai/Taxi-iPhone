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
    //set top navBar
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];    
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:@"Advanced Booking" subtitle:@""];
    [thisNavBar addRightLogo];
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;

    preferences = [NSUserDefaults standardUserDefaults];

    bookingForm = [[NSMutableDictionary alloc] init];
    myPicker = [[DateTimePicker alloc]init];
    [myPicker newPickerWithTarget:self];
    
    taxiPicker = [[TaxiTypePicker alloc]initWithTarget:self dataSource:nil delegate:self];
    
    dateField.enabled = NO;
    
    taxiType.enabled = NO;

    [self setFields];
    [super viewDidLoad];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[GlobalVariables myGlobalVariables]setGAdvancedForm:bookingForm];
}

- (void) setFields
{

    if ([[GlobalVariables myGlobalVariables] gAdvancedForm]){
        bookingForm = [[GlobalVariables myGlobalVariables] gAdvancedForm];
        
        
        pickupField.text = [bookingForm valueForKey:@"pickup_address"];
        locationField.text = [bookingForm valueForKey:@"pickup_point"];
        dropoffField.text = [bookingForm valueForKey:@"dropoff_address"];
        taxiType.text = [bookingForm valueForKey:@"taxitype"];
        dateField.text = [bookingForm valueForKey:@"pickup_datetime"];
        
    }
    
    if (![bookingForm valueForKey:@"taxitype"]) {
        taxiType.text = @"Budget";
    }
    
    mobileField.text = [preferences objectForKey:@"ClientNumber"];
}

-(IBAction) openDatePicker:(id)sender
{
    [myPicker showPicker];
}

- (IBAction) escapeKeyboard:(id)sender
{
    [pickupField resignFirstResponder];
    [locationField resignFirstResponder];
    [dropoffField resignFirstResponder];
    dateField.text = [myPicker selectedDate];
    
    [myPicker hidePicker];
    [taxiPicker hidePicker];
    

    if (![preferences objectForKey:@"ClientName"])
        [preferences setObject:@"" forKey:@"ClientName"];
    
    [bookingForm setObject:[preferences objectForKey:@"ClientName"] forKey:@"passenger_name"];
    
    /*
    @try {
        [bookingForm setObject:pickupField.text forKey:@"pickup_address"];
        [bookingForm setObject:dropoffField.text forKey:@"dropoff_address"];
        [bookingForm setObject:locationField.text forKey:@"pickup_point"];
        [bookingForm setObject:mobileField.text forKey:@"mobile_number"];
        [bookingForm setObject:dateField.text forKey:@"pickup_datetime"];

    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    */
    
    if (pickupField.text)
    [bookingForm setObject:pickupField.text forKey:@"pickup_address"];

    if (dropoffField.text)
    [bookingForm setObject:dropoffField.text forKey:@"dropoff_address"];

    [bookingForm setObject:@"ios" forKey:@"platform"];

    if (locationField.text)
    [bookingForm setObject:locationField.text forKey:@"pickup_point"];

    if (mobileField.text)
    [bookingForm setObject:mobileField.text forKey:@"mobile_number"];
    
    [bookingForm setObject:@"" forKey:@"fare"];
    
    [bookingForm setObject:taxiType.text forKey:@"taxitype"];
    
    if (dateField.text)
    [bookingForm setObject:dateField.text forKey:@"pickup_datetime"];

    
    /*
    [bookingForm setObject:pickup_latitude forKey:@"pickup_latitude"];
    [bookingForm setObject:pickup_longitude forKey:@"pickup_longitude"];
    
    [bookingForm setObject:dropoff_latitude forKey:@"dropoff_latitude"];
    [bookingForm setObject:dropoff_longitude forKey:@"dropoff_longitude"];
     */
    
    
    

    [[GlobalVariables myGlobalVariables] setGAdvancedForm:bookingForm];

}

- (IBAction)openTaxiPicker:(id)sender
{
    [taxiPicker showPicker];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    
    
    [AdvancedBookingQuery submitJobWithDictionary:bookingForm completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
    
    if ([httpResponse statusCode] == 201) {
        //NSString* job_id = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
        
        UIAlertView* submittedAlert = [[UIAlertView alloc] initWithTitle:@"Done!" message:@"Your booking has been submited./nPlease check the 'My Trips' tab to check for your driver." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [submittedAlert show];
        
        [[GlobalVariables myGlobalVariables]setGAdvancedForm:nil];
        
    } else if ([httpResponse statusCode] == 422) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"Error - %@",dict);
        UIAlertView* submittedAlert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Your booking was not submited./nPlease try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [submittedAlert show];
    } else {
    }
    
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
