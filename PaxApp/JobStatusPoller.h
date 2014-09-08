//
//  PickedUpReceiver.h
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol JobStatusDelegate <NSObject>
@optional
- (void) jobStatusChangedTo: (NSString*)status info:(NSDictionary*)jobInfo;
@end

@interface JobStatusPoller : NSObject
{
    NSTimer* repeatingTimer;
    NSString* job_id;
    id <JobStatusDelegate> delegate;
    NSMutableDictionary* jobInfo;
}
@property (nonatomic, strong) NSTimer* repeatingTimer;
@property (nonatomic, strong) NSString* job_id;
@property (nonatomic, strong) NSString* targettedStatus;
@property (retain) id<JobStatusDelegate> delegate;

- (void)statusReceiver:(NSTimer*)timer;

- (id)initStatusReceiverTimerWithJobID:(NSString*)jobID TargettedStatus:(NSString*) status;
- (void)stopStatusReceiverTimer;

-(void) sendNotificationWithDict:(NSDictionary*) dict;
- (void)callProtocolWithStatus:(NSString*) status;

- (void)statusReceiverProtocolOnly:(NSTimer*)timer;
-(id)initStatusReceiverTimerWithJobID:(NSString*)jobID; 

@end
