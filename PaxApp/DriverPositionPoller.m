//
//  DownloadData.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DriverPositionPoller.h"
#import "GlobalVariables.h"
#import "CheckConnection.h"
#import "DriverPositionModel.h"
#import "Constants.h"

@implementation DriverPositionPoller
@synthesize repeatingTimer, driver_id;

- (void)driverPositionPoll:(NSTimer*)timer
{
    
    //myCheckConnection = [[CheckConnection alloc]init];
    
    if (!newConnection)
        newConnection= [[DriverPositionModel alloc]init];    
    if ([[NSString stringWithFormat:@"%@", driver_id] isEqualToString:@"all"]) {
        [newConnection getAllDriverPositionsWithDriverID];
    } else {
        [newConnection getDriverPositionsWithDriverID:driver_id];
    }
}


-(id)initDriverPositionPollWithDriverID:(NSString*)driverID
{
    if (self = [super init])
    {
        driver_id = driverID;        
        [self driverPositionPoll:nil];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kDownloadPositionsInterval
                                                          target:self 
                                                        selector:@selector(driverPositionPoll:)
                                                        userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    //[myCheckConnection startConnectionCheck];
    } return self;
}

- (void)stopDriverPositionPoll
{    
    //[myCheckConnection stopConnectionCheck];    
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

@end
