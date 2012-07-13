//
//  MainMapNavBar.m
//  PaxApp
//
//  Created by Junyuan Lau on 01/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomNavBar.h"

@implementation CustomNavBar




- (id) initTwoRowBar
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 44)])
    { 
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
         
        //init left icon
        leftIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"taxi_icon_left"]];
        leftIcon.contentMode = UIViewContentModeScaleAspectFit;
        leftIcon.frame = CGRectMake(4, 0, 28, 44);
        [self addSubview:leftIcon];
        
        //init top title
        CGRect titleFrame = CGRectMake(37, 2, 200, 22);  
        titleView = [[UILabel alloc] initWithFrame:titleFrame];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont systemFontOfSize:16];
        titleView.textAlignment = UITextAlignmentLeft;
        titleView.textColor = [UIColor whiteColor];
        titleView.shadowColor = [UIColor darkGrayColor];
        titleView.shadowOffset = CGSizeMake(0, -1);
        titleView.text = @"";
        titleView.adjustsFontSizeToFitWidth = YES;
        [self addSubview:titleView];
        
        //init bottom title aka subtitle
        CGRect subtitleFrame = CGRectMake(37, 20, 200, 44-22);   
        subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
        subtitleView.backgroundColor = [UIColor clearColor];
        subtitleView.font = [UIFont systemFontOfSize:12];
        subtitleView.textAlignment = UITextAlignmentLeft;
        subtitleView.textColor = [UIColor whiteColor];
        subtitleView.shadowColor = [UIColor darkGrayColor];
        subtitleView.shadowOffset = CGSizeMake(0, -1);
        subtitleView.text = @"";
        subtitleView.adjustsFontSizeToFitWidth = YES;
        [self addSubview:subtitleView];
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                                     UIViewAutoresizingFlexibleRightMargin |
                                                     UIViewAutoresizingFlexibleTopMargin |
                                                     UIViewAutoresizingFlexibleBottomMargin);
        
        
        
        
    } return self;
}

- (id) initOneRowBar
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 44)])
    { 
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        
        
        leftIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"taxi_icon_left"]];
        leftIcon.contentMode = UIViewContentModeScaleAspectFit;
        leftIcon.frame = CGRectMake(4, 0, 28, 44);        
        [self addSubview:leftIcon];
        
        
        
        CGRect titleFrame = CGRectMake(37, 0, 200, 44);  
        titleView = [[UILabel alloc] initWithFrame:titleFrame];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont systemFontOfSize:16];
        titleView.textAlignment = UITextAlignmentLeft;
        titleView.textColor = [UIColor whiteColor];
        titleView.shadowColor = [UIColor darkGrayColor];
        titleView.shadowOffset = CGSizeMake(0, -1);
        titleView.text = @"top";
        titleView.adjustsFontSizeToFitWidth = YES;
        [self addSubview:titleView];
        
        
        self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin |
                                 UIViewAutoresizingFlexibleTopMargin |
                                 UIViewAutoresizingFlexibleBottomMargin);
        
        
        
        
    } return self;    
}

- (void) setCustomNavBarTitle:(NSString*)title subtitle:(NSString*) subtitle
{

    self->titleView.text = title;
    
    if (subtitleView)
    self->subtitleView.text = subtitle;
    
}

-(void) addRightLogo
{
    leftIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hopcab_icon_right"]];
    leftIcon.contentMode = UIViewContentModeScaleAspectFit;

    leftIcon.frame = CGRectMake(self.frame.size.width - 90, 0, 74, 44);        
    [self addSubview:leftIcon];
}


@end
