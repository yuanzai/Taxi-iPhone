//
//  CancelJob.m
//  PaxApp
//
//  Created by Junyuan Lau on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CancelJob.h"
#import "JobQuery.h"
#import "GlobalVariables.h"
@implementation CancelJob


-(void) launchConfirmBox
{
    confirmBox = [[UIAlertView alloc] init];
    [confirmBox setDelegate:self];
    [confirmBox setTitle:@"Are you sure you want to cancel?"];
    [confirmBox addButtonWithTitle:@"Yes"];
    [confirmBox addButtonWithTitle:@"Yes - Driver did not show"];

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
        switch (buttonIndex) {
            case 0:
            {
                JobQuery *cancelReport = [[JobQuery alloc]init];
                [cancelReport submitJobQuerywithMsgType:@"clientcancel" 
                                                       job_id:[[GlobalVariables myGlobalVariables]gJob_id]
                                                       rating:@"0"
                                                    driver_id:[[GlobalVariables myGlobalVariables]gDriver_id]];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoMain" object:nil];

                break;
            }
            case 1:
            {
                JobQuery *cancelReportNoShow = [[JobQuery alloc]init];
                [cancelReportNoShow submitJobQuerywithMsgType:@"drivernoshow" 
                                                       job_id:[[GlobalVariables myGlobalVariables]gJob_id]
                                                       rating:@"0"
                                                    driver_id:[[GlobalVariables myGlobalVariables]gDriver_id]];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoMain" object:nil];

                break;  
            }
            default:
            {
                break;
            }
        }
    }
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
