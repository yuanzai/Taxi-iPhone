//
//  JobView.m
//  PaxApp
//
//  Created by Junyuan Lau on 29/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JobView.h"

@implementation JobView
@synthesize infoView;


- (void) hideInfoView
{
    [infoView setHidden:YES];
}

- (void) showInfoView
{
    [infoView setHidden:NO];
}


@end
