//
//  SelectedTripViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 21/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedTripViewController : UIViewController
{
    NSMutableDictionary* selectedDict;
    
    IBOutlet UILabel* dropoffField;
    IBOutlet UILabel* pickupField;
    IBOutlet UILabel* datetimeField;
    IBOutlet UILabel* driverField;
    IBOutlet UILabel* licenseField;
    UIAlertView* cancelBox;
    
    IBOutlet UIButton* callButton;
    IBOutlet UIButton* cancelButton;
    NSString* tripType;

}
@property (strong,nonatomic) NSMutableDictionary* selectedDict;
@property (strong,nonatomic) NSString* tripType;

- (void) setFields;
- (void) simulateBackButton;
- (void) closeBox;
- (IBAction)gotoMytrips:(id)sender;
-(IBAction)callButton:(id)sender;



@end
