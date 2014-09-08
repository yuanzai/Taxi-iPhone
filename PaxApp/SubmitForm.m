//
//  SubmitForm.m
//  PaxApp
//
//  Created by Junyuan Lau on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubmitForm.h"
#import "GlobalVariables.h"
#import "JobDispatchQuery.h"
#import "JobStatusPoller.h"
#import "CountDownBox.h"
#import "Constants.h"
#import "JobCycleQuery.h"
#import <AudioToolbox/AudioServices.h>
#import "HTTPQueryModel.h"


@interface submitForm
- (void) applicationDidEnterBackground:(NSNotification*) notification;
- (void) appWillEnterForegroundNotification: (NSNotification*) notification;

@end

@implementation SubmitForm
@synthesize delegate;
- (id) initWithData
{
    self = [super init];
    if (self) {
        dictdata = [[NSMutableDictionary alloc]init];
        myBox = [[CountDownBox alloc]init];
        [myBox setDelegate:self];
        [self fillGlobalVariablesIntoForm];
        
        if ([[GlobalVariables myGlobalVariables] gCurrentForm]) {
            bookingForm = [[GlobalVariables myGlobalVariables] gCurrentForm];
        } else {
            bookingForm = [[NSMutableDictionary alloc]init];
        }
        mySound = [self createSoundID: @"Alert.wav"];


    }
    return self;
}

-(void) fillGlobalVariablesIntoForm
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    
    
    if (![preferences objectForKey:@"ClientName"])
        [preferences setObject:@"" forKey:@"ClientName"];
    
    [[[GlobalVariables myGlobalVariables]gCurrentForm] setObject:[preferences objectForKey:@"ClientName"] forKey:@"passenger_name"];
    //[dictdata setObject:[[GlobalVariables myGlobalVariables]gDeviceToken] forKey:@"device_token"];  
    NSLog(@"%@",dictdata);
}

-(void) submitForm
{
    [self fillGlobalVariablesIntoForm];
    [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:@"" forKey:@"id"];
    NSLog(@"Booking Form - %@", [[GlobalVariables myGlobalVariables]gCurrentForm]);
    [myBox show];
    
    if([[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"starttime"]) {
        [[[GlobalVariables myGlobalVariables]gCurrentForm]setObject:@"" forKey:@"starttime"];
    }
    
    
    NSMutableDictionary* formData =[[NSMutableDictionary alloc]initWithObjectsAndKeys:[[GlobalVariables myGlobalVariables]gCurrentForm],@"job", nil];
    
    HTTPQueryModel* submitQuery;
    submitQuery = [[HTTPQueryModel alloc] initURLConnectionWithMethod:@"postJob" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
        
        if ([httpResponse statusCode] == 201) {
            
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary* dataDict = [dict objectForKey:@"data"];
            NSString* job_id = [dataDict objectForKey:@"id"];
            
            [[GlobalVariables myGlobalVariables] setGIsOnJob:YES];
            
            [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:job_id forKey:@"id"];
            [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:[NSDate date] forKey:@"starttime"];
            
            [self performSelectorOnMainThread:@selector(startCountdownWithJobID:) withObject:job_id waitUntilDone:YES];
            
        } else if ([httpResponse statusCode] == 422) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"Error - %@",dict);
            myBox.title = NSLocalizedString(@"Error", @"");
            myBox.timerView.text = NSLocalizedString(@"Fields incomplete", @"");
            
        } else {
            myBox.title = NSLocalizedString(@"Error", @"");
            myBox.timerView.text = NSLocalizedString(@"Cannot connect to server", @"");
        }

    } failHandler:^{
        myBox.title = NSLocalizedString(@"Error", @"");
        myBox.timerView.text = NSLocalizedString(@"Cannot connect to server", @"");
    }];
}

