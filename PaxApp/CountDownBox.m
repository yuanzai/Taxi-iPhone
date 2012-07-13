//
//  CountDownBox.m
//  PaxApp
//
//  Created by Junyuan Lau on 29/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountDownBox.h"
#import "JobCycleQuery.h"
#import "GlobalVariables.h"

@implementation CountDownBox
@synthesize countdownTimer, timerView;

-(id) init
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    self = [super init];
    if (self) {
    [self setTitle:@"Waiting for driver reply"];
    [self setMessage:@" "];
    [self addButtonWithTitle:@"Cancel"];
    
    
    timerView = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [timerView setBackgroundColor:[UIColor clearColor]];  
    [timerView setAlpha:1];
    [timerView setTextColor:[UIColor whiteColor]];
    [timerView setTextAlignment:UITextAlignmentCenter];
    [timerView setText:@"Connecting to server..."];
    
    [self addSubview:timerView];
    
    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
    [self setTransform: moveUp];
    }
    return self;
    
}

- (void) createTimer:(int)countDownTime
{       
    // start timer
    if (!self.visible)
    [super show];

    NSTimer *timer = [NSTimer timerWithTimeInterval:1.00 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.countdownTimer = timer;
    timeCount = countDownTime; // instance variable

}

- (void) timerFired:(NSTimer *)timer {
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
    [JobCycleQuery jobExpiredWithJobID:[[GlobalVariables myGlobalVariables] gJob_id] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [self dismissWithClickedButtonIndex:0 animated:YES];
    }];
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
}

-(void) stopTimer
{    
    [countdownTimer invalidate];
    self.countdownTimer = nil;
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [JobCycleQuery cancelJobCalledByPassenger_jobID:[[GlobalVariables myGlobalVariables] gJob_id] feedback:@"" completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [self dismissWithClickedButtonIndex:0 animated:YES];
    }];
    
}

- (void) hideBox
{
    [countdownTimer invalidate];
    self.countdownTimer = nil;
    [self dismissWithClickedButtonIndex:-1 animated:YES];
}
@end
