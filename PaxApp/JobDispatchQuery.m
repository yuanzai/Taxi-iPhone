//
//  JobDispatchQuery.m
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobDispatchQuery.h"
#import "Constants.h"
#import "GlobalVariables.h"

@implementation JobDispatchQuery

//done
+(void) submitJobWithDictionary:(NSDictionary*)dictdata completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];
    
    //job: { passenger_id, passenger_mobile_number, passenger_name, pickup_latitude, pickup_longitude, pickup_address, pickup_point, destination_latitude, destination_longitude, destination_address, fare, taxi_type, platform (ios or android), device_token }
    
    
    NSMutableDictionary* maindict = [[NSMutableDictionary alloc]init];
    [maindict setObject:dictdata forKey:@"job"];
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:maindict options:0 error:nil];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs?auth_token=%@",kHerokuHostSite,[preferences objectForKey:@"ClientAuth"]]]]; 
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setTimeoutInterval:kURLConnTimeOut];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}

@end
