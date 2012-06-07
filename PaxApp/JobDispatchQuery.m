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

+(void) submitJobWithPickupLocation:(NSString*)location Destination:(NSString*) destination TaxiType:(int)taxitype completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    
    CLLocationCoordinate2D userCoordinates = [[GlobalVariables myGlobalVariables] gUserCoordinate];
    NSNumber* toLat = [[NSNumber alloc] initWithInteger: userCoordinates.latitude];
    NSNumber* toLongi = [[NSNumber alloc] initWithInteger: userCoordinates.longitude];
    
    CLLocationCoordinate2D destiCoordinates = [[GlobalVariables myGlobalVariables] gDestiCoordinate];
    NSNumber* destiLat = [[NSNumber alloc] initWithInteger: destiCoordinates.latitude];
    NSNumber* destiLongi = [[NSNumber alloc] initWithInteger: destiCoordinates.longitude];
    
    
 //   passenger_id, mobile_number, pickup_latitude, pickup_longitude, pickup_address, pickup_point, dropoff_latitude, dropoff_longitude, dropoff_address, fare, taxitype ,device_token
    
    
    
    
    //NSString *name = [NSString alloc]initWithFormat:<#(NSString *), ...#>
    //NSString *number = [NSString alloc]initWithFormat:<#(NSString *), ...#>
    
    NSString *dropoff_address = [[GlobalVariables myGlobalVariables]gDestinationString]; 
    NSString *pickup_point = [[GlobalVariables myGlobalVariables]gPickupString];
    NSString *pickup_address = [[GlobalVariables myGlobalVariables]gUserAddress];
    NSString *mobile_number = @"92723223";
    NSString *pax_id = @"temp number";
    
    //NSString* postBody = [[NSString alloc] initWithFormat:@"{\"job\":{\"passenger_id\":\"0\",\"pickup_latitude\":\"%@\",\"pickup_longitude\":\"%@\",\"mobile_number\":\"%@\",\"pickup_address\":\"%@\",\"pickup_point\":\"%@\",\"dropoff_latitude\":\"%@\",\"dropoff_longitude\":\"%@\",\"dropoff_address\":\"%@\",\"fare\":\"123\",\"taxitype\":\"%i\",\"device_token\":\"WHO_IS_YOUR_DADDY\"}}",toLat,toLongi,mobile_number,pickup_address,pickup_point,destiLat,destiLongi,dropoff_address,taxitype];
    
    
    NSMutableDictionary* maindict = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary* dictdata = [[NSMutableDictionary alloc]init];
    [dictdata setObject:@"0" forKey:@"passenger_id"];
    [dictdata setObject:toLat forKey:@"pickup_latitude"];
    [dictdata setObject:toLongi forKey:@"pickup_longitude"];
    [dictdata setObject:mobile_number forKey:@"mobile_number"];
    [dictdata setObject:pickup_address forKey:@"pickup_address"];
    [dictdata setObject:pickup_point forKey:@"pickup_point"];
    [dictdata setObject:destiLat forKey:@"dropoff_latitude"];
    [dictdata setObject:destiLongi forKey:@"dropoff_longitude"];
    [dictdata setObject:dropoff_address forKey:@"dropoff_address"];
    [dictdata setObject:@"123" forKey:@"fare"];
    [dictdata setObject:@"0" forKey:@"taxitype"];
    [dictdata setObject:@"WHO_IS_YOUR_DADDY" forKey:@"device_token"];

    [maindict setObject:dictdata forKey:@"job"];
    
    NSData* postData = [NSJSONSerialization dataWithJSONObject:maindict options:0 error:nil];
    
    //NSLog(@"%@",maindict);

    //NSString* postBody = [[NSString alloc] initWithFormat:@"driver_id=0&lat=%@&longi=%@&name=%@&number=%@&pickup=%@&destination=%@&pax_id=%@&open=1&jobstatus=open",toLat,toLongi,name,number,location,destination,pax_id];

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    
    //Set URL for post request. Constants from constants file
    //[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostSite, kSubmitJob]]];    
    
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hopcabtest.herokuapp.com/jobs/submit_job"]]]; 
    
    //NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     // postData format - @"key=value&key2=value2"
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setTimeoutInterval:10];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
}


@end
