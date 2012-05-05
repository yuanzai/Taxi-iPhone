//
//  PrefsViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrefsViewController : UITableViewController<UITextFieldDelegate>
{
    UITextField *nameField;
    UITextField *numField;
    NSUserDefaults *preferences;
    UITextField * focusedTextField;

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField;
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField;

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField;

@end
