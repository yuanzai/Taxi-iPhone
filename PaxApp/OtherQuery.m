//
//  OtherQuery.m
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OtherQuery.h"
#import "Constants.h"

@implementation OtherQuery

+ (void) getETAWithlocation:(CLLocationCoordinate2D)location destination:(CLLocationCoordinate2D) destination completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSString* postBody = [[NSString alloc] initWithFormat:@"fromLat=%f$fromLongi=%f&toLat=%f&toLongi=%f",location.latitude, location.longitude, destination.latitude, destination.longitude];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostSite, kGetETA]]];    
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:10];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];    
}

+ (void) getFareWithlocation:(CLLocationCoordinate2D)location destination:(CLLocationCoordinate2D) destination completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{    
    NSString* postBody = [[NSString alloc] initWithFormat:@"fromLat=%f&fromLongi=%f&toLat=%f&toLongi=%f",location.latitude, location.longitude, destination.latitude, destination.longitude];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostSite, kGetFare]]];    
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:10];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler]; 
}

+ (void) getNearestTimeWithlocation:(CLLocationCoordinate2D)location completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSString* postBody = [[NSString alloc] initWithFormat:@"lat=%f&longi=%f",location.latitude, location.longitude];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostSite, kGetNearestTime]]];    
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
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
