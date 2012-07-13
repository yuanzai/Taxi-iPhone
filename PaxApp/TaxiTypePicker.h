//
//  TaxiTypePicker.h
//  PaxApp
//
//  Created by Junyuan Lau on 03/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TaxiTypePicker : UIPickerView <UIPickerViewDelegate>
{
    id <UIPickerViewDataSource> pickerData;    
    CGRect screenRect;
    UIViewController* sourceController;
    NSString* taxiType;
}
@property (nonatomic, strong) id<UIPickerViewDelegate> pickerDelegate;

-(id) initWithTarget:(UIViewController*)targetVC dataSource:(id) targetData delegate:(id)delegate;
- (void) showPicker;
- (void) hidePicker;

@end
