//
//  JobCycleQuery.h
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobCycleQuery : NSObject
+ (void) onboardJobCalledByPassengerWithJobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;
+ (void) cancelJobCalledByPassenger_jobID:(NSString *)job_id feedback:(NSString*) feedback completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;
+ (void) jobExpiredWithJobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;
+ (void) checkJobWithJobID:(NSString*)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;
+ (NSData*) checkJobSynchronouslyWithJobID:(NSString*) job_id;

@end
