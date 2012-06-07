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
    
    NSMutableDictionary* gDriverInfo;
    
    NSString* gTaxiType;


}

//driver list generated for map markers
@property (nonatomic, strong) NSMutableDictionary* gDriverList; 

//user location per corelocation
@property CLLocationCoordinate2D gUserCoordinate;

//destination location as defined in submitjobVC. Can be 0,0 ie nil
@property CLLocationCoordinate2D gDestiCoordinate;

//pickup location details. entered in submitjobVC
@property (nonatomic,strong) NSString* gPickupString;

//manually input in submitjobVC or selected through choose location to reflect google places location
@property (nonatomic,strong) NSString* gDestinationString;

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


+ (GlobalVariables*)myGlobalVariables;
- (void) clearGlobalData;

@end