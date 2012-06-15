//
//  CancelJobAlert.m
//  PaxApp
//
//  Created by Junyuan Lau on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CancelJobAlert.h"
#import "JobQuery.h"

#import "GlobalVariables.h"
#import "JobCycleQuery.h"

@implementation CancelJobAlert
-(void) launchConfirmBox
{
    confirmBox = [[UIAlertView alloc] init];
    [confirmBox setDelegate:self];
    [confirmBox setTitle:@"Are you sure you want to cancel?"];
    [confirmBox addButtonWithTitle:@"OK"];
    [confirmBox setMessage:@"\n"];
    textInput = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 41.0, 245.0, 35.0)];
    
    textInput.adjustsFontSizeToFitWidth = YES;
    textInput.textColor = [UIColor blackColor];
    
    textInput.keyboardType = UIKeyboardTypeDefault;
    textInput.returnKeyType = UIReturnKeyDone;
    //textInput.textAlignment = UITextAlignmentCenter;
    textInput.backgroundColor = [UIColor whiteColor];
    textInput.borderStyle = UITextBorderStyleRoundedRect;
    textInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textInput.placeholder = @"Feedback";
    [textInput setEnabled:YES];
    
    [confirmBox addSubview:textInput];
    
    
    
    [confirmBox addButtonWithTitle:@"Cancel"];
    [confirmBox show];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    
}

-(void) launchNoShowBox
{
    noshowBox = [[UIAlertView alloc] init];
    [noshowBox setDelegate:self];
    [noshowBox setTitle:@"Do you want to report a driver no show?"];
    
    [noshowBox addButtonWithTitle:@"Yes"];
    [noshowBox addButtonWithTitle:@"No"];
    
    [noshowBox show];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == confirmBox) {
        
        
        if (buttonIndex == 0) {
            [JobCycleQuery cancelJobCalledByPassenger_jobID:[[GlobalVariables myGlobalVariables]gJob_id] feedback:textInput.text completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                [self performSelectorOnMainThread:@selector(gotoMain) withObject:nil waitUntilDone:YES];
            }];
            
            
            
        }
    }
}

- (void) gotoMain
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoMain" object:nil];  

}


/*
 -(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
 if (alertView == confirmBox) {
 if (buttonIndex == 0) {
 [self launchNoShowBox];
 }
 
 }
 
 if (alertView == noshowBox) {
 if (buttonIndex ==0)
 {
 JobQuery *cancelReportNoShow = [[JobQuery alloc]init];
 [cancelReportNoShow submitJobQuerywithMsgType:@"drivernoshow" 
 job_id:[[GlobalVariables myGlobalVariables]gJob_id]
 rating:@"0"
 driver_id:[[GlobalVariables myGlobalVariables]gDriver_id]];
 } else {
 
 JobQuery *cancelonly = [[JobQuery alloc]init];
 [cancelonly submitJobQuerywithMsgType:@"clientcancel" 
 job_id:[[GlobalVariables myGlobalVariables]gJob_id]
 rating:@"0"
 driver_id:[[GlobalVariables myGlobalVariables]gDriver_id]];
 
 }
 
 
 [[NSNotificationCenter defaultCenter]postNotificationName:@"backToMain" object:nil];
 
 }
 }
 */

@end
