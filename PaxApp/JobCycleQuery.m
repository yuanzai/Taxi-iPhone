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
+ (void) cancelJobCalledByPassenger_jobID:(NSString *)job_id feedback:(NSString*) feedback completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHerokuHostSite, job_id]]];    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:kURLConnTimeOut];
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}


+ (void) onboardJobCalledByPassengerWithJobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@ - JobID - %@",self.class,NSStringFromSelector(_cmd), job_id);

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/jobs/%@/onboard",kHerokuHostSite, job_id]]];    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:kURLConnTimeOut];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}
    
    
+ (void) jobExpiredWithJobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@ - JobID - %@",self.class,NSStringFromSelector(_cmd), job_id);

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/jobs/%@/expire",kHerokuHostSite, job_id]]];    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:kURLConnTimeOut];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}

+(void) checkJobWithJobID:(NSString*)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@ - JobID - %@",self.class,NSStringFromSelector(_cmd), job_id);
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/jobs/%@", kHerokuHostSite, job_id]]];   
    
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:kURLConnTimeOut];
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];    
}
@end
