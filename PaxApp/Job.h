//
//  JobInfo.h
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject
@property (strong, nonatomic) NSDictionary* jobItem;
- (void) getJobInfo_useJobID:(NSString*)job_id; 
- (NSDictionary*) jobItem;
+ (void) getJobInfoAsync_withJobID:(NSString*)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

@end
