//
//  AppDelegate.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalVariables.h"
#import "OtherQuery.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    UILocalNotification *localNotif = [launchOptions
                                       objectForKey:UIApplicationLaunchOptionsLocalNotificationKey]; 
    
    if (localNotif) {
        // has notifications
    }
    else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    [_window makeKeyAndVisible];

    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
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
    NSLog(@"Open App");
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSDate* now = [[NSDate alloc]init];
    float version =[[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]floatValue];
    if(![preferences objectForKey:@"LastLogin"]){
        [preferences setObject:now forKey:@"LastLogin"];
    } else if ([now timeIntervalSinceDate:[preferences objectForKey:@"LastLogin"]] > 172800) {
        [OtherQuery getVersioncompletionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (data) {
                
            NSDictionary* maindict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSDictionary* versionDict =[[maindict objectForKey:@"version"] objectForKey:@"ios"];
                NSLog(@"READ THIS %@",maindict);
                
                
                appURL = [versionDict objectForKey:@"link"];
                if ([[versionDict objectForKey:@"min"]floatValue] <= version && [[versionDict objectForKey:@"latest"]floatValue] > version) {
                    [self performSelectorOnMainThread:@selector(openAlertBoxAboveMinVersion:) withObject:@"option" waitUntilDone:YES];
                } else if ([[versionDict objectForKey:@"min"]floatValue] > version) {
                    [self performSelectorOnMainThread:@selector(openAlertBoxAboveMinVersion:) withObject:@"forced"  waitUntilDone:YES];
                    return;
                }
                
                
            }
        }];
    } else {
        [preferences setObject:[[NSDate alloc]init] forKey:@"LastLogin"];
    }
                
    /*
    if ([minimum isEqualToString:@"option"]){
        UIAlertView* versionAlert = [[UIAlertView alloc]initWithTitle:@"New Version Available" message:@"Would you like to update HopCab?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [versionAlert show];
    } else {
        UIAlertView* versionAlert = [[UIAlertView alloc]initWithTitle:@"HopCab outdated" message:@"Please download the latest version of HobCab!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [versionAlert show];
    }
    */
    //submitjobview specific

    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReturnToForeground" object:nil];
    
}
- (void) openAlertBoxAboveMinVersion:(NSString*) minimum
{
    if ([minimum isEqualToString:@"option"]){
        versionAlert = [[UIAlertView alloc]initWithTitle:@"New Version Available" message:@"Would you like to update HopCab?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [versionAlert show];
    } else {
        versionAlert = [[UIAlertView alloc]initWithTitle:@"HopCab outdated" message:@"Please download the latest version of HobCab!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [versionAlert show];
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"INIT %p", self);
    if (buttonIndex == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
    }
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
