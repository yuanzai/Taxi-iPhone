//
//  AdvancedBookingQuery.h
//  PaxApp
//
//  Created by Junyuan Lau on 25/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvancedBookingQuery : NSObject
+(void) submitJobWithDictionary:(NSDictionary*)dictdata completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

@end
