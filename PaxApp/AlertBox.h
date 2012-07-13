//
//  AlertBox.h
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertBox : NSObject <UIAlertViewDelegate>
{
    UIAlertView* dialog;
    
    UITextField *nameField;
    UILabel *timerView;
    int timeCount;
    
    NSTimer *countdownTimer;
    BOOL isOpen;
    
}

@property (nonatomic,strong) NSTimer *countdownTimer;
@property BOOL isOpen;

-(void) launchAlertBox: (id)setDelegate;
- (void) createTimer:(int)countDownTime;
- (void) timerExpired;
- (void) stopTimer;
- (void) hideAlertBox;

@end
