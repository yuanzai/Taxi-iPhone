//
//  Constants.h
//  PaxApp
//
//  Created by Junyuan Lau on 30/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject


////URLs used to access web services ////

//Host URL
FOUNDATION_EXPORT NSString *const kHostSite;

//Host URL
FOUNDATION_EXPORT NSString *const kHerokuHostSite;

//Download Driver Details URL Extension
FOUNDATION_EXPORT NSString *const kGetDriverPosition;

//Download Selected Driver Details URL Extension
FOUNDATION_EXPORT NSString *const kGetSpecifiedDriverPosition;

//Submit Job URL Extension
FOUNDATION_EXPORT NSString *const kSubmitJob;

//Retreive Job Details URL Extension
FOUNDATION_EXPORT NSString *const kCheckJob;

//Retreive Driver Info URL Extension
FOUNDATION_EXPORT NSString *const kGetDriverInfo;

//Pax updates status to onboard
FOUNDATION_EXPORT NSString *const kOnboardJobCalledByPassenger;

//Pax cancels job
FOUNDATION_EXPORT NSString *const kCancelJobCalledByPassenger;

//Job expired
FOUNDATION_EXPORT NSString *const kJobExpired;

//Job completed as indicated by pax
FOUNDATION_EXPORT NSString *const kCompleteJob;

//Get ETA of nearest driver
FOUNDATION_EXPORT NSString *const kGetNearestTime;

//Get ETA of specific driver
FOUNDATION_EXPORT NSString *const kGetETA;

//Calculate fare of trip
FOUNDATION_EXPORT NSString *const kGetFare;


@end
