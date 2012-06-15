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
NSString *const kHerokuHostSite = @"http://hopcabapi.herokuapp.com/";
NSTimeInterval const kURLConnTimeOut = 10.0;







NSString *const kGetDriverPosition = @"drivers.php";
//http://hopcabtest.herokuapp.com/drivers/get_driver_positions.json - get


NSString *const kSubmitJob = @"postjob.php";
//http://hopcabtest.herokuapp.com/jobs/submit - post

NSString *const kCheckJob = @"job.php";
//http://hopcabtest.herokuapp.com/jobs/ + job_id - get

NSString *const kGetDriverInfo = @"drivers.php";
NSString *const kOnboardJobCalledByPassenger = @"jobquery.php";
NSString *const kCancelJobCalledByPassenger = @"jobquery.php";
NSString *const kJobExpired = @"jobquery.php";
//http://hopcabtest.herokuapp.com/jobs/ + job_id + /expire - post

NSString *const kCompleteJob = @"jobquery.php";
NSString *const kGetSpecifiedDriverPosition = @"drivers.php";
NSString *const kGetNearestTime = @"nearest.php";
NSString *const kGetETA = @"getduration.php";
NSString *const kGetFare = @"getfare.php";



@end
