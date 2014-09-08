//
//  AdvancedViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class DateTimePicker;
@class TaxiTypePicker;

@interface AdvancedViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate>
{
    
    IBOutlet UIDatePicker *datePicker;
    DateTimePicker* myPicker;
    TaxiTypePicker* taxiPicker;
    IBOutlet UIButton *escapeButton;
    
    CLLocationCoordinate2D userCoordinates;
    CLLocationCoordinate2D destiCoordinates;
    
    
    IBOutlet UITextField* pickupField;
    IBOutlet UITextField* locationField;
    IBOutlet UITextField* dropoffField;
    IBOutlet UITextField* mobileField;
    
    IBOutlet UITextField* taxiType;    
    IBOutlet UITextField* dateField;
    IBOutlet UILabel *datelabel;

    NSMutableDictionary* bookingForm;
    NSUserDefaults* preferences;
    
    
}

- (IBAction) escapeKeyboard:(id)sender;
- (IBAction) openDatePicker:(id)sender;
- (IBAction) openTaxiPicker:(id)sender;
- (IBAction) pressedSubmitButton:(id)sender;
- (void) setFields;
- (IBAction)chooseLocation:(id)sender;
- (IBAction)chooseFavourites:(id)sender;

@end
