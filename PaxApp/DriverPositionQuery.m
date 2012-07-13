//
//  DriverPositionQuery.m
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DriverPositionQuery.h"
#import "Constants.h"

@implementation DriverPositionQuery

+(void) passengerLoginWithEmail:(NSString*) email 
{
    
}

+(void) getDriverPositionsWithCompletionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@drivers?auth_token=%@",kHerokuHostSite,[preferences objectForKey:@"ClientAuth"]]]];    
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:kURLConnTimeOut];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}


+(void) getSpecifiedDriverPositionWithDriverID:(NSString*)driver_id JobID:(NSString*) job_id CompletionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@ - driverID %@ - jobID %@",self.class,NSStringFromSelector(_cmd),driver_id,job_id);
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@/driver_position?auth_token=%@",kHerokuHostSite,job_id,[preferences objectForKey:@"ClientAuth"]]]];

    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:kURLConnTimeOut];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}




@end
