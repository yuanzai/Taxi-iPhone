//
//  ActivityProgressView.m
//  PaxApp
//
//  Created by Junyuan Lau on 13/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityProgressView.h"

@implementation ActivityProgressView

- (id)initWithFrame:(CGRect)frame text:(NSString*) text
{
    self = [super initWithFrame:[[UIScreen mainScreen]bounds]];
    if (self) {
        
        
        
        innerView = [[UIView alloc]initWithFrame:frame];
        
        [innerView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.7]];
        [innerView setAlpha:0.0];
        [innerView setTag:123];
        [innerView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [innerView.layer setCornerRadius:10];
        [innerView.layer setShadowColor:[UIColor blackColor].CGColor];
        [innerView.layer setShadowOpacity:0.8];
        [innerView.layer setShadowRadius:6.0];
        [innerView.layer setShadowOffset:CGSizeMake(4.0, 4.0)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentCenter];
        label.text = text;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        
        [label setCenter:CGPointMake(innerView.bounds.size.width / 2, innerView.bounds.size.height / 2 + 25)];
        
        [innerView addSubview:label];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView setCenter:CGPointMake(innerView.bounds.size.width / 2, innerView.bounds.size.height / 2 -10)];
        [innerView addSubview:activityView];
        [activityView startAnimating];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [innerView setAlpha:1.0];
        [UIView commitAnimations];
        
        [innerView setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
        [self addSubview:innerView];
        
        /*
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.7]];
        [self setAlpha:0.0];
        [self setTag:123];
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self.layer setCornerRadius:10];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:6.0];
        [self.layer setShadowOffset:CGSizeMake(4.0, 4.0)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:UITextAlignmentCenter];
        label.text = text;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        
        [label setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + 25)];
        
        [self addSubview:label];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView setCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 -10)];
        [self addSubview:activityView];
        [activityView startAnimating];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self setAlpha:1.0];
        [UIView commitAnimations];
        
        [self setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
         */
         }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
