//
//  FakeMyTripsArray.m
//  PaxApp
//
//  Created by Junyuan Lau on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FakeMyTripsArray.h"

@implementation FakeMyTripsArray

- (id) init
{
    NSDictionary* dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:
    @"pick up place", @"pickup_address",
    @"destination", @"destination_address",
    @"21 March 2012 9 am", @"pickup_datetime",
    @"Pending", @"job_status",
    @"Mr Driver", @"driver_name",
    @"SBC 1234", @"driver_license",
    @"1234567", @"driver_number",
    nil];
    
    NSLog(@"%@",dict1);
    self = [super initWithObjects:dict1, nil];
    if (self) {
    }
    return self;
    
}

@end
