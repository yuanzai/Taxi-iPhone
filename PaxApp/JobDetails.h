//
//  JobDetails.h
//  PaxApp
//
//  Created by Junyuan Lau on 14/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface JobDetails : NSObject
@property (strong, nonatomic) id<MKAnnotation> pickupAnnotation;
@property (strong, nonatomic) id<MKAnnotation> destiAnnotation;

@property (strong, nonatomic) NSString* pickupAddress;
@property (strong, nonatomic) NSString* pickupPoint;
@property (strong, nonatomic) NSString* destiAddress;

@property (strong, nonatomic) NSString* paxName;
@property (strong, nonatomic) NSString* paxNumber;
@property (strong, nonatomic) NSString* driver_id;



@end
