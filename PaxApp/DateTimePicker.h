//
//  DateTimePicker.h
//  PaxApp
//
//  Created by Junyuan Lau on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimePicker : NSObject
{
    UIDatePicker* datePicker;
    CGRect screenRect;
    UIViewController* sourceController;
    UILabel* dateLabel;
    UIView* myView;
    
    NSString* selectedDate;
    NSString* selectedDateProperString;
    BOOL isOpen;
    
}
@property BOOL isOpen;
@property (strong, nonatomic) NSString* selectedDate;
@property (strong, nonatomic) NSString* selectedDateProperString;

- (void) newPickerWithTarget:(UIViewController*)setTarget;
- (void) showPicker;
- (void) hidePicker;
- (void)LabelChange:(id)sender;


@end
