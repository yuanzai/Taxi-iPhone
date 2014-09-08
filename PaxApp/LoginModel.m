
#import "LoginModel.h"
#import "GlobalVariables.h"
#import "OtherQuery.h"
#import "JobCycleQuery.h"
#import "Constants.h"
#import "HTTPQueryModel.h"
#import "ActivityProgressView.h"
@implementation LoginModel
/*
 1) Check if new user. New user has no existing Email/Password saved.
    if new user, goto login screen
 2) Check if existing user's saved login information matches
    if not, goto login screen
 3) Check if there is a last job stored
 
 
 3) Check if existing user last job is still active.
    if not, goto mainscreen
 4) Check if active job is open, accepted, arrived, reached or onboard
    if open, goto submitjob
    if accepted, reached, arrived or onboard, goto Onroute
 */


- (id) init{    
    if (self = [super init])
    {       
        version =[[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]floatValue];
        
        NSLog(@"App Version - %f",version);
        preferences = [NSUserDefaults standardUserDefaults];
    } return self;
}

- (void) loginWithPreferences
{
    if([preferences objectForKey:@"ClientEmail"] && [preferences objectForKey:@"ClientPassword"]) {
        [self loginWithEmail:[preferences objectForKey:@"ClientEmail"] password:[preferences objectForKey:@"ClientPassword"]];
        
    } else {
        [self gotoLogin:nil];
    }
}

