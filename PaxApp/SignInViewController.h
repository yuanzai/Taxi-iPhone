//
//  SignInViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

@class LoginModel;
@class HTTPQueryModel;

@interface SignInViewController : UIViewController<UITextFieldDelegate, LoginModelDelegate>
{
    IBOutlet UITextField* emailField;
    IBOutlet UITextField* passwordField;
    IBOutlet UIView* registerView;
    IBOutlet UIButton* escapeButton;
    IBOutlet UILabel* topLabel;
    NSUserDefaults* preferences;
    LoginModel* myLogin;
    HTTPQueryModel* testQuery;
    UIActivityIndicatorView *activityView;
    UIView* viewBlocker;
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
-(IBAction)clickRegisterButton:(id)sender;


@end
