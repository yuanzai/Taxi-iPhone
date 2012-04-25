//
//  CheckConnViewController.h
//  CheckForConnection
//
//  Created by Junyuan Lau on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;
@interface CheckConnection : NSObject
{
    Reachability* internetReachable;
    Reachability* hostReachable;
    BOOL internetActive;
    BOOL hostActive;
}
@property BOOL internetActive;
@property BOOL hostActive;

-(void) checkNetworkStatus:(NSNotification *)notice;
- (void)startConnectionCheck;


@end
