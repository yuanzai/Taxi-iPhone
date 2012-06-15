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

+(void) submitJobWithPickupLocation:(NSString*)location Destination:(NSString*) destination TaxiType:(NSString*)taxitype fare:(NSString*)fare mobile:(NSString*)mobile_number completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    
    CLLocationCoordinate2D userCoordinates = [[GlobalVariables myGlobalVariables] gUserCoordinate];
    NSNumber* pickup_latitude = [[NSNumber alloc] initWithFloat: userCoordinates.latitude];
    NSNumber* pickup_longitude = [[NSNumber alloc] initWithFloat: userCoordinates.longitude];
    
    CLLocationCoordinate2D destiCoordinates = [[GlobalVariables myGlobalVariables] gDestiCoordinate];
    NSNumber* dropoff_latitude = [[NSNumber alloc] initWithFloat: destiCoordinates.latitude];
    NSNumber* dropoff_longitude = [[NSNumber alloc] initWithFloat: destiCoordinates.longitude];
    
    
    NSString *dropoff_address = [[GlobalVariables myGlobalVariables]gDestinationString]; 
    NSString *pickup_point = [[GlobalVariables myGlobalVariables]gPickupString];
    NSString *pickup_address = [[GlobalVariables myGlobalVariables]gUserAddress];
    NSString *pax_id = @"temp number";
    NSString* passenger_name =@"temp name";
    NSString* device_token =@"temp token";


//job: { passenger_id, passenger_mobile_number, passenger_name, pickup_latitude, pickup_longitude, pickup_address, pickup_point, destination_latitude, destination_longitude, destination_address, fare, taxi_type, platform (ios or android), device_token }

    
    NSMutableDictionary* maindict = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary* dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setObject:@"0" forKey:@"passenger_id"];
    [dictdata setObject:mobile_number forKey:@"passenger_mobile_number"];
    [dictdata setObject:passenger_name forKey:@"passenger_name"];
    
    [dictdata setObject:pickup_latitude forKey:@"pickup_latitude"];
    [dictdata setObject:pickup_longitude forKey:@"pickup_longitude"];
    [dictdata setObject:pickup_address forKey:@"pickup_address"];
    [dictdata setObject:pickup_point forKey:@"pickup_point"];
    
    [dictdata setObject:dropoff_latitude forKey:@"dropoff_latitude"];
    [dictdata setObject:dropoff_longitude forKey:@"dropoff_longitude"];
    [dictdata setObject:dropoff_address forKey:@"dropoff_address"];
    
    [dictdata setObject:fare forKey:@"fare"];
    [dictdata setObject:taxitype forKey:@"taxitype"];
    
    [dictdata setObject:@"ios" forKey:@"platform"];
    [maindict setObject:device_token forKey:@"device_token"];
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:maindict options:0 error:nil];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@api/jobs/submit",kHerokuHostSite]]]; 
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
