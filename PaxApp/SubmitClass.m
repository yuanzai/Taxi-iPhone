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
#import "JobInfo.h"
#import "JobQuery.h"


@implementation SubmitClass
@synthesize checkTimer;

-(void) startSubmitProcesswithdriverID:(NSString*)driver_id pickupAddress:(NSString*)pickup destinationAddress:(NSString *)destination
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(cancelJob:)
     name:@"cancelPostJob"
     object:nil ];
    
    [self launchAlertBox];
    
    PostNewJob *newJob = [[PostNewJob alloc]init];
    job_id = [newJob postNewJobwithdriverID:@"0" 
                     pickupAddress:pickup 
                destinationAddress:destination];
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
    if (!checkJobStatus)
        checkJobStatus = [[JobInfo alloc] init];

    NSString* jobStatus =[checkJobStatus getJobInfo_useJobID:job_id];
    if (jobStatus == @"accepted") {
        [self stopTimer];
    } else if (jobStatus == @"dcancel") {
        [self stopTimer];
    } else {
        NSLog(@"%@ - No Response", self.class);
    }
    

}

-(void)cancelJob: (NSNotification *) notification
{
    
    JobQuery* cancelJobQuery = [[JobQuery alloc]init];
    
    [cancelJobQuery submitJobQuerywithMsgType:@"clientcancel"
                                       job_id:job_id 
                                       rating:@"" 
                                    driver_id:@""];
    
     NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [self stopCheckTimer];
    [self stopTimer];


}

@end
