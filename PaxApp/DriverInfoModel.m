//
//  DriverInfoModel.m
//  PaxApp
//
//  Created by Junyuan Lau on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DriverInfoModel.h"
#import "DriverInfoQuery.h"
#import "GlobalVariables.h"

@implementation DriverInfoModel

- (void) getDriverInfoWithDriverID:(NSString*) driver_id
{
    
    [DriverInfoQuery getDriverInfoAsync_withDriverID:driver_id completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableDictionary *dict = [array objectAtIndex:0];
        [[GlobalVariables myGlobalVariables] setGDriverInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"driverInfoUpdated" object:nil];
        
        
    }];
    
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));        
}

@end
