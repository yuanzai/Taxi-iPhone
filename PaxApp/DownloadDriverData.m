//
//  DownloadData.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadDriverData.h"
#import "DriverPositions.h"
#import "GlobalVariables.h"
#import "CheckConnection.h"
#import "DriverAsync.h"

@implementation DownloadDriverData
@synthesize repeatingTimer, driver_id;

- (void)dataDownload:(NSTimer*)timer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    //myCheckConnection = [[CheckConnection alloc]init];
    
    DriverAsync *newConnection= [[DriverAsync alloc]init];
    [newConnection getDriverInfo_useDriverID:driver_id];

}


-(void)startDriverDataDownloadTimer{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    [self dataDownload:nil];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 
                                                      target:self selector:@selector(dataDownload:)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    //[myCheckConnection startConnectionCheck];
}

- (void)stopDownloadDriverDataTimer{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    //[myCheckConnection stopConnectionCheck];
    
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
}



-(void)dataDownloadAsync:(NSTimer *)timer
{
    
}






@end
