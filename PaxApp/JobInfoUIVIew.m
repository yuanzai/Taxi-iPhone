//
//  JobInfoUIVIew.m
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobInfoUIVIew.h"
#import "GlobalVariables.h"
@implementation JobInfoUIVIew
@synthesize destination, driver,license;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        destination.text = [[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"dropoff_address"];
        NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));    }
    return self;
}

- (void) setLabels
{
    
    destination.text = [[[GlobalVariables myGlobalVariables]gCurrentForm]objectForKey:@"dropoff_address"];
    driver.text = [[[GlobalVariables myGlobalVariables] gCurrentForm] objectForKey:@"driver_name"];
    license.text = [[[GlobalVariables myGlobalVariables] gCurrentForm] objectForKey:@"license_plate_number"];
}


@end
