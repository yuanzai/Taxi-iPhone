//
//  JobQuery.h
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobQuery : NSObject
-(NSString*) submitJobQuerywithMsgType:(NSString*)msgtype job_id:(NSString*)job_id rating:(NSString *)rating driver_id:(NSString*)driver_id;
@end
