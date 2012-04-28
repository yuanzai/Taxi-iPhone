//
//  DriverInfo.h
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverInfo : NSObject
{
    NSDictionary* driverInfo;
    
}
-(void) getDriverInfo_useDriverID:(NSString*) driver_id;
-(NSDictionary*) driverInfo;

@end
