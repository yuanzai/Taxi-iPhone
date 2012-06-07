//
//  DownloadData.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DriverPosition.h"
#import "GlobalVariables.h"
#import "CheckConnection.h"
#import "DriverPositionModel.h"

@implementation DriverPosition
@synthesize repeatingTimer, driver_id;

- (void)driverPositionPoll:(NSTimer*)timer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    //myCheckConnection = [[CheckConnection alloc]init];
    
    DriverPositionModel *newConnection= [[DriverPositionModel alloc]init];
    if ([driver_id isEqualToString:@"all"]) {
        [newConnection getAllDriverPositionsWithDriverID];
    } else {
    [newConnection getDriverPositionsWithDriverID:driver_id];
    }
}


-(id)initDriverPositionPollWithDriverID:(NSString*)driverID
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    if (self = [super init])
    {
        driver_id = driverID;
        
        [self driverPositionPoll:nil];
    
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                          target:self 
                                                        selector:@selector(driverPositionPoll:)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    //[myCheckConnection startConnectionCheck];
    } return self;
}

- (void)stopDriverPositionPoll
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    //[myCheckConnection stopConnectionCheck];
    
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

@end
