
#import "LoginModel.h"
#import "GlobalVariables.h"
#import "OtherQuery.h"
#import "JobCycleQuery.h"
#import "Constants.h"

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
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
    if (self = [super init])
    {        
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
    if (![[GlobalVariables myGlobalVariables]gDeviceToken])
        [[GlobalVariables myGlobalVariables]setGDeviceToken:@""];
    
    [OtherQuery logInWithEmail:email password:password deviceID:[[GlobalVariables myGlobalVariables]gDeviceToken] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"%@ - %@ - Response from server - %i",self.class,NSStringFromSelector(_cmd),[httpResponse statusCode]);
        
        if (error)
            NSLog(@"%@",error.description);
        
        NSDictionary* dict;
        NSDictionary* jobdict;
        NSDictionary* maindict;

        int success;
        
        if (data){
            maindict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            dict = [maindict objectForKey:@"user"];
            jobdict = [maindict objectForKey:@"last_job"];
            success = [[maindict objectForKey:@"success"]intValue];

            NSLog(@"%@ - %@ - Data from server - %@",self.class,NSStringFromSelector(_cmd),maindict);
        

        
        if (success && [httpResponse statusCode] == 200 && success == 1) {
            // Success
            [preferences setObject:[maindict valueForKey:@"auth_token"] forKey:@"ClientAuth"];
            
            NSString* job_id = [jobdict objectForKey:@"id"];
            NSString* jobstatus = [jobdict objectForKey:@"job_status"];
            int age = [[jobdict objectForKey:@"seconds_passed"]intValue];
            
            NSLog(@"%@ - %@ - Job Status - %@",self.class,NSStringFromSelector(_cmd),jobstatus);
            
            if ([jobstatus isEqualToString:@"open"] && (age < kCountDownTime)){
                
                NSData* data = [JobCycleQuery checkJobSynchronouslyWithJobID:job_id];
                if (data){
                    NSMutableDictionary* dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    [[GlobalVariables myGlobalVariables]setGCurrentForm:dict];
                    [self gotoSubmitJob];
                } else {
                    [self gotoMain]; 
                }
                
            } else if (([jobstatus isEqualToString:@"accepted"] || [jobstatus isEqualToString:@"accepted"] || [jobstatus isEqualToString:@"accepted"]) && (age < kActiveJobAgeLimit)) {
                
                NSData* data = [JobCycleQuery checkJobSynchronouslyWithJobID:job_id];
                if (data){
                    NSMutableDictionary* dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    [[GlobalVariables myGlobalVariables]setGCurrentForm:dict];
                    [self gotoOnroute];
                } else {
                    [self gotoMain];
                }
                
            } else {
                [self gotoMain];
            }
            
        } else if (success != 1) {
            // Wrong
            NSString* errors = [maindict objectForKey:@"errors"];
            [self gotoLogin:errors];
        } else{
            // Failed
            [self gotoLogin:@"Cannot connect to server"];
        }
        }
       
    }];
}

- (void) gotoMain
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoMain" object:nil];
}

- (void) gotoLogin:(NSString*) errors
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoLogin" object:nil userInfo:[[NSDictionary alloc]initWithObjectsAndKeys:errors, @"errors", nil]];
}

- (void) gotoSubmitJob
{
    [[GlobalVariables myGlobalVariables]setGGoto:@"gotoSubmitJob"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoMain" object:nil];

}

- (void) gotoOnroute
{
    [[GlobalVariables myGlobalVariables]setGGoto:@"gotoOnroute"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoMain" object:nil];

}
@end
