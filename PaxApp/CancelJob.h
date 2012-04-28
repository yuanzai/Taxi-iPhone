//
//  CancelJob.h
//  PaxApp
//
//  Created by Junyuan Lau on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancelJob : NSObject
{
    UIAlertView *confirmBox;
    UIAlertView *noshowBox;
}

-(void) launchConfirmBox;
-(void) launchNoShowBox;


@end
