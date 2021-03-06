//
//  MyTripsViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 09/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityProgressView;
@interface MyTripsViewController : UITableViewController
{
    NSArray* myArray;
    NSArray* futureArray;
    NSArray* pastArray;
    
    NSMutableDictionary* selectedDict;
    NSString* selectedTripType;
    ActivityProgressView* activityContainer;
}
-(void)gotoSelectedTrip;
-(void) reloadTable;
@end
