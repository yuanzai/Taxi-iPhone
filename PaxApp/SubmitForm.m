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
@interface submitForm
- (void) applicationDidEnterBackground:(NSNotification*) notification;
- (void) appWillEnterForegroundNotification: (NSNotification*) notification;


@end

@implementation SubmitForm
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
    NSLog(@"Booking Form - %@", [[GlobalVariables myGlobalVariables]gCurrentForm]);
    [myBox show];

    
    [JobDispatchQuery submitJobWithDictionary:[[GlobalVariables myGlobalVariables]gCurrentForm] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
            
            if ([httpResponse statusCode] == 201) {
                
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSDictionary* dataDict = [dict objectForKey:@"data"];
                
                NSString* job_id = [dataDict objectForKey:@"id"];
                

                
                [bookingForm setObject:[[NSDate alloc]init] forKey:@"starttime"];
                NSLog(@"%@",[bookingForm objectForKey:@"starttime"]);
                
                
                [[GlobalVariables myGlobalVariables] setGCurrentForm:bookingForm];
                
                [[GlobalVariables myGlobalVariables] setGJob_id:job_id];
                [[GlobalVariables myGlobalVariables] setGIsOnJob:YES];
                
                NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
                [preferences setObject:job_id forKey:@"LastJob"];
            
            NSLog(@"%@ - %@ - JobID - %@",self.class,NSStringFromSelector(_cmd), job_id);
            [self performSelectorOnMainThread:@selector(startCountdownWithJobID:) withObject:job_id waitUntilDone:YES];
                
            } else if ([httpResponse statusCode] == 422) {
                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"Error - %@",dict);
                myBox.title = @"Error";
                myBox.timerView.text = @"Fields incomplete";
                
            } else {
                myBox.title = @"Error";
                myBox.timerView.text = @"Cannot connect";
            }
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
            NSLog(@"%@ - %@ - %f",self.class,NSStringFromSelector(_cmd), [now timeIntervalSinceDate:startTime]);

        }else{
            
            //start time not valid - expire old job
            [bookingForm setObject:nil forKey:@"starttime"];
            [JobCycleQuery jobExpiredWithJobID:job_id completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            }];
            
            NSLog(@"%@ - %@ - %f",self.class,NSStringFromSelector(_cmd), [now timeIntervalSinceDate:startTime]);
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
        NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
   
    [myBox createTimer:countDownTime];
    myStatusReceiver = [[JobStatusPoller alloc]initStatusReceiverTimerWithJobID:job_id TargettedStatus:@"accepted"];
    
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
    [self startCountdownWithJobID:[[GlobalVariables myGlobalVariables]gJob_id]];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@ - %@ - %@ - %i",self.class,NSStringFromSelector(_cmd), alertView.class,buttonIndex);
    if(buttonIndex == 0) {
        
        NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
        [myStatusReceiver stopStatusReceiverTimer];
        myStatusReceiver = nil;
        
        [preferences setObject:nil forKey:@"JobStartTime"];
        [[GlobalVariables myGlobalVariables]setGIsOnJob:NO];
        myBox.timerView.text = @"Connecting to server...";
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@ - %@ - %i",self.class,NSStringFromSelector(_cmd), buttonIndex);
    [myBox stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)jobAccepted 
{
    [[GlobalVariables myGlobalVariables] setGIsOnJob:NO];
    [myBox.countdownTimer invalidate];
    myBox.countdownTimer = nil;
    
    [myBox dismissWithClickedButtonIndex:0 animated:YES];
    
}

@end
