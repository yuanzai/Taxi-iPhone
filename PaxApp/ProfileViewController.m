//
//  ProfileViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 15/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CustomNavBar.h"
#import "ProfileViewController.h"

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
    [thisNavBar setCustomNavBarTitle:@"Profile" subtitle:@""];
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
    mobileField.text = [preferences stringForKey:@"ClientMobile"];
    passwordField.text = [preferences stringForKey:@"ClientPassword"];
    emailField.text = [preferences stringForKey:@"ClientEmail"];
}

- (IBAction)escapeKeyboard:(id)sender
{
    [nameField resignFirstResponder];
    [mobileField resignFirstResponder];
    [passwordField resignFirstResponder];
    [emailField resignFirstResponder];
    
    [preferences setObject:nameField.text forKey:@"ClientName"];
    [preferences setObject:mobileField.text forKey:@"ClientNumber"];
    [preferences setObject:passwordField.text forKey:@"ClientPassword"];
    [preferences setObject:emailField.text forKey:@"ClientEmail"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    [textField resignFirstResponder];
    
    
    
    [preferences setObject:nameField.text forKey:@"ClientName"];
    [preferences setObject:mobileField.text forKey:@"ClientNumber"];
    [preferences setObject:passwordField.text forKey:@"ClientPassword"];
    [preferences setObject:emailField.text forKey:@"ClientEmail"];
    
    return YES;     
}

@end
