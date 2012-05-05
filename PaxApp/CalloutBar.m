//
//  CalloutBar.m
//  PaxApp
//
//  Created by Junyuan Lau on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalloutBar.h"
#import "GlobalVariables.h"

@implementation CalloutBar
@synthesize topBar,bottomBar;
-(void)hideUserBar
{
    [topBar setHidden:YES];
    [bottomBar setHidden:YES];
}

-(void)showUserBarWithGeoAddress
{
    [topBar setAlpha:0];
    [bottomBar setAlpha:0];
    [topBar setHidden:NO];
    [bottomBar setHidden:NO];
    
    [topBar setText:@"Your Current Location"];
    [bottomBar setText:[[GlobalVariables myGlobalVariables]gUserAddress]];
     
    [UIView animateWithDuration:.5
                          delay:0 
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) 
     {
         [topBar setAlpha:1];
         [bottomBar setAlpha:1];
         //[topBar setHidden:YES];
         //[bottomBar setHidden:YES];
         
     }
                     completion:^(BOOL finished) 
     {
         [UIView animateWithDuration:1.5 
                               delay:10 
                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                          animations:^(void) 
          {
              [topBar setAlpha:0];
              [bottomBar setAlpha:0];
          } 
                          completion:^(BOOL finished) 
          {
              if(finished)
                  //[topBar setHidden:YES];
             // [bottomBar setHidden:YES];
                  NSLog(@"FadedOut");
          }];
     }
     
     
     ];
}


-(void)showDriverBarWithETA:(NSString*)ETA driver_id:(NSString*)driver_id;
{
    [topBar setAlpha:0];
    [bottomBar setAlpha:0];
    [topBar setHidden:NO];
    [bottomBar setHidden:NO];
    
    [topBar setText:@"Selected Driver"];
    [bottomBar setText:[NSString stringWithFormat:@"Driver is %@ minutes away",ETA]];
    
    [UIView animateWithDuration:.5
                          delay:0 
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) 
     {
         [topBar setAlpha:1];
         [bottomBar setAlpha:1];
         
     }
                     completion:^(BOOL finished) 
     {
         [UIView animateWithDuration:1.5 
                               delay:10 
                             options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                          animations:^(void) 
          {
              [topBar setAlpha:0];
              [bottomBar setAlpha:0];
              //[topBar setHidden:YES];
              //[bottomBar setHidden:YES];
          } 
                          completion:^(BOOL finished) 
          {
              if(finished)

                  NSLog(@"FadedOut");
          }];
     }
     
     
     ];
}

@end
