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
#import "JobCycleQuery.h"

@implementation DriverInfoModel

+ (void) getDriverInfo
{    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));        

    [JobCycleQuery checkJobWithJobID:[[GlobalVariables myGlobalVariables] gJob_id] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (response && data){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
            if ([httpResponse statusCode]== 200) {
                
                 NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                [[GlobalVariables myGlobalVariables] setGDriverInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"driverInfoUpdated" object:nil];
            
            } else {
                NSLog(@"%@ - %@ - No response from server",self.class,NSStringFromSelector(_cmd));
            }
        }
    }];
    
}

@end
