//
//  RatingAlert.h
//  PaxApp
//
//  Created by Junyuan Lau on 25/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RatingAlert : NSObject <UIAlertViewDelegate>
{
    UIAlertView *mainBox;
    UIAlertView *negativeBox;
    UIAlertView *positiveBox;

}
-(void) launchMainBox: (id)setDelegate;
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)launchSubBox:(NSInteger)buttonIndex;

@end
