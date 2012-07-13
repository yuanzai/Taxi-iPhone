//
//  CountDownBox.h
//  PaxApp
//
//  Created by Junyuan Lau on 29/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountDownBox : UIAlertView
{
    NSTimer *countdownTimer;
    UILabel *timerView;
    int timeCount;
}
@property (nonatomic,strong) NSTimer *countdownTimer;
@property (nonatomic,strong) UILabel *timerView;

- (void) createTimer:(int)countDownTime;
- (void) timerExpired;
- (void) hideBox;
- (void) stopTimer;

@end
