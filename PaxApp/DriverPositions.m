//
//  DriverList.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DriverPositions.h"
#import "DriverAnnotation.h"
#import "PostMethod.h"

@implementation DriverPositions

-(NSMutableArray*)getDriverListFromServer: (NSString*)driver_id
{
    
    NSString* postURL = [NSString stringWithFormat:@"driver_id=%@",driver_id];
                         
    
    PostMethod *postMethod = [[PostMethod alloc]init];
    NSData* arrayData = [postMethod getDataFromURLPostMethod:postURL :[NSURL URLWithString:@"http://localhost/taxi/drivers.php"]];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:arrayData options:NSJSONReadingMutableLeaves error:nil];    
    
    
    NSString *responseString = [[NSString alloc] initWithData:arrayData encoding:NSUTF8StringEncoding];
    NSLog(@"String Data received from URL - %@",responseString);
    NSLog([NSString stringWithFormat: @"Driver count - %d", [array count]]);
    
    NSMutableArray *driverList = [[NSMutableArray alloc]init];
    int x = 0;
    while (x<[array count])
    {
        NSDictionary *rawDriverItem = [array objectAtIndex:x];
        NSNumber *driver_id = [rawDriverItem objectForKey:@"driver_id"];
        float lat = [[rawDriverItem objectForKey:@"lat"] floatValue]/1E6;
        float longi = [[rawDriverItem objectForKey:@"longi"] floatValue]/1E6;
        
        DriverAnnotation *driverItem =[[DriverAnnotation alloc]init];
        driverItem.driverInfo = rawDriverItem;
        driverItem.driver_id = driver_id;
        driverItem.title = [NSString stringWithFormat: @"%@",driver_id];
        CLLocationCoordinate2D location;     
        
        location.latitude = lat ;
        location.longitude = longi;
        
        [driverItem initWithCoordinate:location];
        
        [driverList addObject:driverItem];
        NSLog(@"driver_id - %@ lat = %f longi = %f",driverItem.driver_id,location.latitude, location.longitude);
        
        rawDriverItem = nil;
        x++;
    };
   
    return driverList;
}




@end
