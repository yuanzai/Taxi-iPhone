//
//  GetETA.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class PostMethodAsync;

@interface GetETA : NSObject <NSURLConnectionDataDelegate>
{
    NSString* eta;
    PostMethodAsync* postMethodAsync;
}
-(void)startETAThread:(id <MKAnnotation>)anno;
-(NSString *)eta;


@end
