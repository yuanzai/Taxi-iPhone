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
    
    NSString* gUserAddress;
        
    NSString* gDeviceToken;
    BOOL gIsOnJob;
    
    NSMutableDictionary* gAdvancedForm;
    NSMutableDictionary* gCurrentForm;
    NSString* gGoto;
}

//goto view controller
@property (nonatomic,strong) NSString* gGoto;

//device token
@property (nonatomic,strong) NSString* gDeviceToken;

//driver list generated for map markers
@property (nonatomic, strong) NSMutableDictionary* gDriverList; 

//user location per corelocation
@property CLLocationCoordinate2D gUserCoordinate;

//reverse geocoded address of gUserCoordinate. determined in mainmapVC or chooselocationVC
@property (nonatomic,strong) NSString* gUserAddress;

// is on JOB?
@property BOOL gIsOnJob;

//advanced booking form
@property (nonatomic,strong) NSMutableDictionary* gAdvancedForm;

//current booking form
@property (nonatomic,strong) NSMutableDictionary* gCurrentForm;


+ (GlobalVariables*)myGlobalVariables;
- (void) clearGlobalData;

@end