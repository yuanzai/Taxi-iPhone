//
//  GlobalVariablePositions.h
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GlobalVariables : NSObject{
    NSMutableDictionary* gDriverList;
    CLLocationCoordinate2D gUserCoordinate;
    CLLocationCoordinate2D gDestiCoordinate;
    
    NSString* gPickupString;
    NSString* gDestinationString;
    
    NSString* gDriver_id;
    NSString* gJob_id;
    NSString* gUserAddress;
    
    NSDictionary* gDriverInfo;


}

@property (nonatomic, strong) NSMutableDictionary* gDriverList;
@property CLLocationCoordinate2D gUserCoordinate;
@property CLLocationCoordinate2D gDestiCoordinate;
@property (nonatomic,strong) NSString* gPickupString;
@property (nonatomic,strong) NSString* gDestinationString;
@property (nonatomic,strong) NSString* gDriver_id;
@property (nonatomic,strong) NSString* gJob_id;
@property (nonatomic,strong) NSString* gUserAddress;

@property (nonatomic,strong) NSDictionary* gDriverInfo;




+ (GlobalVariables*)myGlobalVariables;
- (void) clearGlobalData;

@end