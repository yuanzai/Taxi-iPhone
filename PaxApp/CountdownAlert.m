//
//  CountdownAlert.m
//  PaxApp
//
//  Created by Junyuan Lau on 30/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountdownAlert.h"

@implementation CountdownAlert
@synthesize countdownTimer;

-(void) launchAlertBox: (id)setDelegate
{
    //self.isOpen = YES;
    dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:setDelegate];
    [dialog setTitle:@"Waiting for driver reply"];
    [dialog setMessage:@" "];
    [dialog addButtonWithTitle:@"Cancel"];
    
    
    timerView = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [timerView setBackgroundColor:[UIColor clearColor]];  
    [timerView setAlpha:1];
    [timerView setTextColor:[UIColor whiteColor]];
    [timerView setTextAlignment:UITextAlignmentCenter];
    [timerView setText:@"Connecting to server..."];
    
    [dialog addSubview:timerView];
    
    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
    [dialog setTransform: moveUp];
    [dialog show];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    
    [self createTimer];
}


- (void)createTimer 
{       
    // start timer
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.00 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.countdownTimer = timer;
    timeCount = 60; // instance variable
}

- (void)timerFired:(NSTimer *)timer {
    // update label
    if(timeCount == 0){
        [self timerExpired];
    } else {
        timeCount--;
        if(timeCount == 0) {
            // display correct dialog with button
            [timer invalidate];
            sleep(1);
            [self timerExpired];
        }
    }
    timerView.text = [NSString stringWithFormat:@"%d:%02d",timeCount/60, timeCount % 60];
    NSLog(@"%@",[NSString stringWithFormat:@"%d:%02d",timeCount/60, timeCount % 60]);
}

- (void) timerExpired
{
    [dialog dismissWithClickedButtonIndex:0 animated:NO];
    
    [countdownTimer invalidate];
    self.countdownTimer = nil;
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
}



@end
