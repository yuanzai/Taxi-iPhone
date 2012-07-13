//
//  AlertBox.m
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertBox.h"
#import "JobCycleQuery.h"
#import "GlobalVariables.h"

@implementation AlertBox
@synthesize countdownTimer, isOpen;

-(void) launchAlertBox: (id)setDelegate
{
    //self.isOpen = YES;
    dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
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
    
}


- (void)createTimer:(int)countDownTime
{       
    // start timer
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.00 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.countdownTimer = timer;
    timeCount = countDownTime; // instance variable
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
    
    [countdownTimer invalidate];
    self.countdownTimer = nil;
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [JobCycleQuery jobExpiredWithJobID:[[GlobalVariables myGlobalVariables] gJob_id] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"stopStatusReceiver" object:nil];
        [dialog dismissWithClickedButtonIndex:0 animated:YES];
    }];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"%@ - %@ - AlertBox Delegate/Alert Cancelled",self.class,NSStringFromSelector(_cmd));
        
        [self stopTimer];        
        
    }     
}

-(void) stopTimer
{    
    [countdownTimer invalidate];
    self.countdownTimer = nil;
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [JobCycleQuery cancelJobCalledByPassenger_jobID:[[GlobalVariables myGlobalVariables] gJob_id] feedback:@"" completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"stopStatusReceiver" object:nil];
                [dialog dismissWithClickedButtonIndex:0 animated:YES];
    }];
    
}

- (void) hideAlertBox
{
    [dialog dismissWithClickedButtonIndex:0 animated:YES];
}
@end
