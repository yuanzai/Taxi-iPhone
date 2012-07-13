//
//  DateTimePicker.m
//  PaxApp
//
//  Created by Junyuan Lau on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateTimePicker.h"

@implementation DateTimePicker
@synthesize selectedDate;
- (void) newPickerWithTarget:(UIViewController*)setTarget
{
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    
    sourceController = setTarget;
    screenRect = sourceController.view.frame;
    
    myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, 345)];
    
    dateLabel = [[UILabel alloc] init]; 
    dateLabel.frame = CGRectMake(0, 0, screenRect.size.width, 40);
    dateLabel.backgroundColor = [UIColor blackColor];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont boldSystemFontOfSize:20];
    dateLabel.textAlignment = UITextAlignmentCenter;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterLongStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    dateLabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:[NSDate date]]];
    
    [myView addSubview:dateLabel]; 

    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.hidden = NO;
    datePicker.date = [NSDate date];
    datePicker.minuteInterval = 10;
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:600];
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*14];
    
    [datePicker addTarget:self
                   action:@selector(LabelChange:)
         forControlEvents:UIControlEventValueChanged];
    [myView addSubview:datePicker];
    
    selectedDate = [NSString stringWithFormat:@"%@",
                    [df stringFromDate:[NSDate date]]];
}

-(void) showPicker
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    CGSize pickerSize = [myView sizeThatFits:CGSizeZero];
    
    CGRect startRect = CGRectMake(0.0,
                                  screenRect.size.height,
                                  pickerSize.width,
                                  pickerSize.height);
    
    
    CGRect pickerRect = CGRectMake(0.0,
                                   screenRect.size.height - pickerSize.height,
                                   pickerSize.width,
                                   pickerSize.height);
    
    myView.frame = startRect;
    [sourceController.view addSubview:myView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    myView.frame = pickerRect;
    [UIView commitAnimations];  
    
}


- (void) hidePicker
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    CGSize pickerSize = [myView sizeThatFits:CGSizeZero];
    
    if (myView.frame.origin.y == screenRect.size.height - pickerSize.height) {
        
        
        CGRect startRect = CGRectMake(0.0,
                                      screenRect.size.height,
                                      pickerSize.width,
                                      pickerSize.height);
        
        
        CGRect pickerRect = CGRectMake(0.0,
                                       screenRect.size.height - pickerSize.height,
                                       pickerSize.width,
                                       pickerSize.height);
        
        myView.frame = pickerRect;
        [sourceController.view addSubview:myView];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        
        myView.frame = startRect;
        [UIView commitAnimations];  
    }
}


- (void)LabelChange:(id)sender
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterLongStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    dateLabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:datePicker.date]];
    
    selectedDate = [NSString stringWithFormat:@"%@",
                    [df stringFromDate:[NSDate date]]];
}
@end
