//
//  SubmitClass.m
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubmitClass.h"
#import "AlertBox.h"
#import "Job.h"
#import "JobQuery.h"
#import "GlobalVariables.h"
#import "JobDispatchQuery.h"
#import "JobCycleQuery.h"

@implementation SubmitClass

@synthesize checkTimer, myBox;

-(void) startSubmitProcesswithdriverID:(NSString*)driver_id pickupAddress:(NSString*)pickup destinationAddress:(NSString *)destination
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    AlertBox *newBox = [[AlertBox alloc]init];
    [newBox launchAlertBox:self];
    
    self.myBox = newBox;
    
    [JobDispatchQuery submitJobWithPickupLocation:pickup Destination:destination TaxiType:0 completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        job_id = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
        [[GlobalVariables myGlobalVariables] setGJob_id:job_id];
        NSLog(@"%@ - %@ - JobID - %@",self.class,NSStringFromSelector(_cmd), job_id);

        [self createCheckTimer];
     }];
     
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
        
    //if (!newJob)
      //  newJob = [[Job alloc] init];
    
    //[newJob getJobInfo_useJobID:job_id];
    
    [Job getJobInfoAsync_withJobID:job_id completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];    
        
        NSMutableDictionary *jobInfo = [array objectAtIndex:0];
        NSLog(@"%@ - %@ - Current Status - %@",self.class,NSStringFromSelector(_cmd), [jobInfo objectForKey:@"jobstatus"]);
        
        NSString* jobstatus = [[NSString alloc]initWithFormat:[jobInfo objectForKey:@"jobstatus"]];    

        if ([jobstatus isEqualToString:@"accepted"]){
            [[GlobalVariables myGlobalVariables] setGDriver_id:[jobInfo objectForKey:@"driver_id"]];
            [self performSelectorOnMainThread:@selector(jobAccepted) withObject:nil waitUntilDone:YES];
        } else {
    NSLog(@"%@ - %@ - No Response",self.class,NSStringFromSelector(_cmd));
        }
        
    }];
        
     }   


}

- (void) jobAccepted
{
    [self stopCheckTimer];
    [self.myBox stopTimer];
    self.myBox = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoOnroute" object:nil];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"%@ - %@ - AlertBox Delegate/Alert Cancelled",self.class,NSStringFromSelector(_cmd));
        
        [self.myBox stopTimer];
        self.myBox = nil;
        [self stopCheckTimer];
        
        [JobCycleQuery jobExpired_jobID :job_id completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        }];
    }     
}

@end
