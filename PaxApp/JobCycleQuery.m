//
//  JobCycleQuery.m
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobCycleQuery.h"
#import "Constants.h"

@implementation JobCycleQuery
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
+ (void) cancelJobCalledByPassenger_jobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSString* postBody = [[NSString alloc] initWithFormat:@"msgtype=clientcancel&job_id=%@",job_id];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    //Set URL for post request. Constants from constants file
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostSite, kCancelJobCalledByPassenger]]];    
    
    
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     // postData format - @"key=value&key2=value2"
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:10];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}


+ (void) onboardJobCalledByPassenger_jobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    
        
    NSString* postBody = [[NSString alloc] initWithFormat:@"msgtype=clientonboard&job_id=%@",job_id];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    //Set URL for post request. Constants from constants file
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostSite, kOnboardJobCalledByPassenger]]];    
    
    
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     // postData format - @"key=value&key2=value2"
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:10];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}
    
    
+ (void) jobExpired_jobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"msgtype=clientcancel&job_id=%@",job_id];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    //Set URL for post request. Constants from constants file
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostSite, kJobExpired]]];    
    
    
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     // postData format - @"key=value&key2=value2"
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:10];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}


@end
