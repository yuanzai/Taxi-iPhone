//
//  DriverPositionQuery.h
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverPositionQuery : NSObject

+(void) getAllDriverPositionsWithcompletionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+(void) getDriverPositionsWithDriver_id:(NSString*)driver_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;


@end
