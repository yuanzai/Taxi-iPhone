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

+ (void) getFareWithlocation:(CLLocationCoordinate2D)location destination:(CLLocationCoordinate2D) destination taxitype:(NSString*)taxitype completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{    
    NSString* postBody = [[NSString alloc] initWithFormat:@"pickup_latitude=%f&pickup_longitude=%f&destination_latitude=%f&destination_longitude=%f&taxi_type=%@",location.latitude, location.longitude, destination.latitude, destination.longitude,taxitype];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/jobs/fare",kHerokuHostSite]]];    
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:kURLConnTimeOut];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler]; 
}

+ (void) getNearestTimeWithlocation:(CLLocationCoordinate2D)location completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    //NSString* getString = [[NSString alloc] initWithFormat:@"latitude=%f&longitude=%f",location.latitude, location.longitude];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    //NSData *getData = [getString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     
    //NSString *getLength = [NSString stringWithFormat:@"%d", [getData length]];

    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/drivers/nearest",kHerokuHostSite]]];    
    [request setHTTPMethod:@"GET"];
    //[request setValue:getLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:kURLConnTimeOut];
    //[request setHTTPBody:getData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];

}

@end
