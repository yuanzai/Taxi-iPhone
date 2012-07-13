//
//  ProfileViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 15/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField* nameField;
    IBOutlet UITextField* mobileField;
    IBOutlet UITextField* emailField;
    IBOutlet UITextField* passwordField;
    NSUserDefaults *preferences;
}
- (IBAction)escapeKeyboard:(id)sender;
- (void) setFields;

@end
