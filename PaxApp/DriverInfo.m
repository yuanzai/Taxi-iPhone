//
//  DriverInfo.m
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DriverInfo.h"
#import "PostMethod.h"

@implementation DriverInfo

-(void) getDriverInfo_useDriverID:(NSString*) driver_id
{
    NSString* postBody = [[NSString alloc] initWithFormat:@"driver_id=%@",driver_id];
    
    PostMethod *postMethod = [[PostMethod alloc]init];
    
    NSData* responseData = [postMethod getDataFromURLPostMethod:postBody :[NSURL URLWithString:@"http://localhost/taxi/drivers.php"]];
    
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];    
    
    driverInfoAll = array;
    driverInfo = [array objectAtIndex:0];
    
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    NSLog(@"%@ - responseString: %@",self.class, driverInfo);
    

}

-(NSArray*) driverInfoAll
{
    return driverInfoAll;
}

-(NSDictionary*) driverInfo
{    
    return driverInfo;
}


@end
