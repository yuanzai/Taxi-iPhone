//
//  TaxiTypePicker.m
//  PaxApp
//
//  Created by Junyuan Lau on 03/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaxiTypePicker.h"
#import "GlobalVariables.h"
#import "TaxiTypePickerDataDelegate.h"

@implementation TaxiTypePicker
@synthesize pickerDelegate;

-(id) initWithTarget:(UIViewController*)targetVC dataSource:(id) targetData delegate:(id)delegate
{
    pickerData = [[TaxiTypePickerDataDelegate alloc]init];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    self = [super init];
    if (self) {

    sourceController = targetVC;
    screenRect = sourceController.view.frame;    
        //self.frame = CGRectMake(0, 0, 0, 0);
    self.delegate = delegate;
    self.showsSelectionIndicator = YES;
    self.dataSource = pickerData;
    } return self;

}

-(void) showPicker
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    NSLog(@"Screen Height %f",sourceController.view.frame.size.height);

    CGSize pickerSize = [self sizeThatFits:CGSizeZero];
    
    CGRect startRect = CGRectMake(0.0,
                                   screenRect.size.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    
    CGRect pickerRect = CGRectMake(0.0,
                                   screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    self.frame = startRect;
    [sourceController.view addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    self.frame = pickerRect;
    [UIView commitAnimations];  
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    
}


-(void) hidePicker
{
    CGSize pickerSize = [self sizeThatFits:CGSizeZero];

    if (self.frame.origin.y == screenRect.size.height - pickerSize.height) {
        
    
    CGRect startRect = CGRectMake(0.0,
                                  screenRect.size.height,
                                  pickerSize.width,
                                  pickerSize.height);
    
    
    CGRect pickerRect = CGRectMake(0.0,
                                   screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    self.frame = pickerRect;
    [sourceController.view addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    self.frame = startRect;
    [UIView commitAnimations];  
    }
}



@end
