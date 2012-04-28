//
//  SubmitClass.m
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubmitClass.h"
#import "PostNewJob.h"
#import "AlertBox.h"
#import "Job.h"
#import "JobQuery.h"
#import "GlobalVariables.h"


@implementation SubmitClass

@synthesize checkTimer, myBox;

-(void) startSubmitProcesswithdriverID:(NSString*)driver_id pickupAddress:(NSString*)pickup destinationAddress:(NSString *)destination
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    AlertBox *newBox = [[AlertBox alloc]init];
    [newBox launchAlertBox:self];
    
    self.myBox = newBox;
    
    PostNewJob *newPostJob = [[PostNewJob alloc]init];
    job_id = [newPostJob postNewJobwithdriverID:@"0" 
                     pickupAddress:pickup 
                destinationAddress:destination];
    [[GlobalVariables myGlobalVariables] setGJob_id:job_id];
    [self createCheckTimer];
     
}

- (void)createCheckTimer 
{   
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    // start timer
    NSTimer *timer = [NSTimer timerWithTimeInterval:10
                                                  target:self
                                                selector:@selector(timerFiredCheck:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.checkTimer = timer;
}

- (void)stopCheckTimer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [checkTimer invalidate];
    self.checkTimer = nil;  
}


- (void)timerFiredCheck:(NSTimer *)timer {
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    if (self.myBox.countdownTimer == nil){
        [self stopCheckTimer];
    } else{
    if (!newJob)
        newJob = [[Job alloc] init];
    
    [newJob getJobInfo_useJobID:job_id];
    
    if ([[newJob.jobItem objectForKey:@"accepted"] isEqualToString:@"1"]) {
        [[GlobalVariables myGlobalVariables] setGDriver_id:[newJob.jobItem objectForKey:@"driver_id"]];
        [self stopCheckTimer];
        [self.myBox stopTimer];
        self.myBox = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoOnroute" object:nil];
        NSLog(@"%@ - %@ - Accepted",self.class,NSStringFromSelector(_cmd));    

        
    } else if ([newJob.jobItem objectForKey:@"dcancel"]== @"1") {
        [self stopCheckTimer];
        [self.myBox stopTimer];
        self.myBox = nil;
    } else {
    NSLog(@"%@ - %@ - No Response",self.class,NSStringFromSelector(_cmd));    }
    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 0) {
        NSLog(@"%@ - %@ - AlertBox Delegate/Alert Cancelled",self.class,NSStringFromSelector(_cmd));
        
        [self.myBox stopTimer];
        self.myBox = nil;
        [self stopCheckTimer];

        JobQuery* cancelJobQuery = [[JobQuery alloc]init];
        
        [cancelJobQuery submitJobQuerywithMsgType:@"clientcancel"
                                           job_id:job_id 
                                           rating:@"" 
                                        driver_id:@""];
        
    
    }     
}

@end
