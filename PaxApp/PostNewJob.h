//
//  UserSubmitJob.h
//  PaxApp
//
//  Created by Junyuan Lau on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostNewJob : NSObject
- (NSString*) postNewJobwithdriverID:(NSString*)driver_id pickupAddress:(NSString*)pickup destinationAddress:(NSString *)destination;


@end
