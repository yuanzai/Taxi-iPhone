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

+ (void) getFareWithDictionary:(NSDictionary*)dictdata completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+ (void) getNearestTimeWithlocation:(CLLocationCoordinate2D)location completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+ (void) logInWithEmail:(NSString*)email password:(NSString*)password deviceID:(NSString*)deviceID completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+ (void) registerWithEmail:(NSString*)email password:(NSString*)password name:(NSString*)name mobile:(NSString*) mobile completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+ (void) getMyTripscompletionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+ (void) reviewJobID:(NSString*)job_id review:(int)review feedback:(NSString*) feedback completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+ (void) updateProfileWithEmail:(NSString*)email password:(NSString*)password name:(NSString*)name mobile:(NSString*) mobile_number completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;

+ (void) getVersioncompletionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler;
@end
