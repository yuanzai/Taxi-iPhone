//
//  AlertBoxAddressName.m
//  PaxApp
//
//  Created by Junyuan Lau on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertBoxAddressName.h"

@implementation AlertBoxAddressName
@synthesize inputName, inputField;

-(void)initWithDelegate:(id<UIAlertViewDelegate>)setdelegate {
    
    dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:setdelegate];
    [dialog setTitle:@"Address Name"];
    [dialog setMessage:@"/n "];
    [dialog addButtonWithTitle:@"Cancel"];
    
    [dialog addButtonWithTitle:@"OK"];
    

    
    UITextField *newField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 40.0, 245.0, 35.0)];
    
    newField.adjustsFontSizeToFitWidth = YES;
    newField.textColor = [UIColor blackColor];

    newField.keyboardType = UIKeyboardTypeDefault;
    newField.returnKeyType = UIReturnKeyDone;
    newField.textAlignment = UITextAlignmentCenter;
    newField.backgroundColor = [UIColor whiteColor];
    newField.borderStyle = UITextBorderStyleRoundedRect;
    newField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [newField setEnabled:YES];
    inputField = newField;
    
    [dialog addSubview:newField];
    [dialog show];
    

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"in textFieldShouldReturn");
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    inputName = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    inputName = textField.text;

}



/*
-(void) launchAlertBox: (id)setDelegate
{
    //self.isOpen = YES;
    dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:setDelegate];
    [dialog setTitle:@"Waiting for driver reply"];
    [dialog setMessage:@" "];
    [dialog addButtonWithTitle:@"Cancel"];
    
    
    inputField = [[UITextField alloc]initWithFrame:CGRectMake(20.0, 45.0, 245.0, 35.0)];
    
    
    
    timerView = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [timerView setBackgroundColor:[UIColor clearColor]];  
    [timerView setAlpha:1];
    [timerView setTextColor:[UIColor whiteColor]];
    [timerView setTextAlignment:UITextAlignmentCenter];
    [timerView setText:@"Connecting to server..."];
    
    [dialog addSubview:timerView];
    
    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
    [dialog setTransform: moveUp];
    [dialog show];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    
    [self createTimer];
}
 
 
*/
@end
