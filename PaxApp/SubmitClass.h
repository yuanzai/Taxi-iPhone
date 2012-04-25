//
//  SubmitClass.h
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertBox.h"

@class JobInfo;
@interface SubmitClass : AlertBox
{
    NSTimer *checkTimer;
    NSString* job_id;

    JobInfo* checkJobStatus;
}
@property (nonatomic,strong) NSTimer *checkTimer;


- (void)startSubmitProcesswithdriverID:(NSString*)driver_id pickupAddress:(NSString*)pickup destinationAddress:(NSString *)destination;
- (void)createCheckTimer;

- (void)stopCheckTimer;
- (void)cancelJob: (NSNotification *) notification;



@end 
