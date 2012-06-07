//
//  EndTripViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EndTripViewController.h"
#import "CustomNavBar.h"

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
    [thisNavBar addRightLogo];
    self.navigationItem.hidesBackButton = YES;
    self.tabBarController.tabBar.userInteractionEnabled = YES;


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
    
    
}

-(IBAction)escapeKeyboard:(id)sender
{
    [review resignFirstResponder];
}

@end
