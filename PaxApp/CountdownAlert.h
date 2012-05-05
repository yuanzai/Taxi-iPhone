//
//  CountdownAlert.h
//  PaxApp
//
//  Created by Junyuan Lau on 30/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountdownAlert : NSObject
{
    NSTimer *countdownTimer;
    UIAlertView* dialog;
    UILabel* timerView;
    
    int timeCount;
}
@property (nonatomic,strong) NSTimer* countdownTimer;

-(void) launchAlertBox: (id)setDelegate;
- (void)createTimer; 
- (void) timerExpired;


@end
