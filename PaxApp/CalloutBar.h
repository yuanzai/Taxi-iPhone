//
//  CalloutBar.h
//  PaxApp
//
//  Created by Junyuan Lau on 28/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalloutBar : NSObject
{
    IBOutlet UILabel *topBar;
    IBOutlet UILabel *bottomBar;
    
    
}
@property (strong,nonatomic) IBOutlet UILabel *topBar;
@property (strong,nonatomic) IBOutlet UILabel *bottomBar;

-(void)hideUserBar;
-(void)showUserBarWithGeoAddress;
-(void)showDriverBarWithETA:(NSString*)ETA driver_id:(NSString*)driver_id;

@end
