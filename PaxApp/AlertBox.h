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
   
}

@property (nonatomic,strong) NSTimer *countdownTimer;


-(void) launchAlertBox: (id)setDelegate;
- (void) createTimer;
- (void) timerExpired;
- (void) stopTimer;

@end
