//
//  GlobalVariablePositions.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalVariablePositions.h"



@implementation GlobalVariablePositions

@synthesize gDriverList, gUserCoordinate, pickupString, destinationString;

static GlobalVariablePositions* myGlobalVariablePositions;

+ (GlobalVariablePositions*)myGlobalVariablePositions
{
    if (!myGlobalVariablePositions) {
        myGlobalVariablePositions = [[GlobalVariablePositions alloc] init];
    }
    return myGlobalVariablePositions;
}


//[[GlobalVariablePositions myGlobalVariablePositions] setSavedString:@"HELLO"]; - eg setting gvs
@end