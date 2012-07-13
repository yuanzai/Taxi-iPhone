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

#import "JobStatusPoller.h"
@interface SubmitClass()
-(void) stopStatusReceiver;
@end


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
    //[myBox createTimer];
    myStatusReceiver = [[JobStatusPoller alloc]initStatusReceiverTimerWithJobID:job_id TargettedStatus:@"accepted"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopStatusReceiver) name:@"stopStatusReceiver" object:nil];
}

- (void)stopStatusReceiver
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [myStatusReceiver stopStatusReceiverTimer];

}

@end
