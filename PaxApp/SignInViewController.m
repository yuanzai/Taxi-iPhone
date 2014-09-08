//
//  SignInViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignInViewController.h"
#import "CustomNavBar.h"
#import "OtherQuery.h"
#import "GlobalVariables.h"
#import "JobCycleQuery.h"
#import "Constants.h"
#import "HTTPQueryModel.h"
#import "Toast+UIView.h"


@implementation SignInViewController

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

-(void)viewDidAppear:(BOOL)animated
{

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Test Localised Strings");
    NSLog(@"%@",NSLocalizedString(@"Testtest", @"This is a comment about my default value string."));
    NSLocalizedString(@"Testtest", @"");
    
    
    
    escapeButton.enabled = NO;
    myLogin = [[LoginModel alloc]init];
    myLogin.delegate = self;
    preferences = [NSUserDefaults standardUserDefaults];
    
    if ([preferences objectForKey:@"ClientEmail"])
        emailField.text = [preferences objectForKey:@"ClientEmail"];
    if ([preferences objectForKey:@"ClientPassword"])
        passwordField.text = [preferences objectForKey:@"ClientPassword"];
    emailField.delegate = self;
    passwordField.delegate = self;
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

-(IBAction)escapeKeyboard:(id)sender
{
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
    escapeButton.enabled = NO;
}

-(IBAction)clickLoginButton:(id)sender
{
    if ([emailField.text isEqualToString:@""] || !(emailField.text)){
        [self.view makeToast:@"Please enter your email!" duration:1.5 position:@"center"];
    } else if ([passwordField.text isEqualToString:@""] || !(passwordField.text)){
        [self.view makeToast:@"Please enter your password!" duration:1.5 position:@"center"];
    } else {
        [myLogin loginWithEmail:emailField.text password:passwordField.text];
        topLabel.text = @"Connecting...";
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView setCenter:CGPointMake(self.view.bounds.size.width / 2, (self.view.bounds.size.height / 2) +30)];
        [self.view addSubview:activityView];
        [activityView startAnimating];
        viewBlocker = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [self.view addSubview:viewBlocker];
    }
}

-(IBAction)clickRegisterButton:(id)sender
{
    [self performSegueWithIdentifier:@"gotoRegister" sender:nil];
}

-(void)gotoLogin:(NSNotification*) notification
{
    [self performSelectorOnMainThread:@selector(showLogin) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(printLabel:) withObject:[[notification userInfo] objectForKey:@"errors"] waitUntilDone:YES];
}
     
-(void)printLabel:(NSString*) label
{
    topLabel.text = label;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    escapeButton.enabled = YES;
}

-(void) hideSpinner
{
    [activityView startAnimating];
    [activityView removeFromSuperview];
    [viewBlocker removeFromSuperview];
}

    

-(void)loginStatus:(NSString *)status withError:(NSString *)error
{
    if ([status isEqualToString:@"gotoLogin"]){
        [self performSelectorOnMainThread:@selector(hideSpinner) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(printLabel:) withObject:error waitUntilDone:YES];
    } else if ([status isEqualToString:@"gotoMain"]) {
        [self performSelectorOnMainThread:@selector(hideSpinner) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(performSegueWithIdentifier:sender:) withObject:@"gotoMain" waitUntilDone:YES];
    }
}
@end
