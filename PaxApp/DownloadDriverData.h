//
//  DownloadData.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CheckConnection;

@interface DownloadDriverData : NSObject
{
    CheckConnection* myCheckConnection;
    NSString* driver_id;
}

@property (nonatomic,strong) NSTimer *repeatingTimer;
@property (nonatomic,strong) NSString* driver_id;
- (void)dataDownload:(NSTimer*)timer;

- (void)startDriverDataDownloadTimer;
- (void)stopDownloadDriverDataTimer;

//-(void)startDataDownloadThread:(id)sender;
@end
