//
//  SignInViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField* emailField;
    IBOutlet UITextField* passwordField;
    IBOutlet UITextField* nameField;
    IBOutlet UITextField* mobileField;
    IBOutlet UIButton* registerButton;
    IBOutlet UIButton* loginButton;
    IBOutlet UIButton* cancelButton;
    IBOutlet UIButton* okButton;
    IBOutlet UIView* registerView;
    IBOutlet UIImageView* fakeSplash;
    
    IBOutlet UILabel* topLabel;
    NSUserDefaults* preferences;
}

- (void)showLogin;
- (void)printLabel:(NSString*) label;
- (void)registerNotification;


//gotos!
-(void)gotoSubmitJob:(id)sender;

-(void)gotoMain:(NSNotification*) notification;
-(void)gotoMainSelector:(id)sender;

-(void)gotoLogin:(NSNotification*) notification;
-(void)gotoLoginSelector;


@end
