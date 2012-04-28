//
//  JobInfo.h
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject
{
    NSDictionary *jobItem;
}

- (void) getJobInfo_useJobID:(NSString*)job_id; 
- (NSDictionary*) jobItem;


@end
