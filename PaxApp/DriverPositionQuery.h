//
//  DriverPositionQuery.h
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverPositionQuery : NSObject


+(void) passengerLoginWithEmail:(NSString*) email; 


+(void) getDriverPositionsWithCompletionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+(void) getSpecifiedDriverPositionWithDriverID:(NSString*)driver_id JobID:(NSString*) job_id CompletionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;


@end
