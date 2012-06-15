//
//  JobDispatchQuery.h
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface JobDispatchQuery : NSObject
+(void) submitJobWithPickupLocation:(NSString*)location Destination:(NSString*) destination TaxiType:(NSString*)taxitype fare:(NSString*)fare mobile:(NSString*)mobile_number completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

@end
