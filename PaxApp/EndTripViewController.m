//
//  EndTripViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EndTripViewController.h"
#import "CustomNavBar.h"
#import "OtherQuery.h"
#import "GlobalVariables.h"
#import "Toast+UIView.h"
#import "ActivityProgressView.h"
#import "HTTPQueryModel.h"
@implementation EndTripViewController

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;

    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];

    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:@"Thank you!" subtitle:@""];
    self.navigationItem.hidesBackButton = YES;
    //self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    fareText.text = [NSString stringWithFormat:NSLocalizedString(@"You paid %@ %@ by cash", @""), [[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"currency"], [[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"fare"]];
    starLevel = 0;
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

- (IBAction)touchStar:(id)sender
{
    NSArray* array =[[NSArray alloc]initWithObjects:star1,star2,star3,star4,star5, nil];
    
    for (id obj in array) {
        
        if ([obj tag] <= [sender tag]) {
            
            UIButton *thisStar = obj;
            [thisStar setImage:[UIImage imageNamed:@"stargreen2"] forState:UIControlStateNormal];
            
            
        } else {
            
            UIButton *thisStar = obj;
            [thisStar setImage:[UIImage imageNamed:@"starwhite2"] forState:UIControlStateNormal];
        }
        
    }
    
    
    starLevel = [sender tag];
    
}

-(IBAction)escapeKeyboard:(id)sender
{
    [review resignFirstResponder];
}

-(IBAction)doneButton:(id)sender
{
    [self performSelectorOnMainThread:@selector(showProgress) withObject:nil waitUntilDone:YES];
    NSMutableDictionary* dataDictionary = [[NSMutableDictionary alloc]init];
    [dataDictionary setObject:[[[GlobalVariables myGlobalVariables] gCurrentForm]objectForKey:@"id"] forKey:@"job_id"];
    [dataDictionary setObject:[NSNumber numberWithInt:starLevel] forKey:@"review"];
    [dataDictionary setObject:review.text forKey:@"feedback"];
    
    HTTPQueryModel* newQuery;

    
    newQuery = [[HTTPQueryModel alloc] initURLConnectionWithMethod:@"postReview" Data:dataDictionary completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];

        if ([httpResponse statusCode] == 200) {
            [self performSelectorOnMainThread:@selector(performSegueWithIdentifier:sender:) withObject:@"gotoMain" waitUntilDone:YES];
        } else {
            [self.view makeToast:NSLocalizedString(@"Cannot connect to server", @"") duration:1.5 position:@"center"];
        }
        
    } failHandler:^{
        [self performSelectorOnMainThread:@selector(hideActivityView) withObject:nil waitUntilDone:YES];
        [self.view makeToast:NSLocalizedString(@"Cannot connect to server", @"") duration:1.5 position:@"center"];
    }];
    
}
     
-(void) showProgress
{
    activity = [[ActivityProgressView alloc] initWithFrame:CGRectMake(0, 0, 200, 80) text:NSLocalizedString(@"Connecting...", @"")];
    [self.view addSubview:activity];
}

-(void) hideActivityView
{
    // Stop spinning thingy code
    if (activity)
        [activity removeFromSuperview];
}

-(void) gotoMain
{
    
    [self performSegueWithIdentifier:@"gotoMain" sender:nil];
}

-(IBAction)gotoOnroute:(id)sender
{
    [self performSegueWithIdentifier:@"gotoEnroute" sender:nil];
}
        
@end
