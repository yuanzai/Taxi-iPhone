//
//  PickedUpReceiver.m
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobStatusPoller.h"
#import "JobCycleQuery.h"
#import "Constants.h"

@implementation JobStatusPoller
@synthesize repeatingTimer, job_id, targettedStatus;

- (void)statusReceiver:(NSTimer*)timer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    if (!jobInfo)
        jobInfo = [[NSMutableDictionary alloc]init];
    
    [JobCycleQuery checkJobWithJobID:job_id completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (response && data){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
            if ([httpResponse statusCode]== 200) {
                jobInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@ - %@ - %@",self.class,NSStringFromSelector(_cmd),jobInfo);         
                NSString* jobstatus = [jobInfo objectForKey:@"job_status"];
                
                NSLog(@"%@ - %@ - Current Status - %@",self.class,NSStringFromSelector(_cmd), jobstatus);
                
                if ([jobstatus isEqualToString:targettedStatus]){
                    
                    NSLog(@"%@ - %@ - Status changed to %@",self.class,NSStringFromSelector(_cmd), jobstatus);
                    [self stopStatusReceiverTimer];        
                    [self performSelectorOnMainThread:@selector(sendNotificationWithDict:) withObject:jobInfo waitUntilDone:YES];
                    
                } else {
                    
                    //cancelcodes
                }
            } else {
            NSLog(@"%@ - %@ - No response from server",self.class,NSStringFromSelector(_cmd));
            }
        }
    }];
}

-(void) sendNotificationWithDict:(NSDictionary*) dict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:targettedStatus object:self userInfo:dict];

}


-(id)initStatusReceiverTimerWithJobID:(NSString*)jobID TargettedStatus:(NSString*) status 
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    if (self = [super init])
    {        
        job_id = jobID;
        targettedStatus = status;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kStatusReceiverInterval 
                                                      target:self selector:@selector(statusReceiver:)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusReceiver:) name:@"CheckJobNotification" object:nil];
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end
