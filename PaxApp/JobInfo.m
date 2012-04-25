//
//  JobInfo.m
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobInfo.h"
#import "PostMethod.h"

@implementation JobInfo

- (NSString*) getJobInfo_useJobID:(NSString*)job_id
{
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"job_id=%@",job_id];
    
    PostMethod *postMethod = [[PostMethod alloc]init];
    
    NSData* responseData = [postMethod getDataFromURLPostMethod:postBody :[NSURL URLWithString:@"http://localhost/taxi/job.php"]];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];    
    
    NSDictionary *jobItem = [array objectAtIndex:0];
    NSNumber *accepted =[jobItem objectForKey:@"accepted"];
    NSNumber *dcancel =[jobItem objectForKey:@"dcancel"];
    
    jobStatus = [[NSString alloc]init];
    
    if (accepted == @"1"){
        jobStatus =@"accepted";
    }else if (dcancel == @"1") {
        jobStatus =@"dcancel";
    }else {
        jobStatus =@"no response";
    }
        
    
    

    NSLog(@"%@ - responseString: %@",self.class, jobStatus);
    
    return responseString;
    
}

@end
