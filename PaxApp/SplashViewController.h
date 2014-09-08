//
//  SplashViewController.h
//  hopcab
//
//  Created by Junyuan Lau on 02/09/2012.
//
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

@class LoginModel;
@class ActivityProgressView;
@interface SplashViewController : UIViewController <LoginModelDelegate>
{
    LoginModel* myLogin;
    ActivityProgressView* activityContainer;
}
@end
