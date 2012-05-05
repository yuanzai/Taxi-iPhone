//
//  DriverList.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DriverInfo;
@interface DriverPositions : NSObject
{
    DriverInfo *driverInfo;
    NSMutableDictionary *newKey;
    NSMutableDictionary *oldKey;
}

-(NSMutableDictionary*)getDriverListFromServer: (NSString*)driver_id;


@end
