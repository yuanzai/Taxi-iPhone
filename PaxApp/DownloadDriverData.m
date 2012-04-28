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

@implementation DownloadDriverData
@synthesize repeatingTimer, driver_id;

- (void)dataDownload:(NSTimer*)timer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    if (!myCheckConnection) {
        myCheckConnection = [[CheckConnection alloc]init];
    }

    NSMutableArray *latestDriverList = [[NSMutableArray alloc]init];
    DriverPositions *driverListGetter =[[DriverPositions alloc]init];
    latestDriverList = [driverListGetter getDriverListFromServer:driver_id];
    
    //setting driverList gv
    [[GlobalVariables myGlobalVariables] setGDriverList:latestDriverList];
    
    //Notifying View Controller to update map markers
    [[NSNotificationCenter defaultCenter] postNotificationName:@"driverListUpdated" object: nil ];

}

/*                        
-(void)startDataDownloadThread{
    [NSThread detachNewThreadSelector:@selector(startNSTimerThread)toTarget:self withObject:nil]; 
   
}

-(void)stopDataDownloadThread{
    
}
 
 */

-(void)startDriverDataDownloadTimer{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    [self dataDownload:nil];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 
                                                      target:self selector:@selector(dataDownload:)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
    [myCheckConnection startConnectionCheck];
}

- (void)stopDownloadDriverDataTimer{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
}
@end
