//
//  MainMapNavBar.h
//  PaxApp
//
//  Created by Junyuan Lau on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomNavBar : UIView
{
    UILabel *titleView;
    UILabel *subtitleView;
    UIImageView *leftIcon;
}


- (id) initTwoRowBar;
- (id) initOneRowBar;
- (void) setCustomNavBarTitle:(NSString*)title subtitle:(NSString*) subtitle;
- (void) addRightLogo;


@end
