//
//  PostMethodAsync.m
//  PaxApp
//
//  Created by Junyuan Lau on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostMethodAsync.h"

@implementation PostMethodAsync

-(void) sendAsyncPostMethod_PostBody:(NSString*)postBody postURL:(NSURL*)postURL setDelegate:(id)setDelegate
{
    NSData *postData = [postBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];     // postData format - @"key=value&key2=value2"
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:postURL];    // Create NSURL in this format - [NSURL URLWithString:@"http://localhost/taxi/test.php"]
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:10];
    [request setHTTPBody:postData];
    
    //NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];    
    
    //Set delegate below
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:setDelegate];
    
    NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));

    if(connection) {
        NSLog(@"%@ - %@ - Connected",self.class,NSStringFromSelector(_cmd));

    } else {
        NSLog(@"%@ - %@ - Not Connected",self.class,NSStringFromSelector(_cmd));
    
    }
    // write NSData to String - NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
}


/*
 
 // Methods required for NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
        NSLog(@"%@ - %@",self.class,NSStringFromSelector(_cmd));
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    NSLog(@"%@ - %@ - Data %@",self.class,NSStringFromSelector(_cmd), data);
}
*/

@end
