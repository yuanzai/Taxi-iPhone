//
//  GlobalVariablePositions.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables

@synthesize gDriverList, gUserCoordinate, gUserAddress, gDeviceToken, gIsOnJob, gAdvancedForm, gCurrentForm, gGoto;

static GlobalVariables* myGlobalVariables;

+ (GlobalVariables*)myGlobalVariables
{
    if (!myGlobalVariables) {
        myGlobalVariables = [[GlobalVariables alloc] init];
    }
    return myGlobalVariables;
}


- (void) clearGlobalData
{
    gDriverList = nil;
    [gCurrentForm setObject:@"" forKey:@"id"];
    [gCurrentForm setObject:@"" forKey:@"job_Status"];
    gUserAddress = @"";
}
//[[GlobalVariablePositions myGlobalVariablePositions] setSavedString:@"HELLO"]; - eg setting gvs
@end