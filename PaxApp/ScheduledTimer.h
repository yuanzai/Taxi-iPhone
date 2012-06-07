//
//  ScheduledTimer.h
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduledTimer : NSObject

@property (nonatomic, strong) NSTimer* repeatingTimer;
- (id)initStartTimerWithTarget:(id)setTarget selector:(SEL) setSelector interval:(NSTimeInterval) interval;
- (void)stopTimer;


@end
