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
@interface SubmitJobViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
    IBOutlet UITextField* pickup;
    IBOutlet UITextField* destination;
    IBOutlet UITextField* mapaddress;
    IBOutlet UITextField* mobileNumber;
    IBOutlet UITextField* taxiType;
    
    NSString* pickupString;
    NSString* destinationString;
    
    SubmitClass *newSubmitClass;
    
    TaxiTypePicker* picker;
    
    NSString* fare;
    NSString* distance;
    
}
@property (nonatomic, strong) IBOutlet UITextField* pickup;
@property (nonatomic, strong) IBOutlet UITextField* destination;
@property (nonatomic, strong) IBOutlet UITextField* mapaddress;


@property (nonatomic,strong) NSString* pickupString;
@property (nonatomic,strong) NSString* destinationString;

- (IBAction)escapeKeyboard:(id)sender;
- (IBAction)setTextfields:(id)sender;

- (void)registerNotifications;
-(void)gotoOnroute:(NSNotification *)notification;
-(IBAction)testButton:(id)sender;
-(void) updateGeoAddress;
-(IBAction)chooseLocation:(id)sender;
-(IBAction)gotoMain:(id)sender;
-(IBAction)chooseFavourites:(id)sender;

- (IBAction)chooseTaxiType:(id)sender;
-(void) setTitle;
-(void) setFare:(NSMutableDictionary*) dict;

@end
