//
//  DriverInfo.h
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverInfoQuery : NSObject

+(void) getDriverInfoAsync_withDriverID:(NSString*)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

@end
