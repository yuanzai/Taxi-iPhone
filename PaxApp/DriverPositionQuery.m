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

+(void) getAllDriverPositionsWithcompletionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    //Set URL for post request. Constants from constants file

    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",kHostSite, kGetDriverPosition]]];    
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"driver_id=all"];
    
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


+(void) getDriverPositionsWithDriver_id:(NSString*)driver_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    //Set URL for post request. Constants from constants file
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostSite, kGetDriverPosition]]];    
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"driver_id=%@",driver_id];
    
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
