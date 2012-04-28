//
//  UserLocation.m
//  PaxApp
//
//  Created by Junyuan Lau on 20/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserLocationAnnotation.h"
#import "GlobalVariables.h"
#import "GetGeocodedAddress.h"

@implementation UserLocationAnnotation
@synthesize coordinate, subTitle, title, geoAddress;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    NSLog(@"New marker position");   
    coordinate=newCoordinate;
    [[GlobalVariables myGlobalVariables] setGUserCoordinate:newCoordinate];
    GetGeocodedAddress *getGeo = [[GetGeocodedAddress alloc]init];
    [getGeo geocodeLocation:[[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude]];
    
    
}

-(id)setCoordinateWithGV
{
    coordinate=[[GlobalVariables myGlobalVariables] gUserCoordinate];
    return self;

}


-(id)initWithCoordinate:(CLLocationCoordinate2D) c
{
	coordinate=c;
	//NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}


-(NSString *)title
{
    return @"User Location";
}

//    UserLocationItem *item = [[UserLocationItem alloc]init];
//[item initWithCoordinate:newLocation.coordinate];
@end