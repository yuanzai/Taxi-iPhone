//
//  AppDelegate.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    UIAlertView* versionAlert;
    NSString* appURL;
}
@property (strong, nonatomic) UIWindow *window;
- (void) openAlertBoxAboveMinVersion:(NSString*) minimum;

@end
