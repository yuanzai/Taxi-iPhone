//
//  TaxiTypePicker.h
//  PaxApp
//
//  Created by Junyuan Lau on 03/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxiTypePicker : UIView <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *myPickerView;
    CGRect screenRect;
    UIViewController* sourceController;
}
- (void) newPickerWithTarget:(UIViewController*)setTarget;
- (void) showPicker;
- (void) hidePicker;

@end
