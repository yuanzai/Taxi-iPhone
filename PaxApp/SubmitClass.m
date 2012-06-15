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

#import "JobStatusReceiver.h"

@implementation SubmitClass

@synthesize checkTimer, myBox;

-(void) startSubmitProcesswithdriverID:(NSString*)driver_id pickupAddress:(NSString*)pickup destinationAddress:(NSString *)destination taxitype:(NSString*) taxitype fare:(NSString*) fare mobile:(NSString*) mobile
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
            myBox = [[AlertBox alloc]init];
    [myBox launchAlertBox:self];

    
    
    [JobDispatchQuery submitJobWithPickupLocation:pickup Destination:destination TaxiType:taxitype fare:fare mobile:mobile completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
        job_id = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
        [[GlobalVariables myGlobalVariables] setGJob_id:job_id];
        NSLog(@"%@ - %@ - JobID - %@",self.class,NSStringFromSelector(_cmd), job_id);
        [self performSelectorOnMainThread:@selector(startCountdown) withObject:nil waitUntilDone:YES];

        }
     }];
     

    
}

- (void)startCountdown
{
    [myBox createTimer];
    //myStatusReceiver = [[JobStatusReceiver alloc]initStatusReceiverTimerWithJobID:job_id TargettedStatus:@"accepted"];

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

    [JobCycleQuery checkJobWithJobID:job_id completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data){
        NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        [self performSelectorOnMainThread:@selector(statusCheck:) withObject:dict waitUntilDone:YES];

        }
    }];
     }   
}
     
- (void) statusCheck:(NSMutableDictionary *) dict
{
    NSString* jobstatus = [[NSString alloc]initWithFormat:[dict objectForKey:@"job_status"]];    
    
    if ([jobstatus isEqualToString:@"accepted"]){
        
        NSLog(@"%@ - %@ - Accepted",self.class,NSStringFromSelector(_cmd));

        [[GlobalVariables myGlobalVariables] setGDriver_id:[dict objectForKey:@"driver_id"]];
        [self stopCheckTimer];
        [self.myBox stopTimer];
        self.myBox = nil;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoOnroute" object:nil];
        
    } else if ([jobstatus isEqualToString:@"open"]){
        
        NSLog(@"%@ - %@ - No Response",self.class,NSStringFromSelector(_cmd));
    }   
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"%@ - %@ - AlertBox Delegate/Alert Cancelled",self.class,NSStringFromSelector(_cmd));
        
        [self.myBox stopTimer];
        self.myBox = nil;
        [self stopCheckTimer];
        
        [JobCycleQuery jobExpiredWithJobID :job_id completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        }];
    }     
}

@end
