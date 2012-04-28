//
//  DriverList.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DriverPositions : NSObject
-(NSMutableArray*)getDriverListFromServer: (NSString*)driver_id;


@end
