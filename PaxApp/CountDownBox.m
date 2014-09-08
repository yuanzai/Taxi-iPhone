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
#import "HTTPQueryModel.h"

@implementation CountDownBox
@synthesize countdownTimer, timerView;

-(id) init
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    self = [super init];
    if (self) {
    [self setTitle:NSLocalizedString(@"Waiting for driver reply", @"")];
    [self setMessage:@" "];
    [self addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
    
    timerView = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [timerView setBackgroundColor:[UIColor clearColor]];  
    [timerView setAlpha:1];
    [timerView setTextColor:[UIColor whiteColor]];
    [timerView setTextAlignment:UITextAlignmentCenter];
    [timerView setText:NSLocalizedString(@"Connecting...", @"")];
    
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
    [self setTitle:NSLocalizedString(@"Waiting for driver reply", @"")];
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
    [self dismissWithClickedButtonIndex:0 animated:NO];
    UIAlertView* cancelAlert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"\n\nConnecting to server...", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [cancelAlert show];
    [countdownTimer invalidate];
    self.countdownTimer = nil;
    
    HTTPQueryModel* myQuery;
    NSMutableDictionary* formData = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"id"], @"job_id",nil];
    
    myQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"postCancelJob" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [cancelAlert dismissWithClickedButtonIndex:0 animated:YES];
    } failHandler:^{

    }];


    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
}

-(void) stopTimer
{    
    
    UIAlertView* cancelAlert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"\n\nCancelling...", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [cancelAlert show];
    
    [countdownTimer invalidate];
    self.countdownTimer = nil;
    HTTPQueryModel* myQuery;
    NSMutableDictionary* formData = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"id"], @"job_id",nil];
    
    myQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"postCancelJob" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [cancelAlert dismissWithClickedButtonIndex:0 animated:YES];
    } failHandler:^{
        
    }];
    
}

- (void) hideBox
{
    [countdownTimer invalidate];
    self.countdownTimer = nil;
    //[self dismissWithClickedButtonIndex:-1 animated:YES];
}
@end
