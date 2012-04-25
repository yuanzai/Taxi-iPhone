//
//  DownloadData.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CheckConnection;

@interface DownloadData : NSObject
{
    CheckConnection* myCheckConnection;
}

@property (nonatomic,strong) NSTimer *repeatingTimer;

-(void)startDataDownloadThread;
-(void)startNSTimerThread;
- (void)stopNSTimerThread;

//-(void)startDataDownloadThread:(id)sender;
@end
