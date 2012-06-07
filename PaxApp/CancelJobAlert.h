//
//  CancelJobAlert.h
//  PaxApp
//
//  Created by Junyuan Lau on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancelJobAlert : NSObject
{
    UIAlertView *confirmBox;
    UIAlertView *noshowBox;
    UITextField *textInput;
}

-(void) launchConfirmBox;
-(void) launchNoShowBox;
@end
