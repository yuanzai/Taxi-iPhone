//
//  SubmitJobViewController.m
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubmitJobViewController.h"
#import "GlobalVariablePositions.h"
#import "SubmitClass.h"

@implementation SubmitJobViewController
@synthesize pickupString, destinationString, pickup, destination;

- (IBAction)clickedNextButton:(id)sender
{
    [pickup resignFirstResponder];    
    [destination resignFirstResponder];    
    
    [[GlobalVariablePositions myGlobalVariablePositions] setPickupString:pickup.text];
    [[GlobalVariablePositions myGlobalVariablePositions] setDestinationString:destination.text];
    
    //pickupString = [[NSString alloc]initWithString:pickup.text];
    //destinationString = [[NSString alloc]initWithString:destination.text];
    
    newSubmitClass = [[SubmitClass alloc]init];
    
    [newSubmitClass startSubmitProcesswithdriverID:@"0"
                                     pickupAddress:[[GlobalVariablePositions myGlobalVariablePositions] pickupString] 
                                destinationAddress:[[GlobalVariablePositions myGlobalVariablePositions] destinationString]];
    
    NSLog(@"%@ - pickup: %@, destination: %@",self.class,pickup.text, destination.text);
    
    }

- (IBAction)escapeKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)setTextfields:(id)sender
{
    [sender resignFirstResponder];    
    
    [[GlobalVariablePositions myGlobalVariablePositions] setPickupString:pickup.text];
    [[GlobalVariablePositions myGlobalVariablePositions] setDestinationString:destination.text];
    
    //pickupString = [[NSString alloc]initWithString:pickup.text];
    //destinationString = [[NSString alloc]initWithString:destination.text];
}

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
    pickup.text =[[GlobalVariablePositions myGlobalVariablePositions] pickupString];
    destination.text =[[GlobalVariablePositions myGlobalVariablePositions] destinationString];
    
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
