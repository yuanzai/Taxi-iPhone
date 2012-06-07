//
//  JobCycleQuery.h
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobCycleQuery : NSObject
+ (void) onboardJobCalledByPassenger_jobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;
+ (void) cancelJobCalledByPassenger_jobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;
+ (void) jobExpired_jobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

@end
