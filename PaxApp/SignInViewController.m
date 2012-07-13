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
#import "LoginModel.h"

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
    [self registerNotification];
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    LoginModel *firstLogin = [[LoginModel alloc]init];
    [firstLogin loginWithPreferences];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    NSMutableDictionary* bookingForm = [[NSMutableDictionary alloc]init];
    [[GlobalVariables myGlobalVariables] setGCurrentForm:bookingForm];
    [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:@"ios" forKey:@"platform"];
    //set top navBar
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];    
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:@"Welcome" subtitle:@""];
    [thisNavBar addRightLogo];
    self.navigationItem.hidesBackButton = YES;
    
    registerView.hidden = YES;
    cancelButton.hidden = YES;
    okButton.hidden = YES;
    fakeSplash.hidden = NO;
    preferences = [NSUserDefaults standardUserDefaults];



}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
     
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
     
     
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMain:) name:@"gotoMain" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSubmitJob:) name:@"gotoSubmitJob" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoOnroute:) name:@"gotoOnroute" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLogin:) name:@"gotoLogin" object:nil];
}
// param names for register method
// email - email validation
// mobile_number - numeric
// password - 6 char
// name
     
// sign in 
// email
// password

// register return success/error
// success message?? status 201
// error message?? print message or interpret?? status 422, login fail 401

// do views
// do queries
// link queries and views
// link preferences and queries
// 

-(void)showLogin
{
    fakeSplash.hidden = YES;    
    
}

-(IBAction)clickRegister:(id)sender
{
    registerView.hidden = NO;
    registerButton.hidden = YES;
    loginButton.hidden = YES;
    cancelButton.hidden = NO;
    okButton.hidden = NO;
}

-(IBAction)escapeKeyboard:(id)sender
{
    
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
    [nameField resignFirstResponder];
    [mobileField resignFirstResponder];
    
}

-(IBAction)clickOK:(id)sender
{
    [OtherQuery registerWithEmail:emailField.text password:passwordField.text name:nameField.text mobile:mobileField.text completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(response && data) {
            
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
                               
            if ([httpResponse statusCode] == 201) {
                //register success
                [preferences setObject:nameField.text forKey:@"ClientName"];
                [preferences setObject:mobileField.text forKey:@"ClientNumber"];
                [preferences setObject:passwordField.text forKey:@"ClientPassword"];
                [preferences setObject:emailField.text forKey:@"ClientEmail"];
                //[self performSelectorOnMainThread:@selector(gotoMain:) withObject:nil waitUntilDone:YES];
                [self performSelectorOnMainThread:@selector(processLogin) withObject:nil waitUntilDone:YES]; 

                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dict);

            } else if ([httpResponse statusCode] == 422) {
                NSLog(@"%i",[httpResponse statusCode]);
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                [self performSelectorOnMainThread:@selector(printLabel:) withObject:[dict objectForKey:@"errors"] waitUntilDone:YES];
                NSLog(@"%@",dict);
                
                //register fail
            } else {
                [self performSelectorOnMainThread:@selector(printLabel:) withObject:@"Cannot connect" waitUntilDone:YES];
            }
        } else {
            // error out
        }
    }];
     
}
            
-(IBAction)clickCancel:(id)sender
{
    registerView.hidden = YES;
    cancelButton.hidden = YES;
    okButton.hidden = YES;
    registerButton.hidden = NO;
    loginButton.hidden = NO;
}

-(IBAction)login:(id)sender
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    //[self gotoMain:nil];
    LoginModel* secondLogin = [[LoginModel alloc]init];
    [secondLogin loginWithEmail:emailField.text password:passwordField.text];
}

-(void)gotoMain:(NSNotification*) notification
{
    [self performSelectorOnMainThread:@selector(gotoMainSelector:) withObject:nil waitUntilDone:YES];
}

-(void)gotoMainSelector:(id)sender
{
    if (passwordField.text && emailField.text) {
    [preferences setObject:passwordField.text forKey:@"ClientPassword"];
    [preferences setObject:emailField.text forKey:@"ClientEmail"];
        NSLog(@"%@",[preferences objectForKey:@"ClientPassword"]);
        NSLog(@"%@",[preferences objectForKey:@"ClientEmail"]);
              
    }
    [self performSegueWithIdentifier:@"gotoMain" sender:self];
}

-(void)gotoSubmitJob:(id)sender
{

    [self performSegueWithIdentifier:@"gotoSubmitJob" sender:self];
}

-(void)gotoLogin:(NSNotification*) notification
{
    [self performSelectorOnMainThread:@selector(gotoLoginSelector) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(printLabel:) withObject:[[notification userInfo] objectForKey:@"errors"] waitUntilDone:YES];
}

-(void)gotoLoginSelector
{
    [self showLogin];
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
@end
