//
//  URLConstants.m
//  hopcab
//
//  Created by Junyuan Lau on 02/09/2012.
//
//

#import "URLRequests.h"
#import "Constants.h"

@implementation URLRequests
-(NSMutableURLRequest*) initWithMethod:(NSString*) method data:(NSDictionary*) data
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    NSUserDefaults* preferences = [NSUserDefaults standardUserDefaults];

    if (self = [super init])
    {
        
        if ([method isEqualToString:@"getVersion"]) {
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@version",kHerokuHostSite]]];
            [self setHTTPMethod:@"GET"];
            [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [self setTimeoutInterval:kURLConnTimeOut];

        } else if ([method isEqualToString:@"postLogin"]){
            NSData* postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];            
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@login",kHerokuHostSite]]];
            [self setHTTPMethod:@"POST"];
            [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self setTimeoutInterval:kURLConnTimeOut];
            [self setHTTPBody:postData];

        } else if ([method isEqualToString:@"postRegister"]){
            NSData* postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@register",kHerokuHostSite]]];
            [self setHTTPMethod:@"POST"];
            [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self setTimeoutInterval:kURLConnTimeOut];
            [self setHTTPBody:postData];
            
        } else if([method isEqualToString:@"getFare"]){
            NSData* postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/fare?auth_token=%@",kHerokuHostSite,[preferences objectForKey:@"ClientAuth"]]]];
            [self setHTTPMethod:@"POST"];
            [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self setTimeoutInterval:kURLConnTimeOut];
            [self setHTTPBody:postData];
            
        } else if ([method isEqualToString:@"getMyTrips"]) {
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@profile/trips?auth_token=%@",kHerokuHostSite,[preferences objectForKey:@"ClientAuth"]]]];
            [self setHTTPMethod:@"GET"];
            [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [self setTimeoutInterval:kURLConnTimeOut];
            
        } else if ([method isEqualToString:@"postReview"]){
            NSString* postBody = [[NSString alloc] initWithFormat:@"review=%i&feedback=%@",[[data objectForKey:@"review"]integerValue], [data objectForKey:@"feedback"]];
            NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     // postData format - @"key=value&key2=value2"
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@/review?auth_token=%@", kHerokuHostSite,[data objectForKey:@"job_id"], [preferences objectForKey:@"ClientAuth"]]]];
            [self setHTTPMethod:@"POST"];
            [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [self setTimeoutInterval:kURLConnTimeOut];
            [self setHTTPBody:postData];
            
        } else if ([method isEqualToString:@"postUpdateProfile"]) {
            NSData* postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@profile?auth_token=%@",kHerokuHostSite,[preferences objectForKey:@"ClientAuth"]]]];
            [self setHTTPMethod:@"POST"];
            [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self setTimeoutInterval:kURLConnTimeOut];
            [self setHTTPBody:postData];
            
        } else if ([method isEqualToString:@"postCancelJob"]) {
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@/cancel?auth_token=%@",kHerokuHostSite, [data objectForKey:@"job_id"], [preferences objectForKey:@"ClientAuth"]]]];
            [self setHTTPMethod:@"POST"];
            [self setTimeoutInterval:kURLConnTimeOut];
            
        } else if([method isEqualToString:@"getCheckJob"]){
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@?auth_token=%@", kHerokuHostSite, [data objectForKey:@"job_id"],[preferences objectForKey:@"ClientAuth"]]]];
            [self setHTTPMethod:@"GET"];
            [self setTimeoutInterval:kURLConnTimeOut];
            
        } else if ([method isEqualToString:@"postAdvancedJob"]) {
            NSData* postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@advanced_jobs?auth_token=%@",kHerokuHostSite,[preferences objectForKey:@"ClientAuth"]]]];            
            [self setHTTPMethod:@"POST"];
            [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self setTimeoutInterval:kURLConnTimeOut];
            [self setHTTPBody:postData];
            
        } else if ([method isEqualToString:@"postJob"]) {
            NSData* postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs?auth_token=%@",kHerokuHostSite,[preferences objectForKey:@"ClientAuth"]]]];
            [self setHTTPMethod:@"POST"];
            [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self setTimeoutInterval:kURLConnTimeOut];
            [self setHTTPBody:postData];
            
        } else if ([method isEqualToString:@"getAllDrivers"]) {
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@drivers?auth_token=%@",kHerokuHostSite,[preferences objectForKey:@"ClientAuth"]]]];
            [self setHTTPMethod:@"GET"];
            [self setTimeoutInterval:kURLConnTimeOut];
            
        } else if ([method isEqualToString:@"getDriver"]) {
            [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@jobs/%@/driver_position?auth_token=%@",kHerokuHostSite,[data objectForKey:@"job_id"],[preferences objectForKey:@"ClientAuth"]]]];
            [self setHTTPMethod:@"GET"];
            [self setTimeoutInterval:kURLConnTimeOut];
        }
        
        
        
    }  return self;
}
@end
