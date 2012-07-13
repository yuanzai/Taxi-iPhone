//
//  FavouritesViewController.h
//  PaxApp
//
//  Created by Junyuan Lau on 29/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FavouritesViewController : UITableViewController
{
    NSMutableArray* addressList;

}

@property NSInteger refererTag;
-(void)gotoSubmitJob;
-(void)gotoAdvanced;

@end
