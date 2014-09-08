//
//  HTTPQueryModel.h
//  hopcab
//
//  Created by Junyuan Lau on 27/08/2012.
//
//

#import <Foundation/Foundation.h>
typedef void (^handler) (NSURLResponse* response, NSData* data, NSError *error);

typedef void (^failHandler) (void);


@interface HTTPQueryModel : NSURLConnection <NSURLConnectionDelegate>
{
    NSURLConnection* myConnection;
    handler requestSuccess;
    failHandler requestFail;
    NSMutableURLRequest* myRequest;
    NSData* receivedData;
    NSURLResponse* receivedResponse;
    NSError *receivedError;
    NSTimer *timer;
}

-(NSURLRequest*)getRequestWithMethod:(NSString*)method;

-(id) initURLConnectionWithMethod:(NSString*) method Data:(NSDictionary*) data completionHandler:(void (^) (NSURLResponse* response, NSData* data, NSError *error))handler failHandler:(void (^) (void))failHandler;
@end
