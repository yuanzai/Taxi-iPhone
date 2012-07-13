//
//  SubmitJobViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubmitClass;
@class TaxiTypePicker;
@class CustomNavBar;
@class SubmitForm;
@interface SubmitJobViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIPickerViewDelegate>
{
    IBOutlet UITextField* pickup;
    IBOutlet UITextField* destination;
    IBOutlet UITextField* mapaddress;
    IBOutlet UITextField* mobileNumber;
    IBOutlet UITextField* taxiType;
    
    NSString* pickupString;
    NSString* destinationString;
    
    SubmitClass *newSubmitClass;
    SubmitForm *thisForm;
    
    TaxiTypePicker* picker;
    
    NSString* fare;
    NSString* distance;
    
    CustomNavBar *thisNavBar;
    
    

}
@property (nonatomic, strong) IBOutlet UITextField* pickup;
@property (nonatomic, strong) IBOutlet UITextField* destination;
@property (nonatomic, strong) IBOutlet UITextField* mapaddress;


@property (nonatomic,strong) NSString* pickupString;
@property (nonatomic,strong) NSString* destinationString;

- (IBAction)escapeKeyboard:(id)sender;
//- (IBAction)setTextfields:(id)sender;

- (void)registerNotifications;
- (void)gotoOnroute:(NSNotification *)notification;


-(IBAction)chooseLocation:(id)sender;
-(IBAction)gotoMain:(id)sender;
-(IBAction)chooseFavourites:(id)sender;

- (IBAction)chooseTaxiType:(id)sender;
-(void) setTitle;
-(void) setFare:(NSMutableDictionary*) dict;

- (void) setInitialTextfields;



@end
