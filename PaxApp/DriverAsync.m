//
//  DriverAsync.m
//  PaxApp
//
//  Created by Junyuan Lau on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DriverAsync.h"
#import "DriverPositions.h"
#import "DriverAnnotation.h"
#import "PostMethodAsync.h"
#import "DriverInfo.h"
#import "GlobalVariables.h"

@implementation DriverAsync

-(void) getDriverInfo_useDriverID:(NSString*) driver_id
{
    NSString* postBody = [[NSString alloc] initWithFormat:@"driver_id=%@",driver_id];
    
    PostMethodAsync *postMethodAsync = [[PostMethodAsync alloc]init];
    
    [postMethodAsync sendAsyncPostMethod_PostBody:postBody postURL:[NSURL URLWithString:@"http://localhost/taxi/drivers.php"] setDelegate:self];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];  
    
    
    
    newKey = [[NSMutableDictionary alloc]init];
    oldKey = [[GlobalVariables myGlobalVariables]gDriverList];
    
    int x = 0;
    while (x<[array count])
    {
        
        NSDictionary *rawDriverItem = [array objectAtIndex:x];
        float lat = [[rawDriverItem objectForKey:@"lat"] floatValue]/1E6;
        float longi = [[rawDriverItem objectForKey:@"longi"] floatValue]/1E6;
        NSString* driver_id = [rawDriverItem objectForKey:@"driver_id"];
        
        
        
        if ([oldKey objectForKey:driver_id] != nil){
            DriverAnnotation *driverItem =[[DriverAnnotation alloc]init];
            driverItem = [oldKey objectForKey:driver_id];
            [driverItem initWithCoordinate:CLLocationCoordinate2DMake(lat, longi)];
            [newKey setValue:driverItem forKey:driver_id]; 
        } else {
            DriverAnnotation *driverItem =[[DriverAnnotation alloc]init];
            driverItem.driverInfo = rawDriverItem;
            driverItem.driver_id = driver_id;
            driverItem.title = driver_id;
            [driverItem initWithCoordinate:CLLocationCoordinate2DMake(lat, longi)];
            
            [newKey setValue:driverItem forKey:driver_id]; 
        }
        
        rawDriverItem = nil;
        x++;
    };
        
    [[GlobalVariables myGlobalVariables] setGDriverList:newKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"driverListUpdated" object: nil ];
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));    
}

@end
