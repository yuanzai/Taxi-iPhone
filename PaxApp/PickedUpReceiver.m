//
//  PickedUpReceiver.m
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickedUpReceiver.h"
#import "Job.h"

@implementation PickedUpReceiver
@synthesize repeatingTimer, job_id;

- (void)pickupReceiver:(NSTimer*)timer
{

    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    if (!currentJob)
        currentJob = [[Job alloc]init];
    
    [currentJob getJobInfo_useJobID:job_id];
    if ([[currentJob.jobItem objectForKey:@"picked"] isEqualToString:@"1"]){
        NSLog(@"%@ - %@ - Passenger Picked",self.class,NSStringFromSelector(_cmd));
        
        [self stopPickupReceiverTimer];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Passenger Picked" object:nil];
    } else if ([[currentJob.jobItem objectForKey:@"dcancel"] isEqualToString:@"1"]){
        NSLog(@"%@ - %@ - Driver Cancel",self.class,NSStringFromSelector(_cmd));
        
        [self stopPickupReceiverTimer];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Driver Cancelled" object:nil];
    
        
    }

}


-(void)startPickupReceiverTimer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
        
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 
                                                      target:self selector:@selector(pickupReceiver:)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    //[myCheckConnection startConnectionCheck];
}

- (void)stopPickupReceiverTimer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
}


@end
