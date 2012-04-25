//
//  UserSubmitJob.m
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostNewJob.h"
#import "PostMethod.h"
#import "GlobalVariablePositions.h"

@implementation PostNewJob

- (NSString*) postNewJobwithdriverID:(NSString*)driver_id pickupAddress:(NSString*)pickup destinationAddress:(NSString *)destination
{
    
    CLLocationCoordinate2D userCoordinates = [[GlobalVariablePositions myGlobalVariablePositions] gUserCoordinate];
    
    NSNumber* toLat = [[NSNumber alloc] initWithInteger: userCoordinates.latitude*1E6];
    NSNumber* toLongi = [[NSNumber alloc] initWithInteger: userCoordinates.longitude*1E6];

    
    
    
    //NSString *name = [NSString alloc]initWithFormat:<#(NSString *), ...#>
    //NSString *number = [NSString alloc]initWithFormat:<#(NSString *), ...#>
    NSString *name = @"temp name";
    NSString *number = @"temp number";
    NSString *pax_id = @"temp number";
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"driver_id=%@&lat=%@&longi=%@&name=%@&number=%@&pickup=%@&destination=%@&pax_id=%@&open=1",driver_id,toLat,toLongi,name,number,pickup,destination,pax_id];
    
    PostMethod *postMethod = [[PostMethod alloc]init];
    NSData* responseData = [postMethod getDataFromURLPostMethod:postBody :[NSURL URLWithString:@"http://localhost/taxi/postjob.php"]];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    
    NSLog(@"%@ - posted: %@",self.class, postBody);
    NSLog(@"%@ - serverResponse: %@",self.class, responseString);
    
    return responseString;
   
}


@end
