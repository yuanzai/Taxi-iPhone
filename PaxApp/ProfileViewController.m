//
//  ProfileViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 15/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CustomNavBar.h"
#import "ProfileViewController.h"
#import "OtherQuery.h"
#import "Toast+UIView.h"
#import "ActivityProgressView.h"
#import "HTTPQueryModel.h"

@implementation ProfileViewController

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
    preferences = [NSUserDefaults standardUserDefaults];
    //set top navBar
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];    
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:NSLocalizedString(@"Profile", @"") subtitle:@""];
    [thisNavBar addRightLogo];
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    emailField.delegate = self;
    nameField.delegate = self;
    passwordField.delegate = self;
    mobileField.delegate = self;
    [self setFields];
    [super viewDidLoad];
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
    nameField.text = [preferences stringForKey:@"ClientName"];
    mobileField.text = [preferences stringForKey:@"ClientNumber"];
    passwordField.text = [preferences stringForKey:@"ClientPassword"];
    emailField.text = [preferences stringForKey:@"ClientEmail"];
}

- (IBAction)escapeKeyboard:(id)sender
{
    [nameField resignFirstResponder];
    [mobileField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    [textField resignFirstResponder];
    
    
    

    
    return YES;     
}

-(IBAction)clickSaveButton:(id)sender
{
    if ([nameField.text isEqualToString:@""] || !(nameField.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your name!", @"") duration:1.5 position:@"center"];
        return;
    } else if ([mobileField.text isEqualToString:@""] || !(mobileField.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your mobile number!", @"") duration:1.5 position:@"center"];
        return;
    } else if ([emailField.text isEqualToString:@""] || !(emailField.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your email!", @"") duration:1.5 position:@"center"];
        return;
    } else if ([passwordField.text isEqualToString:@""] || !(passwordField.text)){
        [self.view makeToast:NSLocalizedString(@"Please enter your password!", @"") duration:1.5 position:@"center"];
        return;
    }
    
    if ([nameField.text isEqualToString:[preferences stringForKey:@"ClientName"]] && [mobileField.text isEqualToString:[preferences stringForKey:@"ClientNumber"]] && [emailField.text isEqualToString:[preferences stringForKey:@"ClientEmail"]] && [passwordField.text isEqualToString:[preferences stringForKey:@"ClientPassword"]]) {
        [self.view makeToast:NSLocalizedString(@"There are no changes in your profile!", @"") duration:1.5 position:@"center"];
        return;
        
    }
    
    myAlert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"\n\nSaving...", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [myAlert show];
    
    NSMutableDictionary* formData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary* dictdata = [[NSMutableDictionary alloc]init];
    
    [dictdata setObject:emailField.text forKey:@"email"];
    [dictdata setObject:mobileField.text forKey:@"mobile_number"];
    [dictdata setObject:nameField.text forKey:@"name"];
    [dictdata setObject:passwordField.text forKey:@"password"];
    [formData setObject:dictdata forKey:@"passenger"];
    
    
    HTTPQueryModel* newQuery;
    newQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"postUpdateProfile" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
        
        if (error)
            NSLog(@"%@",error.description);
        
        NSDictionary* dict;
        NSDictionary* jobdict;
        NSDictionary* maindict;
        
        int success;
        
        if (data){
            maindict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            dict = [maindict objectForKey:@"user"];
            jobdict = [maindict objectForKey:@"last_job"];
            success = [[maindict objectForKey:@"success"]intValue];
            
            NSLog(@"%@ - %@ - Data from server - %@",self.class,NSStringFromSelector(_cmd),maindict);
            
            if (success && [httpResponse statusCode] == 200 && success == 1) {
                [self performSelectorOnMainThread:@selector(hideAlert:) withObject:nil waitUntilDone:YES];
            } else if (success != 1) {
                // Wrong
                NSString* errors = [maindict objectForKey:@"errors"];
                [self performSelectorOnMainThread:@selector(hideAlert:) withObject:errors waitUntilDone:YES];
            } else{
                // Failed
                [self performSelectorOnMainThread:@selector(hideAlert:) withObject:NSLocalizedString(@"Cannot connect to server", @"") waitUntilDone:YES];
            }
        }
    } failHandler:^{
        [self performSelectorOnMainThread:@selector(hideAlert:) withObject:NSLocalizedString(@"Cannot connect to server", @"") waitUntilDone:YES];
    }];
}

-(void)hideAlert:(NSString*) text
{
    [myAlert dismissWithClickedButtonIndex:-1 animated:YES];
    myAlert = nil;
    if(text){
    myAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [myAlert show];
    } else {
        [preferences setObject:nameField.text forKey:@"ClientName"];
        [preferences setObject:mobileField.text forKey:@"ClientNumber"];
        [preferences setObject:passwordField.text forKey:@"ClientPassword"];
        [preferences setObject:emailField.text forKey:@"ClientEmail"];
    }
}
@end
