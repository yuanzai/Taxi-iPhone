//
//  PickedUpReceiver.h
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Job.h"

@class Job;
@interface JobStatusReceiver : NSObject
{
    Job* currentJob;
    NSTimer* repeatingTimer;
    NSString* job_id;
    
}
@property (nonatomic, strong) NSTimer* repeatingTimer;
@property (nonatomic,strong) NSString* job_id;

- (void)statusReceiver:(NSTimer*)timer;

- (void)startStatusReceiverTimer;
- (void)stopStatusReceiverTimer;

@end
