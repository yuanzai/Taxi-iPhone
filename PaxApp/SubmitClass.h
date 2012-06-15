//
//  SubmitClass.h
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Job;
@class AlertBox;
@class JobStatusReceiver;
@interface SubmitClass : NSObject
{
    NSTimer *checkTimer;
    NSString* job_id;

    Job* newJob;
    AlertBox* myBox;
    JobStatusReceiver *myStatusReceiver;

    
}
@property (nonatomic,strong) NSTimer *checkTimer;
@property (nonatomic,strong) AlertBox* myBox;


-(void) startSubmitProcesswithdriverID:(NSString*)driver_id pickupAddress:(NSString*)pickup destinationAddress:(NSString *)destination taxitype:(NSString*) taxitype fare:(NSString*) fare mobile:(NSString*) mobile;
- (void)createCheckTimer;

- (void)stopCheckTimer;
- (void) jobAccepted;
- (void)startCountdown;
- (void) statusCheck:(NSMutableDictionary *) dict;



@end 
