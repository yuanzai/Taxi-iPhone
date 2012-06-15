//
//  PickedUpReceiver.m
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobStatusReceiver.h"
#import "JobCycleQuery.h"

@implementation JobStatusReceiver
@synthesize repeatingTimer, job_id, targettedStatus;

- (void)statusReceiver:(NSTimer*)timer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    if (!jobInfo)
        jobInfo = [[NSMutableDictionary alloc]init];
        
    [JobCycleQuery checkJobWithJobID:job_id completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (data){
        jobInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];    
        
               NSLog(@"%@ - %@ - Current Status - %@",self.class,NSStringFromSelector(_cmd), [jobInfo objectForKey:@"job_status"]);
        
        NSString* jobstatus = [[NSString alloc]initWithFormat:[jobInfo objectForKey:@"job_status"]];    
        
        if ([jobstatus isEqualToString:targettedStatus]){
            NSLog(@"%@ - %@ - Status changed to %@",self.class,NSStringFromSelector(_cmd), jobstatus);
            
            [self stopStatusReceiverTimer];        
            [self performSelectorOnMainThread:@selector(sendNotification) withObject:nil waitUntilDone:YES];
        } else {
            
            //cancelcodes
        }
        }
    }];
}

-(void) sendNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:targettedStatus object:nil];

}


-(id)initStatusReceiverTimerWithJobID:(NSString*)jobID TargettedStatus:(NSString*) status 
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    if (self = [super init])
    {        
        job_id = jobID;
        targettedStatus = status;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 
                                                      target:self selector:@selector(statusReceiver:)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    }
    
    return self;
}

-(void)startStatusReceiverTimerWithJobID:(NSString*)jobID TargettedStatus:(NSString*) status 
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));       
        job_id = jobID;
        targettedStatus = status;
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 
                                                          target:self selector:@selector(statusReceiver:)
                                                        userInfo:nil repeats:YES];
        self.repeatingTimer = timer;
}



- (void)stopStatusReceiverTimer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));    
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
}
@end
