//
//  OtherQuery.h
//  PaxApp
//
//  Created by Junyuan Lau on 31/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface OtherQuery : NSObject

+ (void) getFareWithlocation:(CLLocationCoordinate2D)location destination:(CLLocationCoordinate2D) destination taxitype:(NSString*)taxitype completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+ (void) getNearestTimeWithlocation:(CLLocationCoordinate2D)location completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+ (void) logInWithEmail:(NSString*)email password:(NSString*)password deviceID:(NSString*)deviceID completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;


+ (void) registerWithEmail:(NSString*)email password:(NSString*)password name:(NSString*)name mobile:(NSString*) mobile completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;
@end
