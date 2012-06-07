//
//  ScheduledTimer.m
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledTimer.h"

@implementation ScheduledTimer
@synthesize repeatingTimer;


-(id)initStartTimerWithTarget:(id)setTarget selector:(SEL) setSelector interval:(NSTimeInterval) interval
{
    NSLog(@"%@ - %@ - %@",self.class,NSStringFromSelector(_cmd),setTarget);
    if (self = [super init])
    {
        [setTarget performSelector:setSelector];

        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval 
                                                          target:setTarget selector:setSelector
                                                        userInfo:nil repeats:YES];
        self.repeatingTimer = timer;
    }
    return self;
}

- (void)stopTimer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

@end
