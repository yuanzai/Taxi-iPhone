//
//  HTTPQueryModel.m
//  hopcab
//
//  Created by Junyuan Lau on 27/08/2012.
//
//

#import "HTTPQueryModel.h"
#import "URLRequests.h"
#import "Constants.h"

@implementation HTTPQueryModel


-(id) initURLConnectionWithMethod:(NSString*) method Data:(NSDictionary*) data completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler failHandler:(void (^) (void))failHandler
{
    requestSuccess = handler;
    requestFail = failHandler;
    myRequest = [[URLRequests alloc]initWithMethod:method data:data];    
    if (self = [super initWithRequest:myRequest delegate:self])
    {
        
        timer = [NSTimer scheduledTimerWithTimeInterval:kURLConnTimeOut target:self selector:@selector(cancelConnection) userInfo:nil repeats:NO];
                 
    } return self;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    receivedError = error;
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    receivedData = data;
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receivedResponse = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [timer invalidate];
    requestSuccess(receivedResponse,receivedData,receivedError);
   
}

- (void) cancelConnection
{
    [myConnection cancel];
    [timer invalidate];
    requestFail();
    
}
@end
