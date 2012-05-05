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
#import "DriverInfo.h"
#import "GlobalVariables.h"

@implementation DriverPositions

-(NSMutableDictionary*)getDriverListFromServer: (NSString*)driver_id
{
    if (!driverInfo)
        driverInfo = [[DriverInfo alloc] init];
       
    [driverInfo getDriverInfo_useDriverID:driver_id];
    
    NSLog(@"%@ - %@ - Driver Array: %@",self.class,NSStringFromSelector(_cmd),driverInfo.driverInfoAll);

    
    newKey = [[NSMutableDictionary alloc]init];
    oldKey = [[GlobalVariables myGlobalVariables]gDriverList];
    
    int x = 0;
    while (x<[driverInfo.driverInfoAll count])
    {
        
        NSDictionary *rawDriverItem = [driverInfo.driverInfoAll objectAtIndex:x];
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
   
    return newKey;
}




@end
