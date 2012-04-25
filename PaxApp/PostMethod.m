#import "PostMethod.h"

@implementation PostMethod


-(NSData *) getDataFromURLPostMethod:(NSString*)postBody:(NSURL*)postURL{
    
    
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     // postData format - @"key=value&key2=value2"
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:postURL];    // Create NSURL in this format - [NSURL URLWithString:@"http://localhost/taxi/test.php"]
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:10];
    [request setHTTPBody:postData];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
        
    //NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];

    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // write NSData to String - NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return responseData;
}

/*
-(void)connection :(NSURLConnection *) connection didReceiveData:(NSData *)data{

    NSString* postedURL = [[NSString alloc]initWithFormat:@"%@", connection.originalRequest.URL];
    //response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[NSNotificationCenter defaultCenter] postNotificationName:postedURL object: data ];
}
*/
@end