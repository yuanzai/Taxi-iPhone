//
//  DownloadData.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadData.h"
#import "DriverList.h"
#import "GlobalVariablePositions.h"
#import "CheckConnection.h"

@implementation DownloadData
@synthesize repeatingTimer;

- (void)dataDownload:(NSTimer*)timer{
    NSLog(@"%@ - Data download Start", self.class);
    
    if (!myCheckConnection) {
        myCheckConnection = [[CheckConnection alloc]init];
    }



    NSMutableArray *latestDriverList = [[NSMutableArray alloc]init];
    DriverList *driverListGetter =[[DriverList alloc]init];
    latestDriverList = driverListGetter.getDriverListFromServer;
    
    //setting driverList gv
    [[GlobalVariablePositions myGlobalVariablePositions] setGDriverList:latestDriverList];
    
    //Notifying View Controller to update map markers
    [[NSNotificationCenter defaultCenter] postNotificationName:@"driverListUpdated" object: nil ];

}

                        
-(void)startDataDownloadThread{
    [NSThread detachNewThreadSelector:@selector(startNSTimerThread)toTarget:self withObject:nil]; 
   
}

-(void)stopDataDownloadThread{
    
}

-(void)startNSTimerThread{
    [self dataDownload:nil];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 
                                                      target:self selector:@selector(dataDownload:)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    [myCheckConnection startConnectionCheck];
    NSLog(@"%@ - NSTimer Start", self.class);
}

- (void)stopNSTimerThread{
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
    NSLog(@"%@ - NSTimer Stop", self.class);
}
@end
