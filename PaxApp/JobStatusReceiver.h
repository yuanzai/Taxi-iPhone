//
//  PickedUpReceiver.h
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Job.h"

@interface JobStatusReceiver : NSObject
{
    NSMutableDictionary* jobInfo;
    NSTimer* repeatingTimer;
    NSString* job_id;    
}
@property (nonatomic, strong) NSTimer* repeatingTimer;
@property (nonatomic, strong) NSString* job_id;
@property (nonatomic, strong) NSString* targettedStatus;


- (void)statusReceiver:(NSTimer*)timer;
- (id)initStatusReceiverTimerWithJobID:(NSString*)jobID TargettedStatus:(NSString*) status;
- (void)stopStatusReceiverTimer;
- (void)startStatusReceiverTimerWithJobID:(NSString*)jobID TargettedStatus:(NSString*) status;
- (void)sendNotification;

@end
