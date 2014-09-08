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
#import "HTTPQueryModel.h"

@implementation JobStatusPoller
@synthesize repeatingTimer, job_id, targettedStatus, delegate;
/*
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
                [self callProtocolWithStatus:jobstatus];
                
                NSLog(@"%@ - %@ - Current Status - %@",self.class,NSStringFromSelector(_cmd), jobstatus);
                
                if ([jobstatus isEqualToString:targettedStatus]){
                    
                    NSLog(@"%@ - %@ - Status changed to %@",self.class,NSStringFromSelector(_cmd), jobstatus);
                    [self stopStatusReceiverTimer];        
                    [self performSelectorOnMainThread:@selector(sendNotificationWithDict:) withObject:jobInfo waitUntilDone:YES];
                    [self performSelectorOnMainThread:@selector(processComplete) withObject:nil waitUntilDone:YES];
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
    NSLog(@"%@ - %@ - Send notification",self.class,NSStringFromSelector(_cmd));
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

*/

- (void)stopStatusReceiverTimer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));    
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(id)initStatusReceiverTimerWithJobID:(NSString*)jobID 
{
    NSLog(@"%@ - %@ %@",self.class,NSStringFromSelector(_cmd), jobID);
    if (self = [super init])
    {
        job_id = jobID;
        [self statusReceiverProtocolOnly:nil];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kStatusReceiverInterval
                                                          target:self selector:@selector(statusReceiverProtocolOnly:)
                                                        userInfo:nil repeats:YES];
        self.repeatingTimer = timer;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusReceiverProtocolOnly:) name:@"CheckJobNotification" object:nil]; //init observer for pushnotification of checkjob
        
    }
    
    return self;
}

- (void)statusReceiverProtocolOnly:(NSTimer*)timer
{
    NSMutableDictionary* dataForm = [[NSMutableDictionary alloc]initWithObjectsAndKeys:job_id,@"job_id", nil];
    
    HTTPQueryModel* myQuery;
    myQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"getCheckJob" Data:dataForm completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (response && data){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ([httpResponse statusCode]== 200) {
                jobInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSString* jobstatus = [jobInfo objectForKey:@"job_status"];
                [self performSelectorOnMainThread:@selector(callProtocolWithStatus:) withObject:jobstatus waitUntilDone:YES];
                
                NSLog(@"%@ - %@ - Current Status - %@",self.class,NSStringFromSelector(_cmd), jobstatus);
            } else {
                NSLog(@"%@ - %@ - No response from server",self.class,NSStringFromSelector(_cmd));
            }
        }
    } failHandler:^{
            NSLog(@"%@ - %@ - No response from server",self.class,NSStringFromSelector(_cmd));
    }];

}

- (void)callProtocolWithStatus:(NSString*) status
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));    
    [[self delegate] jobStatusChangedTo:status info:jobInfo];
}

@end
