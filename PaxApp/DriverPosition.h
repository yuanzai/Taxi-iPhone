//
//  DownloadData.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CheckConnection;

@interface DriverPosition : NSObject
{
    CheckConnection* myCheckConnection;
    NSString* driver_id;
}

@property (nonatomic,strong) NSTimer *repeatingTimer;
@property (nonatomic,strong) NSString* driver_id;

- (void)driverPositionPoll:(NSTimer*)timer;

-(id)initDriverPositionPollWithDriverID:(NSString*)driverID;
- (void)stopDriverPositionPoll;



@end
