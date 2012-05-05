//
//  JobQuery.m
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobQuery.h"
#import "PostMethod.h"

@implementation JobQuery
/* message types
 
 //completed
 //drivercancellate
 //drivernoshow
 //clientcancel
 //drivercancel
 //driveraccept
 //driverpicked
 //clientnoshow 
 //clientonboard
 //driverreached
  */




-(NSString*) submitJobQuerywithMsgType:(NSString*)msgtype job_id:(NSString*)job_id rating:(NSString *)rating driver_id:(NSString*)driver_id
{
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"msgtype=%@&job_id=%@&rating=%@&driver_id=%@",msgtype,job_id,rating,driver_id];
    
    PostMethod *postMethod = [[PostMethod alloc]init];
    
    NSData* responseData = [postMethod getDataFromURLPostMethod:postBody :[NSURL URLWithString:@"http://localhost/taxi/jobquery.php"]];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    
    return responseString;
    
}

@end
