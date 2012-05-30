//
//  DriverAsync.h
//  PaxApp
//
//  Created by Junyuan Lau on 06/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverAsync : NSObject <NSURLConnectionDataDelegate>
{
    NSMutableDictionary *newKey;
    NSMutableDictionary *oldKey;
}
-(void) getDriverInfo_useDriverID:(NSString*) driver_id;

@end