- (void)startCountdownWithJobID:(NSString*) job_id
{
    /*
    1) check if there is an active current booking - if not set now as start time
    2) check start time of booking
    3) check if booking is still valid
    */
    bookingForm = [[GlobalVariables myGlobalVariables] gCurrentForm];
        
    int countDownTime;
    
    //check if active job exists
    if ([bookingForm objectForKey:@"starttime"]) {
        // active job does exists
        
        // check start time of booking
        NSDate* startTime = [bookingForm objectForKey:@"starttime"];
        NSDate* now = [[NSDate alloc]init];
        
        //check if start time is valid
        if ([now timeIntervalSinceDate:startTime]<kCountDownTime){
            
            // start time is valid
            countDownTime = kCountDownTime - [now timeIntervalSinceDate:startTime];

        }else{
            
            //start time not valid - expire old job
            [bookingForm setObject:nil forKey:@"starttime"];
            HTTPQueryModel* myQuery;
            NSMutableDictionary* formData = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[bookingForm objectForKey:@"id"], @"job_id",nil];
            
            myQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"postCancelJob" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            } failHandler:^{
            }];
            

            if (myBox.visible)
                [myBox dismissWithClickedButtonIndex:-1 animated:NO];
            
            return;
        }
    } else {
        // active job does not exist
        NSLog(@"%@ - %@ - Current booking form has no start time.",self.class,NSStringFromSelector(_cmd));
        if (myBox.visible)    
            [myBox dismissWithClickedButtonIndex:-1 animated:NO];
        
        return;
    }
    
    if (countDownTime >0){
   
    [myBox createTimer:countDownTime];
    myStatusReceiver = [[JobStatusPoller alloc]initStatusReceiverTimerWithJobID:job_id];
        myStatusReceiver.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

- (void) applicationDidEnterBackground:(NSNotification*) notification {
    // We should not be here when entering back to foreground state
    [myBox hideBox];
    [myStatusReceiver stopStatusReceiverTimer];
    myStatusReceiver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void) appWillEnterForegroundNotification: (NSNotification*) notification
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self startCountdownWithJobID:[[[GlobalVariables myGlobalVariables]gCurrentForm] objectForKey:@"id"]];
}


//Cancelling Job
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@ - %@ - %@ - %i",self.class,NSStringFromSelector(_cmd), alertView.class,buttonIndex);
    if(buttonIndex == 0) {
        
        [myStatusReceiver stopStatusReceiverTimer];
        myStatusReceiver = nil;
        
        [[[GlobalVariables myGlobalVariables]gCurrentForm] setObject:@"" forKey:@"starttime"];
        [[GlobalVariables myGlobalVariables]setGIsOnJob:NO];
        myBox.timerView.text = NSLocalizedString(@"Connecting...", @"");
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@ - %@ - Clicked button %i",self.class,NSStringFromSelector(_cmd), buttonIndex);
    [myBox stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)jobStatusChangedTo:(NSString *)status info:(NSDictionary *)jobInfo
{
    if ([status isEqualToString:@"accepted"] || [status isEqualToString:@"arrived"] || [status isEqualToString:@"reached"])
    {
        NSLog(@"%@ - %@ - %@",self.class,NSStringFromSelector(_cmd), status);
        
        NSString* driverID = [jobInfo objectForKey:@"driver_id"];
        NSString* driver_name = [jobInfo objectForKey:@"driver_name"];
        NSString* license_plate_number = [jobInfo objectForKey:@"license_plate_number"];
        [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:driverID forKey:@"driver_id"];
        [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:driver_name forKey:@"driver_name"];
        [[[GlobalVariables myGlobalVariables] gCurrentForm]setObject:license_plate_number forKey:@"license_plate_number"];
        
        
        [[GlobalVariables myGlobalVariables] setGIsOnJob:NO];
        [myBox.countdownTimer invalidate];
        myBox.countdownTimer = nil;
        
        [myStatusReceiver stopStatusReceiverTimer];
        myStatusReceiver = nil;
        [myBox dismissWithClickedButtonIndex:0 animated:YES];
         


        [self performSelectorOnMainThread:@selector(playSound) withObject:nil waitUntilDone:YES ];
        [self performSelectorOnMainThread:@selector(sendJobAcceptedNotification) withObject:nil waitUntilDone:YES];
    }
}

-(void) sendJobAcceptedNotification
{
        NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));    
        [[self delegate] shouldGoToOnRoute:YES];
}

- (SystemSoundID) createSoundID: (NSString*)name
{
    NSURL* filePath = [[NSBundle mainBundle] URLForResource:@"alert" withExtension:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    return soundID;
}

- (void) playSound
{
    AudioServicesPlaySystemSound(mySound);

}
@end
