//
//  PickedUpReceiver.m
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobStatusReceiver.h"
#import "Job.h"

@implementation JobStatusReceiver
@synthesize repeatingTimer, job_id;

- (void)statusReceiver:(NSTimer*)timer
{

    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    if (!currentJob)
        currentJob = [[Job alloc]init];
    
    [currentJob getJobInfo_useJobID:job_id];
    NSString* jobstatus = [[NSString alloc]initWithFormat:[currentJob.jobItem objectForKey:@"jobstatus"]];
    

    if ([jobstatus isEqualToString:@"picked"]){
        NSLog(@"%@ - %@ - Passenger Picked",self.class,NSStringFromSelector(_cmd));
        
        [self stopStatusReceiverTimer];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyPickedStatus" object:nil];
        
    } else if ([jobstatus isEqualToString:@"drivercancel"]){
        NSLog(@"%@ - %@ - Driver Cancel",self.class,NSStringFromSelector(_cmd));
        
        [self stopStatusReceiverTimer];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyDrivercancelStatus" object:nil];
    } else if ([jobstatus isEqualToString:@"driverreached"]){
        NSLog(@"%@ - %@ - Driver Cancel",self.class,NSStringFromSelector(_cmd));
        
        [self stopStatusReceiverTimer];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyDriverreachedStatus" object:nil];
    }

}


-(void)startStatusReceiverTimer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
        
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 
                                                      target:self selector:@selector(statusReceiver:)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    //[myCheckConnection startConnectionCheck];
}

- (void)stopStatusReceiverTimer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
}


@end
