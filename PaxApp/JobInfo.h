//
//  JobInfo.h
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobInfo : NSObject
{
    NSString *jobStatus;
}
- (NSString*) getJobInfo_useJobID:(NSString*)job_id;


@end
