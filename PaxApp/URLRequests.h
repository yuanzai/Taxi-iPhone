//
//  URLConstants.h
//  hopcab
//
//  Created by Junyuan Lau on 02/09/2012.
//
//

#import <Foundation/Foundation.h>

@interface URLRequests : NSMutableURLRequest
-(NSMutableURLRequest*) initWithMethod:(NSString*) method data:(NSDictionary*) data;

@end
