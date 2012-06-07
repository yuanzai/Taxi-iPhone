#import "Job.h"
#import "PostMethod.h"
#import "Constants.h"
#import "ScheduledTimer.h"

@implementation Job
@synthesize jobItem;
/*
 if (!newJob)
 newJob = [[Job alloc] init];
 
 [newJob getJobInfo_useJobID:job_id];
 
 [newJob.jobItem objectForKey:@"accepted"] == @"1";
 */


// Returns job from job table
// defines class property jobItem with a NSMutableArray of the fields
- (void) getJobInfo_useJobID:(NSString*)job_id 
{
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"job_id=%@",job_id];
    
    PostMethod *postMethod = [[PostMethod alloc]init];
    
    NSData* responseData = [postMethod getDataFromURLPostMethod:postBody :[NSURL URLWithString:@"http://localhost/taxi/job.php"]];
    
    //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]; 
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];    
    
    jobItem = [array objectAtIndex:0];
    
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    NSLog(@"%@ - responseString: %@",self.class, jobItem);
}

// Returns the jobItem
-(NSDictionary*) jobItem
{
    return jobItem;
}

+(void) getJobInfoAsync_withJobID:(NSString*)job_id completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler
{
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];

    //Set URL for post request. Constants from constants file
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kHostSite, kCheckJob]]];    
    
    NSString* postBody = [[NSString alloc] initWithFormat:@"job_id=%@",job_id];
    
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     // postData format - @"key=value&key2=value2"
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:10];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request 
                                       queue:[[NSOperationQueue alloc] init] 
                           completionHandler:handler];
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

}


@end