- (void) loginWithEmail:(NSString*) email password:(NSString*) password 
{    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    if (![[GlobalVariables myGlobalVariables]gDeviceToken])
        [[GlobalVariables myGlobalVariables]setGDeviceToken:@""];
    
    NSMutableDictionary* loginData = [[NSMutableDictionary alloc]init];
    NSMutableDictionary* postData = [[NSMutableDictionary alloc]init];
    [loginData setObject:email forKey:@"email"];
    [loginData setObject:password forKey:@"password"];
    [loginData setObject:[[GlobalVariables myGlobalVariables]gDeviceToken] forKey:@"device_token"];
    [loginData setObject:@"ios" forKey:@"platform"];
    [postData setObject:loginData forKey:@"passenger"];
    
    loginQuery = [[HTTPQueryModel alloc] initURLConnectionWithMethod:@"postLogin" Data:postData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
        
        if (error)
            NSLog(@"%@",error.description);
        
        NSDictionary* dict;
        NSDictionary* jobdict;
        NSDictionary* maindict;
        NSDictionary* userdict;
        NSDictionary* versionDict;
        
        int success;
        
        if (data){
            maindict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            dict = [maindict objectForKey:@"user"];
            
            jobdict = [maindict objectForKey:@"last_job"];
            userdict = [maindict objectForKey:@"user"];
            
            success = [[maindict objectForKey:@"success"]intValue];
            versionDict = [[maindict objectForKey:@"version"] objectForKey:@"ios"];
            
            NSLog(@"%@",[maindict objectForKey:@"last_job"]);
            NSLog(@"%@ - %@ - Data from server - %@",self.class,NSStringFromSelector(_cmd),maindict);
            
            
            if (success && [httpResponse statusCode] == 200 && success == 1) {
                // Success
                appURL = [versionDict objectForKey:@"link"];
                if ([[versionDict objectForKey:@"min"]floatValue] <= version && [[versionDict objectForKey:@"latest"]floatValue] > version) {
                    [self performSelectorOnMainThread:@selector(openAlertBoxAboveMinVersion:) withObject:@"option" waitUntilDone:YES];
                } else if ([[versionDict objectForKey:@"min"]floatValue] > version) {
                    [self performSelectorOnMainThread:@selector(openAlertBoxAboveMinVersion:) withObject:@"forced"  waitUntilDone:YES];
                    return;
                }
                
                [preferences setObject:[maindict valueForKey:@"auth_token"] forKey:@"ClientAuth"];
                [preferences setObject:[userdict objectForKey:@"name"] forKey:@"ClientName"];
                [preferences setObject:[userdict objectForKey:@"mobile_number"]  forKey:@"ClientNumber"];
                [preferences setObject:email forKey:@"ClientEmail"];
                [preferences setObject:password forKey:@"ClientPassword"];
                
                
                if([maindict objectForKey:@"last_job"] == (id)[NSNull null]) {
                    [self setLoginStatus:@"gotoMain" withError:nil];
                    return;
                }
                
                NSString* job_id = [jobdict objectForKey:@"id"];
                NSString* jobstatus = [jobdict objectForKey:@"job_status"];
                
                if ([jobdict objectForKey:@"seconds_passed"]!= (id)[NSNull null]){
                    age = [[jobdict objectForKey:@"seconds_passed"]intValue];
                } else {
                    age = 0;
                }
                
                NSLog(@"%@ - %@ - Login with Job Status - %@",self.class,NSStringFromSelector(_cmd),jobstatus);
                NSMutableDictionary* formData = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[jobdict objectForKey:@"id"],@"job_id", nil];
                HTTPQueryModel* subQuery;
                if ([jobstatus isEqualToString:@"open"] && (age < kCountDownTime)){
                    subQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"getCheckJob" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        if (data){
                            [self setCurrentFormUsingData:data];
                            [self gotoSubmitJob];
                        } else {
                            [[GlobalVariables myGlobalVariables]setGGoto:@"gotoSubmitJob"];
                            [self setLoginStatus:@"gotoMain" withError:nil];
                        }
                    } failHandler:^{
                        [[GlobalVariables myGlobalVariables]setGGoto:@"gotoSubmitJob"];
                        [self setLoginStatus:@"gotoMain" withError:nil];
                    }];

                    
                } else if (([jobstatus isEqualToString:@"accepted"] || [jobstatus isEqualToString:@"onboard"] || [jobstatus isEqualToString:@"arrived"]) && (age < kActiveJobAgeLimit)) {
                                    
                        subQuery = [[HTTPQueryModel alloc]initURLConnectionWithMethod:@"getCheckJob" Data:formData completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                            if (data){
                                [self setCurrentFormUsingData:data];
                                [[GlobalVariables myGlobalVariables]setGGoto:@"gotoOnroute"];
                                [self setLoginStatus:@"gotoMain" withError:nil];
                                
                            } else {
                                [self setLoginStatus:@"gotoMain" withError:nil];
                            }
                        } failHandler:^{
                            [self setLoginStatus:@"gotoMain" withError:nil];

                        }];
                    
                } else {
                    [self setLoginStatus:@"gotoMain" withError:nil];
                }
                
            } else if (success != 1) {
                // Wrong
                NSString* errors = [maindict objectForKey:@"errors"];
                [self setLoginStatus:@"gotoLogin" withError:errors];
            } else{
                // Failed
                [self setLoginStatus:@"gotoLogin" withError:@"Cannot connect to server"];
                
            }
        } else {
            //Fail at data
        }

    } failHandler:^{
        [self setLoginStatus:@"gotoLogin" withError:@"Cannot connect to server"];

    }];
      
    /*
    [OtherQuery logInWithEmail:email password:password deviceID:[[GlobalVariables myGlobalVariables]gDeviceToken] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
        
        if (error)
            NSLog(@"%@",error.description);
        
        NSDictionary* dict;
        NSDictionary* jobdict;
        NSDictionary* maindict;
        NSDictionary* userdict;
        NSDictionary* versionDict;
        
        int success;
        
        if (data){
            maindict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            dict = [maindict objectForKey:@"user"];
            
            jobdict = [maindict objectForKey:@"last_job"];
            userdict = [maindict objectForKey:@"user"];
            
            success = [[maindict objectForKey:@"success"]intValue];
            versionDict = [[maindict objectForKey:@"version"] objectForKey:@"ios"];
            
            NSLog(@"%@",[maindict objectForKey:@"last_job"]);
            NSLog(@"%@ - %@ - Data from server - %@",self.class,NSStringFromSelector(_cmd),maindict);            
            
            
            if (success && [httpResponse statusCode] == 200 && success == 1) {
                // Success
                appURL = [versionDict objectForKey:@"link"];
                if ([[versionDict objectForKey:@"min"]floatValue] <= version && [[versionDict objectForKey:@"latest"]floatValue] > version) {
                    [self performSelectorOnMainThread:@selector(openAlertBoxAboveMinVersion:) withObject:@"option" waitUntilDone:YES];
                } else if ([[versionDict objectForKey:@"min"]floatValue] > version) {
                    [self performSelectorOnMainThread:@selector(openAlertBoxAboveMinVersion:) withObject:@"forced"  waitUntilDone:YES];
                    return;
                }
                
                [preferences setObject:[maindict valueForKey:@"auth_token"] forKey:@"ClientAuth"];
                [preferences setObject:[userdict objectForKey:@"name"] forKey:@"ClientName"];
                [preferences setObject:[userdict objectForKey:@"mobile_number"]  forKey:@"ClientNumber"];
 
                if([maindict objectForKey:@"last_job"] == (id)[NSNull null]) {
                    [self setLoginStatus:@"gotoMain" withError:nil];
                    return;
                }
                
                NSString* job_id = [jobdict objectForKey:@"id"];
                NSString* jobstatus = [jobdict objectForKey:@"job_status"];
                
                if ([jobdict objectForKey:@"seconds_passed"]!= (id)[NSNull null]){
                    age = [[jobdict objectForKey:@"seconds_passed"]intValue];
                } else {
                    age = 0;
                }
                
                NSLog(@"%@ - %@ - Login with Job Status - %@",self.class,NSStringFromSelector(_cmd),jobstatus);
                
                if ([jobstatus isEqualToString:@"open"] && (age < kCountDownTime)){
                    
                    NSData* data = [JobCycleQuery checkJobSynchronouslyWithJobID:job_id];
                    if (data){
                        [self setCurrentFormUsingData:data];
                        [self gotoSubmitJob];
                    } else {
                        [[GlobalVariables myGlobalVariables]setGGoto:@"gotoSubmitJob"];
                        [self setLoginStatus:@"gotoMain" withError:nil];
                    }
                    
                } else if (([jobstatus isEqualToString:@"accepted"] || [jobstatus isEqualToString:@"onboard"] || [jobstatus isEqualToString:@"arrived"]) && (age < kActiveJobAgeLimit)) {
                    
                    NSData* data = [JobCycleQuery checkJobSynchronouslyWithJobID:job_id];
                    if (data){
                        [self setCurrentFormUsingData:data];
                        [[GlobalVariables myGlobalVariables]setGGoto:@"gotoOnroute"];
                        [self setLoginStatus:@"gotoMain" withError:nil];
                        
                    } else {
                        [self setLoginStatus:@"gotoMain" withError:nil];
                    }
                    
                } else {
                    [self setLoginStatus:@"gotoMain" withError:nil];
                }
                
            } else if (success != 1) {
                // Wrong
                NSString* errors = [maindict objectForKey:@"errors"];
                [self setLoginStatus:@"gotoLogin" withError:errors];
            } else{
                // Failed
                [self setLoginStatus:@"gotoLogin" withError:@"Cannot connect to server"];

            }
        } else {
            //Fail at data
            [self setLoginStatus:@"gotoLogin" withError:@"Cannot connect to server"];
        }
    }];
     */
}



- (void) setCurrentFormUsingData:(NSData*) data
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]];
    [[GlobalVariables myGlobalVariables]setGCurrentForm:dict];
    NSDate* starttime = [NSDate dateWithTimeIntervalSinceNow:-age];    
    [[[GlobalVariables myGlobalVariables]gCurrentForm]setObject:starttime forKey:@"starttime"];
}

- (void) openAlertBoxAboveMinVersion:(NSString*) minimum
{
    if ([minimum isEqualToString:@"option"]){
    versionAlert = [[UIAlertView alloc]initWithTitle:@"New Version Available" message:@"Would you like to update HopCab?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [versionAlert show];
    } else {
        versionAlert = [[UIAlertView alloc]initWithTitle:@"HopCab outdated" message:@"Please download the latest version of HobCab!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [versionAlert show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
    } 
}

- (void)setLoginStatus:(NSString*) status withError:(NSString*) error
{
    NSLog(@"%@ - %@ status - %@",self.class,NSStringFromSelector(_cmd), status);
    [[self delegate] loginStatus:status withError:error];
}

@end
