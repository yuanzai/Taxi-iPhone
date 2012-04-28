//
//  PostMethodAsync.h
//  PaxApp
//
//  Created by Junyuan Lau on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostMethodAsync : NSObject

- (void) sendAsyncPostMethod_PostBody:(NSString*)postBody postURL:(NSURL*)postURL setDelegate:(id<NSURLConnectionDelegate>)setDelegate;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;


@end
