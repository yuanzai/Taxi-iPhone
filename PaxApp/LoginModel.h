//
//  LoginModel.h
//  PaxApp
//
//  Created by Junyuan Lau on 07/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
{
    NSUserDefaults* preferences;
}
- (void) loginWithPreferences;
- (void) loginWithEmail:(NSString*) email password:(NSString*) password;
- (void) gotoMain;
- (void) gotoLogin:(NSString*) errors;
- (void) gotoSubmitJob;
- (void) gotoOnroute;

@end
