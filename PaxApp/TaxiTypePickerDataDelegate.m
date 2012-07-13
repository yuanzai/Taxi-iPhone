//
//  TaxiTypePickerDataDelegate.m
//  PaxApp
//
//  Created by Junyuan Lau on 07/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaxiTypePickerDataDelegate.h"

@implementation TaxiTypePickerDataDelegate

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    return 2;
}


@end
