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
    
    NSString* gDriver_id;
    NSString* gJob_id;
    NSString* gUserAddress;
    
    NSMutableDictionary* gDriverInfo;
    
    NSString* gTaxiType;
    
    NSString* gDeviceToken;
    NSDate* gJobTime;
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

// Job start time
@property (nonatomic,strong) NSDate* gJobTime;

//user location per corelocation
@property CLLocationCoordinate2D gUserCoordinate;

//selected driver discovered in submitjobVC after submitting job and retrieving from server
@property (nonatomic,strong) NSString* gDriver_id;

//job_id discovered in submitjobVC after submitting job
@property (nonatomic,strong) NSString* gJob_id;

//reverse geocoded address of gUserCoordinate. determined in mainmapVC or chooselocationVC
@property (nonatomic,strong) NSString* gUserAddress;

//selected driver information retreived from drivers database
@property (nonatomic,strong) NSMutableDictionary* gDriverInfo;

//taxitype selected
@property (nonatomic,strong) NSString* gTaxiType;

// is on JOB?
@property BOOL gIsOnJob;

//advanced booking form
@property (nonatomic,strong) NSMutableDictionary* gAdvancedForm;

//current booking form
@property (nonatomic,strong) NSMutableDictionary* gCurrentForm;


+ (GlobalVariables*)myGlobalVariables;
- (void) clearGlobalData;

@end