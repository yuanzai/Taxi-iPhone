//
//  AppDelegate.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalVariables.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    UILocalNotification *localNotif = [launchOptions
                                       objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]; 
    
    if (localNotif) {
        // has notifications
    }
    else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    [_window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif {
    NSLog(@"application: didReceiveLocalNotification:");
    
}

// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSMutableString *deviceID = [NSMutableString string];
    
    // iterate through the bytes and convert to hex
    unsigned char *ptr = (unsigned char *)[devToken bytes];
    
    for (NSInteger i=0; i < 32; ++i) {
        [deviceID appendString:[NSString stringWithFormat:@"%02x", ptr[i]]];
    }
    
    
    NSLog(@"%@", deviceID);
    [[GlobalVariables myGlobalVariables]setGDeviceToken:deviceID];
    
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Push Notification Received");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckJobNotification" object:nil];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    if ([[GlobalVariables myGlobalVariables] gIsOnJob]){
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = [NSDate date]; // show now, but you can set other date to schedule
    
    localNotif.alertBody = @"You have an open taxi booking!";
    localNotif.alertAction = @"Go back"; // action button title
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    // keep some info for later use
  	NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"item-one",@"item", nil];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
     
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    //submitjobview specific
    NSLog(@"OPEN APP AGAIN");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReturnToForeground" object:nil];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
