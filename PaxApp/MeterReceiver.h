//
//  MeterReceiver.h
//  PaxApp
//
//  Created by Junyuan Lau on 30/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PostMethodAsync;
@interface MeterReceiver : NSObject <NSURLConnectionDataDelegate>
{
    IBOutlet UIView *meterBar;
    IBOutlet UILabel *fareLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *distanceLabel;
    
    NSTimer *repeatingTimer;
    NSString* job_id;
    
    PostMethodAsync *myPMA;
}
@property (nonatomic,strong) NSTimer *repeatingTimer;
@property (nonatomic,strong) IBOutlet UIView *meterBar;
@property (nonatomic,strong) IBOutlet UILabel *fareLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UILabel *distanceLabel;




-(void) setJob_ID:(NSString*)job_id_input;
-(void)startMeterReceiverTimer;


@end
