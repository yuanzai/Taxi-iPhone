//
//  GetETA.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetETA.h"
#import "PostMethod.h"
#import "GlobalVariablePositions.h"


@implementation GetETA

-(NSString *)eta
{
    return eta;
}

-(void)startETAThread:(id <MKAnnotation>)anno
{
    NSLog(@"start ETA Thread");
    [NSThread detachNewThreadSelector:@selector(getETAfromServer:)   
                                 toTarget:self withObject:anno];  

}

-(NSString *)getETAfromServer:(id <MKAnnotation>)anno
{
    
    CLLocationCoordinate2D driverCoordinates;
    driverCoordinates = [anno coordinate];
    
    
    
    NSNumber* fromLat = [[NSNumber alloc] initWithFloat: driverCoordinates.latitude];    
    NSNumber* fromLongi = [[NSNumber alloc] initWithFloat: driverCoordinates.longitude];
    
    CLLocationCoordinate2D userCoordinates = [[GlobalVariablePositions myGlobalVariablePositions] gUserCoordinate];
    
    NSNumber* toLat = [[NSNumber alloc] initWithFloat: userCoordinates.latitude];
    NSNumber* toLongi = [[NSNumber alloc] initWithFloat: userCoordinates.longitude];

    
    NSString* postBody = [[NSString alloc] initWithFormat:@"url=&fromLat=%@&fromLongi=%@&toLat=%@&toLongi=%@&type=duration",fromLat,fromLongi,toLat,toLongi];
    NSLog(@"Post Lat - %@",fromLat);
    
    //NSString* postBody = [[NSString stringWithFormat:(@"url=&fromLat=%@&fromLongi=%@&toLat=%@&toLongi=%@&type=duration",fromLat,fromLongi,toLat,toLongi)];
    
    
    NSLog(@"Post Body - %@",postBody);
    
    PostMethod *postMethod = [[PostMethod alloc]init];
    NSData* etaData = [postMethod getDataFromURLPostMethod:postBody :[NSURL URLWithString:@"http://localhost/taxi/getduration.php"]];
       
    NSString *responseString = [[NSString alloc] initWithData:etaData encoding:NSUTF8StringEncoding]; 
    
    
    if(!eta) 
    {
        eta = [[NSString alloc]init];
    }
    
    eta = responseString;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ETA" object:nil];

    return responseString;

}


@end
