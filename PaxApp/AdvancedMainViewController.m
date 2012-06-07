//
//  AdvancedMainViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 03/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdvancedMainViewController.h"
#import "CustomNavBar.h"

@implementation AdvancedMainViewController

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
    //set top navBar
    CustomNavBar *thisNavBar = [[CustomNavBar alloc] initOneRowBar];    
    self.navigationItem.titleView = thisNavBar;
    [thisNavBar setCustomNavBarTitle:@"Advanced Booking" subtitle:@""];
    [thisNavBar addRightLogo];
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;
    
    
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

@end
