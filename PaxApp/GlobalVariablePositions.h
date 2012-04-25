//
//  GlobalVariablePositions.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GlobalVariablePositions : NSObject{
    
    CLLocationCoordinate2D gUserCoordinate;
    NSString* pickupString;
    NSString* destinationString;
    
}

@property (nonatomic, strong) NSMutableArray* gDriverList;
@property CLLocationCoordinate2D gUserCoordinate;
@property (nonatomic,strong) NSString* pickupString;
@property (nonatomic,strong) NSString* destinationString;



+ (GlobalVariablePositions*)myGlobalVariablePositions;

@end