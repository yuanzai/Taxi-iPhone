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
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@/cancel?auth_token=%@",kHerokuHostSite, job_id, [preferences objectForKey:@"ClientAuth"]]]];    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:kURLConnTimeOut];
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}


+ (void) onboardJobCalledByPassengerWithJobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@ - JobID - %@",self.class,NSStringFromSelector(_cmd), job_id);
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@/onboard?auth_token=%@",kHerokuHostSite, job_id,[preferences objectForKey:@"ClientAuth"]]]];    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:kURLConnTimeOut];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}
    
    
+ (void) jobExpiredWithJobID:(NSString *)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@ - JobID - %@",self.class,NSStringFromSelector(_cmd), job_id);
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@/expire?auth_token=%@",kHerokuHostSite, job_id,[preferences objectForKey:@"ClientAuth"]]]];    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:kURLConnTimeOut];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}

+(void) checkJobWithJobID:(NSString*)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@ - JobID - %@",self.class,NSStringFromSelector(_cmd), job_id);
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@?auth_token=%@", kHerokuHostSite, job_id,[preferences objectForKey:@"ClientAuth"]]]];   
    
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:kURLConnTimeOut];
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];    
}

+(NSData*) checkJobSynchronouslyWithJobID:(NSString*) job_id
{
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@?auth_token=%@", kHerokuHostSite, job_id,[preferences objectForKey:@"ClientAuth"]]]];   
    
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:kURLConnTimeOut];
    
    NSError* error;
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error){
        return nil;
    }else {
        return data;
    }
}

@end
