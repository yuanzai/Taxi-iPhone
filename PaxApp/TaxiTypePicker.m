//
//  TaxiTypePicker.m
//  PaxApp
//
//  Created by Junyuan Lau on 03/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaxiTypePicker.h"
#import "GlobalVariables.h"

@implementation TaxiTypePicker

- (void) newPickerWithTarget:(UIViewController*)setTarget
{
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    sourceController = setTarget;
    screenRect = sourceController.view.frame;
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenRect.size.height, 0, 0)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.dataSource = self;

    

    
    


}

-(void) showPicker
{
    
    CGSize pickerSize = [myPickerView sizeThatFits:CGSizeZero];
    
    CGRect startRect = CGRectMake(0.0,
                                   screenRect.size.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    
    CGRect pickerRect = CGRectMake(0.0,
                                   screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    myPickerView.frame = startRect;
    [sourceController.view addSubview:myPickerView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    myPickerView.frame = pickerRect;
    [UIView commitAnimations];  
    
}


-(void) hidePicker
{
    CGSize pickerSize = [myPickerView sizeThatFits:CGSizeZero];

    if (myPickerView.frame.origin.y == screenRect.size.height - pickerSize.height) {
        
    
    CGRect startRect = CGRectMake(0.0,
                                  screenRect.size.height,
                                  pickerSize.width,
                                  pickerSize.height);
    
    
    CGRect pickerRect = CGRectMake(0.0,
                                   screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    myPickerView.frame = pickerRect;
    [sourceController.view addSubview:myPickerView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    myPickerView.frame = startRect;
    [UIView commitAnimations];  
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    [[GlobalVariables myGlobalVariables] setGTaxiType:[NSString stringWithFormat:@"%i",row]];
    //[self hidePicker];
}


#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    
    
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
    if (row == 0){
        return [NSString stringWithFormat: @"1"];
    } else{
        return [NSString stringWithFormat: @"2"];
    }
     
    
    
} 

@end
