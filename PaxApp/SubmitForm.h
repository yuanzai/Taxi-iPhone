
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class CountDownBox;
@class JobStatusPoller;
#import "JobStatusPoller.h"

@protocol SubmitFormDelegate <NSObject>
@optional
- (void) shouldGoToOnRoute: (BOOL)status;
@end

@interface SubmitForm : NSObject<UIAlertViewDelegate, JobStatusDelegate>
{
    NSMutableDictionary* dictdata;
    CountDownBox* myBox;
    JobStatusPoller* myStatusReceiver;
    NSMutableDictionary* bookingForm;
    
    id <SubmitFormDelegate> delegate;

    SystemSoundID mySound;
}
@property (retain) id<SubmitFormDelegate> delegate;


- (id) initWithData;
- (void) fillGlobalVariablesIntoForm;
- (void) submitForm;
- (void)startCountdownWithJobID:(NSString*) job_id;
- (void) sendJobAcceptedNotification;
- (SystemSoundID) createSoundID: (NSString*)name;

- (void) playSound;

@end
