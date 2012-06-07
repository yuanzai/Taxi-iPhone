//
//  Constants.m
//  PaxApp
//
//  Created by Junyuan Lau on 30/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

@implementation Constants


NSString *const kHostSite = @"http://localhost/taxi/";
NSString *const kHerokuHostSite = @"http://hopcabtest.herokuapp.com/";



NSString *const kGetDriverPosition = @"drivers.php";
NSString *const kSubmitJob = @"postjob.php";
NSString *const kCheckJob = @"job.php";
NSString *const kGetDriverInfo = @"drivers.php";
NSString *const kOnboardJobCalledByPassenger = @"jobquery.php";
NSString *const kCancelJobCalledByPassenger = @"jobquery.php";
NSString *const kJobExpired = @"jobquery.php";
NSString *const kCompleteJob = @"jobquery.php";
NSString *const kGetSpecifiedDriverPosition = @"drivers.php";
NSString *const kGetNearestTime = @"nearest.php";
NSString *const kGetETA = @"getduration.php";
NSString *const kGetFare = @"getfare.php";



@end
