#import <Foundation/Foundation.h>

@interface PostMethod : NSObject

-(NSData *) getDataFromURLPostMethod:(NSString*)postBody:(NSURL*)postURL;

@end
