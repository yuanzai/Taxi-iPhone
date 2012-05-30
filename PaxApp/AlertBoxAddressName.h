//
//  AlertBoxAddressName.h
//  PaxApp
//
//  Created by Junyuan Lau on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertBoxAddressName : NSObject <UITextFieldDelegate, UIAlertViewDelegate>
{
    UIAlertView *dialog;
    NSString *inputName;
    UITableView *inputTable;
    UITextField *inputField;
}
@property (strong, nonatomic) NSString *inputName;
@property (strong, nonatomic) UITextField *inputField;
-(void)initWithDelegate:(id<UIAlertViewDelegate>)setdelegate;

@end
