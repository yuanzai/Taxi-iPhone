//
//  MeterReceiver.m
//  PaxApp
//
//  Created by Junyuan Lau on 30/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeterReceiver.h"
#import "PostMethodAsync.h"
#import "JobQuery.h"

@implementation MeterReceiver
@synthesize repeatingTimer, meterBar, fareLabel, distanceLabel, timeLabel;

-(void) setJob_ID:(NSString*)job_id_input
{
    job_id = job_id_input;
}

-(void)getMeter:(NSTimer*) timer
{
    myPMA = [[PostMethodAsync alloc]init];
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"job_id=%@",job_id];
    
    [myPMA sendAsyncPostMethod_PostBody:postBody postURL:[NSURL URLWithString:@"http://localhost/taxi/getmeter.php"] setDelegate:self];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
}


-(void)startMeterReceiverTimer
{
    JobQuery* newQuery = [[JobQuery alloc]init];
    [newQuery submitJobQuerywithMsgType:@"clientonboard" job_id:job_id rating:nil driver_id:nil];
    
    [self getMeter:nil]; //run get meter immediately before intrval countdown
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15 
                                                      target:self selector:@selector(getMeter:)
                                                    userInfo:nil repeats:YES];
    self.repeatingTimer = timer;
}

- (void)stopMeterReceiverTimer
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    [repeatingTimer invalidate];
    self.repeatingTimer = nil;
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];    
    
    
    
    NSLog(@"%@ - %@ - Data %@",self.class,NSStringFromSelector(_cmd), array);

    
    fareLabel.text = [NSString stringWithFormat:@"Current Fare is S$%@.00",[array objectAtIndex:0]];

}

@end
