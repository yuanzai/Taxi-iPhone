//
//  SubmitForm.h
//  PaxApp
//
//  Created by Junyuan Lau on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CountDownBox;
@class JobStatusPoller;

@interface SubmitForm : NSObject<UIAlertViewDelegate>
{
    NSMutableDictionary* dictdata;
    CountDownBox* myBox;
    JobStatusPoller* myStatusReceiver;
    NSMutableDictionary* bookingForm;

}


- (id) initWithData;
- (void) fillGlobalVariablesIntoForm;
- (void) submitForm;
- (void)startCountdownWithJobID:(NSString*) job_id;
- (void)jobAccepted;
@end
