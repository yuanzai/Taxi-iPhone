//
//  RatingAlert.m
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RatingAlert.h"

@implementation RatingAlert

-(void) launchMainBox: (id)setDelegate
{
    mainBox = [[UIAlertView alloc] init];
    [mainBox setDelegate:self];
    [mainBox setTitle:@"You have been picked up. Congrats!"];
    [mainBox setMessage:@"Please give a rating!"];
    
    [mainBox addButtonWithTitle:@"Good trip"];
    [mainBox addButtonWithTitle:@"Bad trip"];
    [mainBox addButtonWithTitle:@"OK"];
    
    [mainBox show];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@ - %@ - Button Pressed: %i",self.class,NSStringFromSelector(_cmd),buttonIndex);
    
    if(alertView == mainBox) {    
        
        [self launchSubBox:buttonIndex];


    } else if(alertView == negativeBox) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Button %i", buttonIndex);
                break;
                
            case 1:
                NSLog(@"Button %i", buttonIndex);
                break;
                
            case 2:
                NSLog(@"Button %i", buttonIndex);
                break;
                
            case 3:
                NSLog(@"Button %i", buttonIndex);
                [self launchMainBox:nil];
                break;
        }            
    } else if(alertView == positiveBox) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"Button %i", buttonIndex);
                break;
                
            case 1:
                NSLog(@"Button %i", buttonIndex);
                [self launchMainBox:nil];

                break;
    }
    }
    
    
}


-(void)launchSubBox:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        
        negativeBox = [[UIAlertView alloc] init];
        
        [negativeBox setDelegate:self];
        [negativeBox setTitle:@"You have been picked up. Congrats!"];
        [negativeBox setMessage:@"Please give a rating!"];
        
        [negativeBox addButtonWithTitle:@"Driver was late"];
        [negativeBox addButtonWithTitle:@"Driver did not show up"];
        [negativeBox addButtonWithTitle:@"Service was poor"];
        
        
        [negativeBox addButtonWithTitle:@"Back"];
        


        [negativeBox show];
    } else if (buttonIndex ==0) {
        
        positiveBox = [[UIAlertView alloc] init];
        
        [positiveBox setDelegate:self];
        [positiveBox setTitle:@"You have been picked up. Congrats!"];
        [positiveBox setMessage:@"Please give a rating!"];
        
        [positiveBox addButtonWithTitle:@"Excellent Trip!"];
        
        [positiveBox addButtonWithTitle:@"Back"];

        
        [positiveBox show];

    }
    
}

@end
