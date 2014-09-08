

#import <Foundation/Foundation.h>

@protocol LoginModelDelegate <NSObject>
@optional
- (void) loginStatus: (NSString*)status withError:(NSString*)error;
@end

@class HTTPQueryModel;
@class ActivityProgressView;
@interface LoginModel : NSObject <UIAlertViewDelegate>
{
    NSUserDefaults* preferences;
    float version;
    UIAlertView* versionAlert;
    NSString* appURL;
    id<LoginModelDelegate> delegate;
    int age;
    HTTPQueryModel *loginQuery;
    ActivityProgressView* activityContainer;
}
@property (retain) id<LoginModelDelegate> delegate;

- (void) loginWithPreferences;
- (void) loginWithEmail:(NSString*) email password:(NSString*) password;
- (void) gotoMain;
- (void) gotoLogin:(NSString*) errors;
- (void) gotoSubmitJob;
- (void) gotoOnroute;
- (void) openAlertBoxAboveMinVersion:(NSString*) minimum;
- (void) setCurrentFormUsingData:(NSData*) data;


@end
