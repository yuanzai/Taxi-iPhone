//
//  JobInfo.m
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Job.h"
#import "PostMethod.h"

@implementation Job
/*
 if (!newJob)
 newJob = [[Job alloc] init];
 
 [newJob getJobInfo_useJobID:job_id];
 
 [newJob.jobItem objectForKey:@"accepted"] == @"1";
 
 
 */

- (void) getJobInfo_useJobID:(NSString*)job_id 
{
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"job_id=%@",job_id];
    
    PostMethod *postMethod = [[PostMethod alloc]init];
    
    NSData* responseData = [postMethod getDataFromURLPostMethod:postBody :[NSURL URLWithString:@"http://localhost/taxi/job.php"]];
    
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];    
    
    jobItem = [array objectAtIndex:0];
    
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    NSLog(@"%@ - responseString: %@",self.class, jobItem);

}

-(NSDictionary*) jobItem
{
    return jobItem;
}

@end
