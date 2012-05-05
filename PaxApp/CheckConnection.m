//
//  CheckConnViewController.m
//  CheckForConnection
//
//  Created by Junyuan Lau on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckConnection.h"
#import "Reachability.h"

@implementation CheckConnection
@synthesize internetActive, hostActive;


-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
        }
            
        default: 
        {
            NSLog(@"The internet is working.");
            self.internetActive = YES;
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            break;
        }
        default:         
        {
            NSLog(@"A gateway to the host server is working.");
            self.hostActive = YES;
            break;
        }
    }
}

- (void)startConnectionCheck
{
    NSLog(@"Start Connection Check");
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName: @"www.apple.com"];
    [hostReachable startNotifier];
    
}

-(void)stopConnectionCheck
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    internetReachable = nil;
    hostReachable =nil;
    
}



@end
