//
//  DriverList.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DriverList.h"
#import "DriverItem.h"
#import "PostMethod.h"

@implementation DriverList

-(NSMutableArray*)getDriverListFromServer
{
    
    PostMethod *postMethod = [[PostMethod alloc]init];
    NSData* arrayData = [postMethod getDataFromURLPostMethod:@"driver_id=all" :[NSURL URLWithString:@"http://localhost/taxi/drivers.php"]];
    
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
        
        DriverItem *driverItem =[[DriverItem alloc]init];
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
